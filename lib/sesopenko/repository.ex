defmodule Sesopenko.ECS.Repository do
  @moduledoc """
  Provides data operations for entities and their components.

  Example Usage:
  ```elixir
  # Instantiate repository:
  {:ok, pid} = Sesopenko.ECS.Repository.start_link()

  # Create an entity with given component data:
  {:ok, entity_id} = Sesopenko.ECS.Repository.add_entity(pid, %{
    first_component_type: %{
      data: 1,
      other: 2,
    },
    second_component_type: %{
      something: "foo",
      other_think: [1, 2, 3]
    }
  })

  # Fetch the entity:
  {:ok, entity_component_data} = Sesopenko.ECS.Repository.fetch_entity(pid, entity_id)

  # Get a complete list of entity data for a given component type:
  component_type = :second_component_type
  {:ok, component_data_list} = Sesopenko.ECS.Repository.list_data_for_component_type(pid, component_type)
  ```

  """
  alias Sesopenko.ECS.Repository
  use GenServer

  @type uuid :: charlist()
  @type entity_id :: uuid()

  @type component_type :: atom()
  @type component_data :: %{atom() => any()}
  @type component_data_set :: %{component_type => component_data}

  defstruct data_entity_components: %{},
            index_component_entities: %{},
            index_entity_components: %{}

  @doc """
  Starts a Repository process link which can be used to query against.

  Usage:
  ```elixir
  pid = Sesopenko.ECS.Repository.start_link()
  ```
  """
  @spec start_link() :: {:ok, pid}
  def start_link() do
    {:ok, repo_pid} = GenServer.start_link(Repository, nil)
    {:ok, repo_pid}
  end

  @doc """
  Adds an entity.

  The input `component_data_set` must be a map, keyed by component type atoms.
  The component data for each key can be any native elixir type.

  Example usage:
  ```elixir
  {:ok, entity_id} = Sesopenko.ECS.Repository.add_entity(pid, %{
    first_component_type: %{
      data: 1,
      other: 2,
    },
    second_component_type: %{
      something: "foo",
      other_think: [1, 2, 3]
    }
  })
  ```
  """
  @spec add_entity(pid, component_data_set) :: type :: {:ok, entity_id}
  def add_entity(pid, component_map) do
    {:ok, entity_id} = GenServer.call(pid, {:add_entity, component_map})
    {:ok, entity_id}
  end

  @doc """
  Fetches an entity by entity id.

  Example usage:
  ```elixir
  entity_id = "7533af4e-5531-11ea-9263-000c292c6160"
  {:ok, entity_component_data} = Sesopenko.ECS.Repository.fetch_entity(pid, entity_id)
  ```

  The return is a `map()` keyed by component type, with each value being a `map()` of component data.
  """
  @spec fetch_entity(pid(), entity_id) :: {:ok, component_data_set}
  def fetch_entity(pid, entity_id) do
    {:ok, data} = GenServer.call(pid, {:fetch_entity, entity_id})
    {:ok, data}
  end

  @doc """
  Provides a list of all data for a given component type.

  Example usage:
  ```elixir
  component_type = :bears_fruit
  {:ok, component_data_list} = Sesopenko.ECS.Repository.list_data_for_component_type(pid, component_type)
  ```
  """
  @spec list_data_for_component_type(pid, component_type) :: {:ok, list(component_data)}
  def list_data_for_component_type(pid, component_type) do
    {:ok, component_data_list} =
      GenServer.call(pid, {:list_data_for_component_type, component_type})

    {:ok, component_data_list}
  end

  @doc false
  def init(_) do
    {:ok, %Repository{}}
  end

  @doc false
  def handle_call({:add_entity, component_map}, _from, %Repository{} = starting_state) do
    entity_id = UUID.uuid1()

    component_types = Map.keys(component_map)

    updated_state =
      starting_state
      # update index mapping component types keyed by entity id
      |> Map.update(
        # TODO: this is wrong & needs to be reversed
        :index_entity_components,
        %{
          entity_id => component_types
        },
        fn entity_index ->
          add_entity_to_index_entity_components(entity_id, component_types, entity_index)
        end
      )
      # update index mapping entity ids keyed by component type
      |> Map.update(
        :index_component_entities,
        build_first_index_component_entities(entity_id, component_types),
        fn current_index ->
          Enum.reduce(component_types, current_index, fn component_type, acc ->
            Map.update(acc, component_type, [entity_id], fn entity_list ->
              [entity_id | entity_list]
            end)
          end)
        end
      )
      |> Map.update(
        :data_entity_components,
        build_first_data_entity_components(entity_id, component_map),
        fn current_data_entity_component ->
          Enum.reduce(component_types, current_data_entity_component, fn component_type, acc ->
            key = {entity_id, component_type}
            Map.put(acc, key, component_map[component_type])
          end)
        end
      )

    # Add to component data
    {:reply, {:ok, entity_id}, updated_state}
  end

  @doc false
  def handle_call({:fetch_entity, entity_id}, _from, repo_state) do
    # get the components for the given entity
    # build map from all component data
    index_entity_components = repo_state.index_entity_components

    entity_components = index_entity_components[entity_id]
    data_entity_component = repo_state.data_entity_components

    entity_state =
      Map.new(entity_components, fn component_type ->
        fetch_index = {entity_id, component_type}
        data = data_entity_component[fetch_index]
        key = component_type
        {key, data}
      end)

    {:reply, {:ok, entity_state}, repo_state}
  end

  @doc false
  def handle_call(
        {:list_data_for_component_type, component_type},
        _from,
        %Repository{} = repo_state
      ) do
    entities_by_component = repo_state.index_component_entities

    if !Map.has_key?(entities_by_component, component_type) do
      {:reply, {:ok, []}, repo_state}
    else
      entity_ids = entities_by_component[component_type]

      result =
        Enum.map(entity_ids, fn entity_id ->
          data_key = {entity_id, component_type}
          repo_state.data_entity_components[data_key]
        end)

      {:reply, {:ok, result}, repo_state}
    end
  end

  defp add_entity_to_index_entity_components(
         entity_id,
         entity_component_types,
         components_by_entity_id
       ) do
    # build a map
    # indexed by entity id
    # each containing
    # list of component types

    Enum.reduce(entity_component_types, components_by_entity_id, fn entity_component_type,
                                                                    by_in_progress ->
      list_if_first_component = [entity_component_type]

      Map.update(
        by_in_progress,
        entity_id,
        list_if_first_component,
        fn current_component_list ->
          [entity_component_type | current_component_list]
        end
      )
    end)
  end

  defp build_first_index_component_entities(entity_id, component_types) do
    Map.new(component_types, fn component_type ->
      {component_type, [entity_id]}
    end)
  end

  defp build_first_data_entity_components(entity_id, component_map) do
    Map.new(Map.keys(component_map), fn component_type ->
      component_data = component_map[component_type]
      key = {entity_id, component_type}
      {key, component_data}
    end)
  end
end

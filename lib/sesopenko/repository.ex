defmodule Sesopenko.ECS.Repository do
  alias Sesopenko.ECS.Repository
  use GenServer

  defmacro fresh_list(input_list) do
    quote do
      [unquote(input_list)]
    end
  end

  defstruct data_entity_components: %{},
            index_component_entities: %{},
            index_entity_components: %{}

  def init(_) do
    {:ok, %Repository{}}
  end

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
          new_index =
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

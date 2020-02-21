defmodule Sesopenko.ECS.ComponentRegistry do
  use GenServer
  alias Sesopenko.ECS.Component.State
  alias Sesopenko.ECS.ComponentRegistry

  defstruct type_state_map: %{}, type_sub: %{}

  @doc """
  Initializes a component store.

  Warning:  it is not linked so if the parent process ends it will still live.
  """
  def start() do
    {:ok, pid} = GenServer.start(__MODULE__, %ComponentRegistry{}, name: __MODULE__)
    pid
  end

  @doc """
  Deletes the named process
  """
  def stop() do
    :ok = GenServer.stop(__MODULE__)
  end

  @doc """
  Gets a list of copmonents for a given type
  """
  @spec get_list(type :: atom()) :: type :: list(type :: pid())
  def get_list(component_type) when is_atom(component_type) do
    GenServer.call(__MODULE__, {:stream_components_by_type, component_type})
  end

  @doc """
  Adds a new component for a given component type
  """
  @spec add(type :: atom(), type :: map()) :: nil
  def add(component_type, initial_state) when is_atom(component_type) do
    GenServer.call(__MODULE__, {:add_component, component_type, initial_state})
  end

  @impl true
  def init(initial_state \\ %ComponentRegistry{}) do
    {:ok, initial_state}
  end

  @spec subscribe_by_component(type :: atom(), type :: pid()) :: type :: atom()
  def subscribe_by_component(component_type, pid) do
    GenServer.call(__MODULE__, {:subscribe_by_component, component_type, pid})
    :ok
  end

  @impl true
  def handle_call({:stream_components_by_type, component_type}, _from, current_registry) do
    if Map.has_key?(current_registry.type_state_map, component_type) do
      {:reply, current_registry.type_state_map[component_type], current_registry}
    else
      {:reply, [], current_registry}
    end
  end

  def handle_call({:subscribe_by_component, component_type, sub_pid}, _from, current_registry) do
    blank_slate = [sub_pid]

    updated_sub_registry =
      Map.update(
        current_registry,
        :type_sub,
        %{
          component_type => blank_slate
        },
        fn current_sub_map ->
          Map.update(
            current_sub_map,
            component_type,
            blank_slate,
            fn current_list ->
              [sub_pid | current_list]
            end
          )
        end
      )

    # loop over current states & subscribe
    component_list =
      if(Map.has_key?(updated_sub_registry.type_state_map, component_type),
        do: updated_sub_registry.type_state_map[component_type],
        else: []
      )

    for state_pid <- component_list do
      State.sub(state_pid, sub_pid)
    end

    {:reply, :ok, updated_sub_registry}
  end

  @impl true
  def handle_call(
        {:add_component, component_type, initial_component_state},
        _from,
        current_registry
      ) do
    sub_list =
      if(Map.has_key?(current_registry.type_sub, component_type),
        do: current_registry.type_sub[component_type],
        else: []
      )

    component_pid = State.spawn_link(initial_component_state, component_type, sub_list)

    {:reply, :ok,
     Map.update(
       current_registry,
       :type_state_map,
       %{
         component_type => [component_pid]
       },
       fn current_type_state_map ->
         Map.update(
           current_type_state_map,
           component_type,
           [component_pid],
           fn current_component_list ->
             [component_pid | current_component_list]
           end
         )
       end
     )}
  end
end

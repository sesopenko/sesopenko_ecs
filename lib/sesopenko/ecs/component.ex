defmodule Sesopenko.ECS.Component do
  use GenServer
  alias Sesopenko.ECS.Component.State

  @doc """
  Initializes a component store.

  Warning:  it is not linked so if the parent process ends it will still live.
  """
  def initialize() do
    {:ok, pid} = GenServer.start(__MODULE__, %{}, name: __MODULE__)
    pid
  end

  @doc """
  Deletes the named process
  """
  def teardown() do
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
  def init(initial_state \\ %{}) do
    {:ok, initial_state}
  end

  @impl true
  def handle_call({:stream_components_by_type, component_type}, _from, current_state) do
    if Map.has_key?(current_state, component_type) do
      {:reply, current_state[component_type], current_state}
    else
      {:reply, [], current_state}
    end
  end

  @impl true
  def handle_call(
        {:add_component, component_type, initial_component_state},
        _from,
        current_component_map
      ) do
    component_pid = State.spawn_link(initial_component_state)

    blank_slate = [component_pid]

    new_map =
      Map.update(
        current_component_map,
        component_type,
        blank_slate,
        fn current_list ->
          [component_pid | current_list]
        end
      )

    {:reply, nil, new_map}
  end
end

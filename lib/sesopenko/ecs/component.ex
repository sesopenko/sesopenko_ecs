defmodule Sesopenko.ECS.Component do
  use GenServer
  alias Sesopenko.ECS.Component.State

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
    {:ok, component_pid} =
      GenServer.start_link(State, %State{
        state: initial_component_state
      })

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

  def get_stream(component_type) do
    GenServer.call(__MODULE__, {:stream_components_by_type, component_type})
  end

  # how to store these component states
  # ETS: erlang's ets store system.  Accepts native elixir types, like maps.
  # Should be performant
  def add(component_atom, initial_state) do
    GenServer.call(__MODULE__, {:add_component, component_atom, initial_state})
  end

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
end

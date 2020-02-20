defmodule Sesopenko.ECS.Component do
  use GenServer

  @impl true
  def init(initial_state \\ %{}) do
    {:ok, initial_state}
  end

  @impl true
  def handle_call({:stream_components_by_type, component_type}, _from, current_state) do
    {:reply, current_state, current_state}
  end

  @impl true
  def handle_call(
        {:add_component, component_type, initial_component_state},
        _from,
        current_component_map
      ) do
    new_component = %{
      state: initial_component_state
    }

    blank_slate = [new_component]

    new_map =
      Map.update(
        current_component_map,
        component_type,
        blank_slate,
        fn current_list ->
          [new_component | current_list]
        end
      )

    {:reply, nil, new_map}
  end

  def get_stream(component_type) do
    stream = GenServer.call(__MODULE__, {:stream_components_by_type, component_type})

    if Map.has_key?(stream, component_type) do
      stream[component_type]
    else
      []
    end
  end

  # how to store these component states
  # ETS: erlang's ets store system.  Accepts native elixir types, like maps.
  # Should be performant
  def add(component_atom, initial_state) do
    GenServer.call(__MODULE__, {:add_component, component_atom, initial_state})
  end

  def initialize() do
    {:ok, pid} = GenServer.start(__MODULE__, %{}, name: __MODULE__)
    pid
  end

  def teardown() do
    :ok = GenServer.stop(__MODULE__)
  end
end

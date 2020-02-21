defmodule Sesopenko.ECS.Component.State do
  defstruct state: %{}, subs: [], component: nil
  alias Sesopenko.ECS.Component.State
  use GenServer
  @impl true
  def init(%State{} = initial_state \\ %State{}) do
    for sub_pid <- initial_state.subs do
      send(sub_pid, {:state_changed, initial_state.component, initial_state.state})
    end

    {:ok, initial_state}
  end

  @impl true
  def handle_call({:get_state}, _from, current_state) do
    {:reply, current_state, current_state}
  end

  @impl true
  def handle_call({:update_state, new_state}, _from, current_component) do
    updated = Map.put(current_component, :state, new_state)
    subs = current_component.subs

    for sub_pid <- subs do
      send(sub_pid, {:state_changed, current_component.component, new_state})
    end

    {:reply, nil, updated}
  end

  def handle_call({:sub, sub_pid}, _from, current_component) do
    {
      :reply,
      :ok,
      Map.update!(current_component, :subs, fn current_subs ->
        [sub_pid | current_subs]
      end)
    }
  end

  @doc """
  Spawns a component state with the given map as initial state
  """
  @spec spawn_link(type :: map(), type :: atom(), type :: list()) :: type :: pid()
  def spawn_link(initial_component_state, component, subs \\ []) do
    new_state = initial_component_state

    {:ok, component_pid} =
      GenServer.start_link(State, %State{
        state: new_state,
        component: component,
        subs: subs
      })

    component_pid
  end

  @doc """
  Gets the state of a given component state process.
  """
  @spec get(type :: pid()) :: type :: map()
  def get(pid) do
    GenServer.call(pid, {:get_state})
  end

  @doc """
  sets the state of a given component state process with the given map.
  """
  @spec update(type :: pid, type :: map()) :: nil
  def update(pid, new_state) do
    GenServer.call(pid, {:update_state, new_state})
  end

  def sub(state_pid, sub_pid) do
    GenServer.call(state_pid, {:sub, sub_pid})
  end
end

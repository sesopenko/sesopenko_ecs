defmodule Sesopenko.ECS.Component.State do
  defstruct state: %{}
  alias Sesopenko.ECS.Component.State
  use GenServer
  @impl true
  def init(
        initial_state \\ %State{
          state: %{}
        }
      ) do
    {:ok, initial_state}
  end

  @impl true
  def handle_call({:get_state}, _from, current_state) do
    {:reply, current_state, current_state}
  end

  @impl true
  def handle_call({:update_state, new_state}, _from, current_component) do
    updated = Map.put(current_component, :state, new_state)
    {:reply, nil, updated}
  end

  @doc """
  Spawns a component state with the given map as initial state
  """
  @spec spawn_link(type :: map()) :: type :: pid()
  def spawn_link(initial_component_state) do
    new_state = initial_component_state

    {:ok, component_pid} =
      GenServer.start_link(State, %State{
        state: new_state
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
end
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

  def get(pid) do
    GenServer.call(pid, {:get_state})
  end

  def update(pid, new_state) do
    GenServer.call(pid, {:update_state, new_state})
  end
end

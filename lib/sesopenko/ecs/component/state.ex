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

  def handle_call({:get_state}, _from, current_state) do
    {:reply, current_state, current_state}
  end
end

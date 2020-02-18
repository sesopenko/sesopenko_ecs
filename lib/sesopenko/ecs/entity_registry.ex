defmodule Sesopenko.ECS.EntityRegistry do
  use GenServer

  def init(initial_state \\ %{}) do
    {:ok, initial_state}
  end

  @doc """
  Replies with {:ok, entity_list}
  """
  def handle_call({:get_entities_for_component, component_type}, _from_process, current_state) do
    if Map.has_key?(current_state, component_type) do
      {:reply, {:ok, Map.get(current_state, component_type)}, current_state}
    else
      {:reply, {:ok, []}, current_state}
    end
  end

  def handle_call(
        {:add_entity_for_component, input_entity, component_type},
        _from_process,
        current_registry
      ) do
    new_state =
      Map.update(current_registry, component_type, [input_entity], fn current_list ->
        [input_entity | current_list]
      end)

    {:reply, :ok, new_state}
  end
end

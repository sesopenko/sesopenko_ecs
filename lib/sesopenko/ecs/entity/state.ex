defmodule Sesopenko.ECS.Entity.State do
  use Agent
  alias Sesopenko.ECS.Entity.State
  alias Sesopenko.ECS.ComponentRegistry

  defstruct [:id, components: []]

  @spec start_link(type :: map()) :: type :: {:ok, type :: pid()}
  def start_link(component_specs) do
    # create components with initial state
    components =
      Enum.reduce(Map.keys(component_specs), %{}, fn spec_component_type, acc ->
        initial_state = component_specs[spec_component_type]
        {:ok, component_pid} = ComponentRegistry.add(spec_component_type, initial_state)
        Map.put(acc, spec_component_type, component_pid)
      end)

    {:ok, pid} =
      Agent.start_link(fn ->
        %State{
          id: UUID.uuid1(),
          components: components
        }
      end)

    {:ok, pid}
  end

  @spec fetch_entity(pid) :: %State{}
  def fetch_entity(entity_pid) do
    entity_state = Agent.get(entity_pid, fn state -> state end)
    entity_state
  end

  @spec load_component_states(%State{}) :: type :: {:ok, type :: map()}
  def load_component_states(%State{} = entity) do
    component_links = entity.components

    loaded =
      Enum.reduce(Map.keys(component_links), %{}, fn component_type, acc ->
        component_pid = component_links[component_type]
        component = Sesopenko.ECS.Component.State.get(component_pid)
        Map.put(acc, component_type, component.state)
      end)

    {:ok, loaded}
  end
end

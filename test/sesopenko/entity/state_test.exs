defmodule Sesopenko.ECS.Entity.StateTest do
  use ExUnit.Case
  alias Sesopenko.ECS.Entity.State
  alias Sesopenko.ECS.ComponentRegistry

  setup do
    ComponentRegistry.start()

    on_exit(fn ->
      ComponentRegistry.stop()
    end)

    :ok
  end

  test "load_all_components" do
    # Arrange.
    # create component spec
    input_component_spec = %{
      fruit: %{
        has_fruit: true
      },
      location: %{
        x: 0,
        y: 12
      }
    }

    # Act.
    # Create entity state
    {:ok, pid} = State.start_link(input_component_spec)
    # access each component
    entity = State.fetch_entity(pid)
    {:ok, components_states} = State.load_component_states(entity)
    # Assert.
    IO.inspect(components_states, label: "components")
    assert Map.has_key?(components_states, :fruit)
    assert Map.has_key?(components_states, :location)
    assert components_states[:fruit] == %{has_fruit: true}

    assert components_states[:location] == %{
             x: 0,
             y: 12
           }
  end
end

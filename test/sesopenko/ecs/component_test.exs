defmodule Sesopenko.ECS.ComponentTest do
  use ExUnit.Case
  alias Sesopenko.ECS.Component

  setup do
    Component.initialize()

    on_exit(fn ->
      Component.teardown()
    end)

    :ok
  end

  # Ideal: no need to create files for each type of component. they can be atoms.

  test "construct components, with initial state, and find it in a list" do
    # initial game state, defining apple trees
    empty_fruit_state = %{
      has_fruit: true
    }

    full_fruit_state = %{
      has_fruit: false
    }

    component_name = :fruit

    # Arrange.
    # Act.

    Component.add(component_name, empty_fruit_state)
    Component.add(component_name, full_fruit_state)

    component_stream = Component.get_stream(component_name)

    # Assert.
    # map the stream to get an actual list
    component_list =
      Enum.map(component_stream, fn fruit_component ->
        fruit_component.state
      end)

    # should have count of 2
    assert length(component_list) == 2
    # Should have both items in the list
    # find first
    _empty_fruit_state =
      Enum.find(component_list, :not_found, fn candidate ->
        candidate == empty_fruit_state
      end)

    # find second
    _full_fruit_state =
      Enum.find(component_list, :not_found, fn candidate ->
        candidate == full_fruit_state
      end)
  end

  test "get stream of components and ability to update each, in situ" do
    # apple tree system adding apples
  end

  test "be notified when a specific component state changes" do
  end
end

defmodule Sesopenko.ECS.ComponentRegistryTest do
  use ExUnit.Case
  alias Sesopenko.ECS.ComponentRegistry
  alias Sesopenko.ECS.Component.State

  setup do
    ComponentRegistry.start()

    on_exit(fn ->
      ComponentRegistry.stop()
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

    ComponentRegistry.add(component_name, empty_fruit_state)
    ComponentRegistry.add(component_name, full_fruit_state)

    component_stream = ComponentRegistry.get_list(component_name)

    # Assert.
    # map the stream to get an actual list
    component_list =
      Enum.map(component_stream, fn fruit_component_pid ->
        component = State.get(fruit_component_pid)
        component.state
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
    # initial game state, defining apple trees
    empty_fruit_state = %{
      has_fruit: true
    }

    full_fruit_state = %{
      has_fruit: true
    }

    component_name = :fruit

    # Arrange.
    # Act.

    ComponentRegistry.add(component_name, empty_fruit_state)
    ComponentRegistry.add(component_name, full_fruit_state)

    component_stream = ComponentRegistry.get_list(component_name)

    for current_component_pid <- component_stream do
      # get current value
      component = State.get(current_component_pid)
      ## update with inverted value
      new_state = Map.put(component.state, :has_fruit, !component.state.has_fruit)
      State.update(current_component_pid, new_state)
    end

    new_stream = ComponentRegistry.get_list(component_name)

    Enum.each(new_stream, fn component_pid ->
      component = State.get(component_pid)
      assert component.state.has_fruit == false
    end)
  end

  test "be notified when a specific component state changes" do
    target_component = :fruit
    {:ok, agent} = Agent.start_link(fn -> [] end)

    handle_forever = fn ->
      receive do
        {:state_changed, :fruit, new_state} ->
          Agent.update(agent, fn current_list ->
            [new_state | current_list]
          end)
      after
        1_000 -> :fail
      end

      receive do
        {:state_changed, :fruit, new_state} ->
          Agent.update(agent, fn current_list ->
            [new_state | current_list]
          end)
      after
        1_000 -> :fail
      end
    end

    my_pid = spawn_link(handle_forever)
    empty_tree = %{has_fruit: false}
    full_tree = %{has_fruit: true}

    # ComponentRegistry.listen_by_type(:fruit, my_pid)
    :ok = ComponentRegistry.subscribe_by_component(target_component, my_pid)
    ComponentRegistry.add(target_component, empty_tree)

    ComponentRegistry.add(target_component, full_tree)
    # get state from the agent

    assert true ==
             Agent.get(agent, fn agent_state ->
               # expect two updates in our genserver.
               assert length(agent_state) == 2
               assert agent_state == [full_tree, empty_tree]
             end)

    Process.exit(my_pid, :kill)
  end
end

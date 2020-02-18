defmodule Sesopenko.ECS.EntityRegistryTest do
  alias Sesopenko.ECS.EntityRegistry
  use ExUnit.Case

  describe "should be able to get entities of a specific component type as string" do
    test "should be able to get an empty list when there are no components" do
      # Arrange.
      input_type = "stomache"
      {:ok, registry_pid} = GenServer.start_link(EntityRegistry, %{})
      # Act.
      # fetch for component type
      {:ok, entity_list} = GenServer.call(registry_pid, {:get_entities_for_component, input_type})
      # Assert.
      assert length(entity_list) == 0
    end

    test "should be able to get an entity for a component in which we've added it" do
      # Arrange
      input_entity = %{stomache: 100}
      {:ok, registry_pid} = GenServer.start_link(EntityRegistry, %{})
      component_type = "stomache"

      :ok =
        GenServer.call(registry_pid, {:add_entity_for_component, input_entity, component_type})

      # Act
      {:ok, entity_list} =
        GenServer.call(registry_pid, {:get_entities_for_component, component_type})

      # Assert
      assert length(entity_list) == 1
      assert [input_entity | _] = entity_list
    end

    test "should be able to add two entities and get them both back" do
      # Arrange
      input_entity_full_stomache = %{stomache: 100}
      input_entity_empty_stomache = %{stomache: 0}
      {:ok, registry_pid} = GenServer.start_link(EntityRegistry, %{})
      component_type = "stomache"

      GenServer.call(
        registry_pid,
        {:add_entity_for_component, input_entity_full_stomache, component_type}
      )

      GenServer.call(
        registry_pid,
        {:add_entity_for_component, input_entity_empty_stomache, component_type}
      )

      # Act
      {:ok, entity_list} =
        GenServer.call(registry_pid, {:get_entities_for_component, component_type})

      # Assert
      assert length(entity_list) == 2

      # should find both entities in list
      assert input_entity_full_stomache ==
               Enum.find(entity_list, :not_found, fn candidate_entity ->
                 candidate_entity == input_entity_full_stomache
               end)

      assert input_entity_empty_stomache ==
               Enum.find(entity_list, :not_found, fn candidate_entity ->
                 candidate_entity == input_entity_empty_stomache
               end)
    end
  end

  describe "updating specific entities" do
  end
end

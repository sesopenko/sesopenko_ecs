defmodule Sesopenko.ECS.RepositoryTest do
  alias Sesopenko.ECS.Repository
  use ExUnit.Case

  describe "creating and fetching an entity by entity id" do
    # Arrange.
    input_component_data = %{
      fruit_component: %{
        quantity: 100
      },
      position_component: %{
        x: 5,
        y: 13
      }
    }

    # Act.
    {:ok, repo_pid} = GenServer.start_link(Repository, nil)
    {:ok, entity_id} = GenServer.call(repo_pid, {:add_entity, input_component_data})
    {:ok, entity_data} = GenServer.call(repo_pid, {:fetch_entity, entity_id})

    # Assert.
    assert Map.has_key?(entity_data, :fruit_component)

    assert entity_data.fruit_component == %{
             quantity: 100
           }

    assert Map.has_key?(entity_data, :position_component)

    assert entity_data.position_component == %{
             x: 5,
             y: 13
           }

    # Cleanup
    GenServer.stop(repo_pid)
  end

  describe "walking all components" do
  end

  describe "deleting an entity" do
  end

  describe "adding a component to an entity" do
  end

  describe "removing a component from an entity" do
  end
end

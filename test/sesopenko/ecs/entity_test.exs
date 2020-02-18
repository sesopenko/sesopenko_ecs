defmodule Sesopenko.ECS.EntityTest do
  use ExUnit.Case
  alias Sesopenko.ECS.Entity

  # has an id
  # has components

  test "should create an entity" do
    # Arrange
    input_components = %{
      stomache: 20,
      height: 12
    }

    # Act
    new_entity = Entity.build(input_components)
    # Assert
    # should have an id
    assert Map.has_key?(new_entity, :id)
    assert not is_nil(new_entity.id)
    assert is_binary(new_entity.id)
    assert Map.has_key?(new_entity.components, :stomache)
    assert new_entity.components.stomache == 20
    assert Map.has_key?(new_entity.components, :height)
    assert new_entity.components.height == 12
  end
end

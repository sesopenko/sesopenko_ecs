defmodule Sesopenko.ECSTest do
  use ExUnit.Case
  doctest Sesopenko.ECS

  test "greets the world" do
    assert Sesopenko.ECS.hello() == :world
  end
end

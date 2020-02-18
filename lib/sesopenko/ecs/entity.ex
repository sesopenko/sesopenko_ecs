defmodule Sesopenko.ECS.Entity do
  defstruct [:id, :components]

  @type id :: String.t()
  @type components :: map()
  @type t :: %Sesopenko.ECS.Entity{
          id: String.t(),
          components: components
        }

  @doc "Creates a new entity"
  @spec build(components) :: t
  def build(components) do
    %Sesopenko.ECS.Entity{
      id: UUID.uuid1(),
      components: components
    }
  end
end

# Sesopenko.ECS

* System
* Components
  * Pub/Sub the system to listen to events and publish events
  * ends up making updates to entity state
* Entities
  * Data structures for the components they posses

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `sesopenko_ecs` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:sesopenko_ecs, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/sesopenko_ecs](https://hexdocs.pm/sesopenko_ecs).

Sources:
* [Entity Component System - Wikipedia](https://en.wikipedia.org/wiki/Entity_component_system)
* [Entity Component Systems in Elixir- Yos Riady](https://yos.io/2016/09/17/entity-component-systems/)
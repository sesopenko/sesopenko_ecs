# Sesopenko.ECS

This is an implementation of the Entity Component System software structural architecture, aimed towards game server development.

From [Wikipedia, Entity component systsem](https://en.wikipedia.org/wiki/Entity_component_system):
> Entity–component–system (ECS) is an architectural pattern that is mostly used in game development. ECS follows the composition over inheritance principle that allows greater flexibility in defining entities where every object in a game's scene is an entity (e.g. enemies, bullets, vehicles, etc.). Every entity consists of one or more components which add behavior or functionality. Therefore, the behavior of an entity can be changed at runtime by adding or removing components. This eliminates the ambiguity problems of deep and wide inheritance hierarchies that are difficult to understand, maintain and extend. Common ECS approaches are highly compatible and often combined with data-oriented design techniques.

## Architecture Decision Record

This project maintains an Architecture Decision Record, located in the [adr/](adr/) path. The first record, which explains the process, is [adr/ADR-1.md](adr/ADR-1.md).

## Contribution

This is alpha software, with no warranty implied. If you have feature ideas please reach out via the issue system first, to discuss the feature & it's suitability.  Once we reach a conclusion on how to integrate your feature idea we can document it in the Architecture Decision Record then a pull request can be submitted.

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

## Research Sources:
* 
* [Entity Component System - Wikipedia](https://en.wikipedia.org/wiki/Entity_component_system)
* [Entity Component Systems in Elixir- Yos Riady](https://yos.io/2016/09/17/entity-component-systems/)
  * A [diagram of Yos Riady's architecture](documentation/yos_riady_ecs_design.png) is included in this project.

## Development Environment

If you are planning on contributing, you need to do the following in your dev environment:

* `mix deps.get`
* `mix deps.compile`
* Install dialyzer:
  * On Debian/Ubuntu: `apt-get install erlang-dialyzer`
  * On Fedora/Centos/Redhat: `yum install erlang-dialyzer`
* `mix dialyzer` (this will take a long while, the first time)

## LICENSE

This software is licensed GNU GPL v3.0.  A copy of this license is included in [README.md](README.md). Distributions of this software must include the attached license.  The [GNU GPL v3.0 license can be accessed online](https://www.gnu.org/licenses/gpl-3.0.en.html) if it's not attached.
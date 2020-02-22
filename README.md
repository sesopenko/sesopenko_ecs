# Sesopenko.ECS

![](https://github.com/sesopenko/sesopenko_ecs/workflows/mix%20format/badge.svg)
![](https://github.com/sesopenko/sesopenko_ecs/workflows/mix%20test/badge.svg)

This is an implementation of the Entity Component System software structural architecture, written in [Elixir](https://elixir-lang.org/) and aimed towards game server development.

From [Wikipedia, Entity component systsem](https://en.wikipedia.org/wiki/Entity_component_system):
> Entity–component–system (ECS) is an architectural pattern that is mostly used in game development. ECS follows the composition over inheritance principle that allows greater flexibility in defining entities where every object in a game's scene is an entity (e.g. enemies, bullets, vehicles, etc.). Every entity consists of one or more components which add behavior or functionality. Therefore, the behavior of an entity can be changed at runtime by adding or removing components. This eliminates the ambiguity problems of deep and wide inheritance hierarchies that are difficult to understand, maintain and extend. Common ECS approaches are highly compatible and often combined with data-oriented design techniques.

## Installation

This is alpha software and will be changing rapidly. The package is [available in Hex](https://hex.pm/packages/sesopenko_ecs), and can be installed by adding `sesopenko_ecs` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:sesopenko_ecs, "~> 0.1.0"}
  ]
end
```

## Documentation

Documentation is published on [HexDocs](https://hexdocs.pm/sesopenko_ecs/).  It can also be generated locally with `hex docs` then opening `docs/index.html` with a browser.

### Planned Features

* Pub/Sub component data changes.
* Example project

## How can I help?

Great question! First off, feedback and suggested ideas would be great and you may submit your feedback and ideas via the [github repo issue tracker](https://github.com/sesopenko/sesopenko_ecs/issues). You may also read the Architecture Decision Record (detailed below) to find out how you can contribute to active development.

If you already have code to contribute you may submit a pull request for the repo. We'll discuss & collaborate on the changes before they're merged.

## Research Sources:
* [Entity Systems are the future of MMOG development - Part 1 - Adam Martin](http://t-machine.org/index.php/2007/09/03/entity-systems-are-the-future-of-mmog-development-part-1/)
* [Entity Systems Wiki](http://entity-systems.wikidot.com/)
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

## Branching & Version Strategy

This project uses the `<major>.<minor>.<patch>` version strategy.

* `<major>`: Backwards incompatible change
* `<minor>`: Backwards compatible feature addition.
* `<patch>`: Backwards compatible bug fix.

Short living development branches can be pushed to origin with the naming format of `DEV-<issue_number>`, where `<issue_number>` matches the github issue number.  ie: `DEV-112`. If you aren't a maintainer of the git repo you may fork the repo and submit a pull request.

When forking the repo in github, if you name your branch with the same convention then it should run the same CI/CD pipeline steps, ensuring tests are passing and code is formatted.

## LICENSE

This software is licensed GNU GPL v3.0.  A copy of this license is included in [README.md](README.md). Distributions of this software must include the attached license.  The [GNU GPL v3.0 license can be accessed online](https://www.gnu.org/licenses/gpl-3.0.en.html) if it's not attached.

### License Summary

The following summarizes the GPLv3.0 license but please read the license if you plan on depending on or distributing the project.

#### Permissions

Ways you're allowed to use the software:

* Commercial use
* Modification
* Distribution
* Patent use
* Private use

#### Limitations (thinks you don't get)

* No Liability
* No Warranty

#### Conditions of use

* License and copyright notice
* State changes
* Disclose source
* Same license
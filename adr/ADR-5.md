# ADR-5 Entity Building

Systems must be able to create entities so that a game world can be generated. Entities must own a set of components and the entities need to be registered in a store which can add and remove them.

## Expected user code

Systems will be the user code of the Entity architecture. Once this is done then technically it should be possible to create Systems and build an example project.

## Deletion & Garbage Collection

Removing an entity should remove the attached components so that systems can walk & subscribe to safe state. A link between entities and components will be necessary.  Thankfully pub/sub is handled at the component state level so when a component is stopped (deleted) pubs will no longer occur.

The ComponentRegistry maintains a list of components for each component type so it'll be responsible for stopping components for a given entity.

## Explicit state defaulting

Component defaults can be explicit and if they need to be implicit then the library can be iterated upon. Leaving this for later will get us to creating an example project sooner.

Example entity creation:

```elixir
# Example of creating an entity.  Defaults are explicit.
entity = EntityRegistry.create([
  fruit: %{has_fruit: true},
  :beetle: %{stomache: 100}
])
IO.inspect(entity.id)
# Should get a UUID
IO.inspect(entity.components)
# Should get a list of atoms
IO.inspect(EntityRegistry.fetch_data(entity))
# Should get a nested map of component data for the entity
```

### Entity Agent

Entities are strictly data at this point so Elixir Agents should be acceptable. The registry facade can make interacting with the agent simpler. A module with a struct for the Entity agent will make development easier.

## Decision

We will build an entity data structure which links an entity to multiple component instances. We will build a facade module for creating entities with initial components & their state. Implicit defaults for components is out of scope. Adding/removing components after entity instantiation is out of scope.

## Status

Accepted

## Consequences

Describe the resulting context, after applying the decision. All consequences should be listed here, not just the "positive" ones. A particular decision may have positive, negative, and neutral consequences but all of them affect the team and project in the future.
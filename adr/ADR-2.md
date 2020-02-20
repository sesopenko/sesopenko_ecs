# ADR-2 

Entity interaction is interesting & leads to emergent game-play.

For example:

* a beetle eating an apple (beetle & apple)
* player seeing a bettle
* player seeing an apple
* player avatar bunny
* player eats apple
* beetle hurts player

An entity component system makes it easier to decouple the behaviours from our entities.  We need a means for entities to affect each others' state while handling the complexity of the types of interactions, and the asynchronous nature in which they occur.

Example System:

* Combat System
  * "hits" target entity
  * "reduces target health"
* Eat System
  * impacts 2 target entities
    * completely removing one (ie: apple))
    * increase health of eater

* Combat System needs to know which things Entities can hurt
  * Can't hurts walls, for example
  * needs to know if it's a valid target (is it close enough?)

Problem: advancement of time and race conditions of entities trying to interact with each other.  IE:  two entities trying to hit each other, both with fatal blows, simultaneously.

Questions:
* can one entity cancel the other's action because it hit "first"?

Couple options for race conditions:
* Overwatch's handling of this:
  * hitscan bullet fire can rewind time.  If one player were to hit another player with a bullet and the result of that hit were to cancel the execution of another player's maneuver, overwatch lets it cancel it.
* Tablestop strategy games will often let both happen.  There's no cancelling.  State gets updated in one phase, then once all state is updated, the entities which are "killed" are removed.  Can end up with entities killing each other in one tick.

ie: `SystemVisibilityClient` will fetch all entities with "Visible" components, and perform a client update broadcast, using the state of each entity's `Location` component

When it comes to client/server interaction in an asynchronous manner, websockets are easy to implement because they're standardized.

## Decision

We will build the following:

An `Entity Registry` that has a collection of entities which can be queried by `Component` type.

`Entities` have a collection of `Components`, which state structures (entities are just collections of state)
  `Entities` will be `Agents` (Elixir abstraction)

We will build a `System` for each `Component` type, they can go to the `Entity Registry` and get entities (of its type, or even other types) to manipulate, based on it's responsibilities.

We will create a client which displays beetles and apples.
We will create gameplay mechanic for beetles eating apples.
We will update the client with a new apple list when a beetle eats an apple
Beetles will eat apples when they're hungry (when time advances).

We will build the following systems:
* Biological mechanics system which will increase hunger of beetles
* Beetle eating system which will decrease hunger of beetles and remove apples
* Client update system (websockets)

## Status

Deprecated by ADR-3.md due to limitations of the architecture design.

## Consequences

Describe the resulting context, after applying the decision. All consequences should be listed here, not just the "positive" ones. A particular decision may have positive, negative, and neutral consequences but all of them affect the team and project in the future.

* Optimal components are updated as a whole. A system which updates only some components wastes time iterating over components which are going to be skipped.
* architecting the entities first without considering the usage requirements of the systems led to an architecture which wasn't very helpful.
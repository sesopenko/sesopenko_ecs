# ADR-3 Agent - Entity - System

Streaming updates to a network client doesn't have to be ocurring in a polling fashion (not every X seconds).  It's more efficient to send the updates to the client the moment things change.

Leading towards a websocket, bidirectional stream sets us up for integration with Godot, since it has good websocket implementation. Cursor research revealed that websockets don't have much more overhead than tcp sockets.

UDP is often used for polling based movement updates because if a packet is missed, another one will come soon.  Shooting, ability activation, etc, are usually over TCP because it's guaranteed to be delivered.

Simulating a websocket client by outputting updates to a terminal in runtime is acceptable for a first pass.  The stream will initially stream to the console.

Spatial concepts are complex & difficult to achieve in only a few hours, on top of the ECS architecture.

Asynchronous events can be handled by systems that are genservers who register themselves as listenered by component type.

Components that receive updates will propagate the changes to their subscribers. Genserver is more suitable than Elixir Agents for this because it can have logic.

Client updates are dependant on multiple components which are being updated by other systems. The systems are in separate processes so will be manipulating components out of band.

Spawning apples is the first system to build because everything depends on it.  Beetles eating apples is the next, and is dependant on beetles and apple tree entities and their components.  Finally network update streaming is done last because it's dependant on the other two.

## Decision

We will build a component pub/sub architecture which lets systems subscribe to changes to components. Component Manager is responsible for tracking subscribers to component changes. Components use the component manager to inform systems of changes.

## Status

Proposed

## Consequences

Describe the resulting context, after applying the decision. All consequences should be listed here, not just the "positive" ones. A particular decision may have positive, negative, and neutral consequences but all of them affect the team and project in the future.
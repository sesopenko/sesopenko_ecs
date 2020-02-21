# ADR-4 Create example project

An example project would be helpful to test the useability of the library and provide documentation & inspiration for other developers.

An example project can live within the same repository for simplicity of development.  This eliminates having to publish changes on hex when trying to integrate the latest changes of the library into the example project.

An example with server/client communication would be ideal because Elixir was chosen as a language specifically for game server development.

### Concepts from Ljubica Todorovic's artowrk.

The artist, [Ljubica Todorovic (Instagram)](https://www.instagram.com/ljubljubs/), has given verbal permission to use her artwork work as conceptual examples for a test game and the benfits would be compounding:

* I (Sean) have familiarity with the subject matter through regular discussions making decisions for components & systems straight forward.
* The artwork already has a popular following, having already figured out a mixture of appealing elements, which makes an appealing example project easier to realize.
* The cross-promotion will be beneficial for both parties.  Ljubica has discussed plans to release creative commons artwork for use in a collaborative game, which is compatible with the licensing (GPL V3) of the library.

### Godot Project

Godot 3.2 has a websocket client which is easy to integrate with. A Godot 3.2 project can be included in the code base to provide an example of integrating with an open source game engine which can target multiple platforms. This would prove the feasability of using the library to launch a functioning multiplayer game.

### Lobbies/Servers/etc

The example project can be limited to an automatic lobby system which has 2 players per lobby. If games are automatically started it eliminates a lobby browsing system. Playing a game with a friend can be out of scope initially for first iteration feasibility.

### Dependencies

This depends on `ADR-5.md`: Entity building.

## Decision

This section describes our response to these forces. It is stated in full sentences, with active voice. "We will ...“

## Status

Proposed

## Consequences

Describe the resulting context, after applying the decision. All consequences should be listed here, not just the "positive" ones. A particular decision may have positive, negative, and neutral consequences but all of them affect the team and project in the future.
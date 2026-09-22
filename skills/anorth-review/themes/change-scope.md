# Change Scope

Scope: apply when a diff bundles more than one concern — load it when reviewing PRs that mix features, refactors, cleanups, or error-handling changes.

## Guidance

- Require one coherent concern per change set. If a diff contains an independent feature, refactor, rename, or error-handling rework that could land on its own, ask for it to be split out rather than reviewing it inline.
- Judge splits by review cost: a self-contained part that is ready should not wait on the contested or unfinished part of the same PR. Say explicitly which hunks can ship now and which should move to a follow-up.
- Incidental cleanups riding along with a functional change obscure the behavioral delta; either drop them or extract them into a preparatory change that lands first.

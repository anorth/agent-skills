# Architecture & Boundaries

Scope: load when a diff introduces or moves types, modules, packages, layers, or abstractions; or changes where state, config, or side effects live.

## Placement & ownership
- Put every type, helper, interface, constant, and config knob in the narrowest module that owns its meaning. A utility does not belong in a file just because that file was convenient to edit; if no module matches the concept, name a new one after the concept.
- Keep state transitions and persistence inside the layer that owns the state; leave policy, sequencing, and orchestration to callers above it.
- Keep behavior, policy, configuration, environment, and execution context out of reusable mechanisms and low-level data types; those should carry no opinions about who runs them.
- Keep caching, logging, metrics, and similar cross-cutting concerns behind small abstractions owned by the emitting module: lookup and population live inside the cache abstraction, log sinks are pluggable with an in-memory test implementation, metrics are declared next to the code they measure.
- Preserve trust and ownership boundaries: access to shared resources or another component's state must be explicit rather than reached into.

## Simplicity over structure
- Prefer the direct implementation. Reject abstraction, indirection, dispatch machinery, or extension points added for hypothetical futures — including callback plumbing more elaborate than the one extension point actually requires, and machinery on components that expose nothing to dispatch to.
- Have default constructors delegate to the parameterized one.
- Decompose oversized workflows, but extract only cohesive operations; extraction that merely relocates lines is churn.
- Delete obsolete code, modes, flags, and version-specific paths once their alternative is unsupported — but do not remove shared metadata or indirection whose purpose and blast radius you have not established.
- Judge package splits on real shared code and practical benefit, not on tidiness; keep separate implementations of one interface in separately named files.

## State, data, and flow
- Make lifecycle, messaging, scheduling, subscriptions, async follow-up, and error paths explicit; keep side effects outside rollback boundaries unless the boundary explicitly covers them.
- Batch repeated or independent work where correctness allows, and avoid needless transactions, round-trips, and per-item processing.
- Push per-unit normalization and division to the boundary where a single value is actually consumed.
- Prefer straightforward control flow and one consistent error-handling strategy; if complexity is unavoidable, demand exhaustive tests for it.

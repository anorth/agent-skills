---
name: anorth-review
description: >-
  Reviews diffs using distinctive preferences distilled from Alex North's
  public GitHub reviews (naming, API shape, errors, tests, coupling, and
  related themes). Use when the user asks for a code review, PR review, or
  anorth-style review.
disable-model-invocation: false
---

# Anorth review

Read the change set and the surrounding code it depends on. 
Determine which themes are relevant to the diff.
Load one subagent for each theme and hand it the theme file and instructions to review the diff for issues it covers.
Subagents should use a cheap model; ask the user if you haven't been told which is appropriate.

Collate the reported issues.
Output issues in decreasing order of importance.
Suggest how to resolve them.
Do not apply substantive edits before discussion.

## Always

- [`Naming`](themes/naming.md) — identifiers
- [`Style`](themes/style.md) — dead weight, constants, order, locality
- [`Comments`](themes/comments.md) — comments, docs, stale nearby comments

## When the diff matches

- [`API Shape`](themes/api-shape.md) — public functions, types, endpoints, events, persisted formats
- [`Architecture`](themes/architecture.md) — modules, layers, where state or effects live
- [`Change Scope`](themes/change-scope.md) — mixed features, refactors, or cleanups in one PR
- [`Concurrency`](themes/concurrency.md) — shared mutable state, threads/coroutines, timers
- [`Coupling`](themes/coupling.md) — module boundaries, wiring, cross-component APIs
- [`Dependencies`](themes/dependencies.md) — manifests, lockfiles, vendored or generated code, new libraries
- [`CI locally`](themes/developer-experience.md) — CI, build, lint, or codegen steps
- [`Errors`](themes/errors.md) — new or changed failure paths, error types, panics
- [`Invariants`](themes/invariants.md) — validation, state transitions, persistence, aggregates
- [`Observability`](themes/observability.md) — logs, metrics, journals, or swallowed failures
- [`Tests`](themes/tests.md) — tests, fixtures, doubles, or test helpers

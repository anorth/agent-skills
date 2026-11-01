---
name: deep-review
description: >-
  Deep, themed review of a diff: one cheap reviewer subagent per theme, using
  distinctive preferences distilled from Alex North's public GitHub reviews
  (naming, API shape, errors, tests, coupling, and related themes), with
  findings checked before reporting. Use when the user asks for a deep review,
  themed review, or anorth-style review.
disable-model-invocation: false
---

# Deep review

The default change set is the working tree against `HEAD`: `git diff HEAD` plus untracked files.
If that's empty, ask the user for the range.

Read the change set and the surrounding code it depends on.
Determine which themes are relevant to the diff.

Launch one subagent per theme, in parallel, as the `/model-tiers` skill describes,
on the `cheap` tier and different from the implementer.
Brief each with the theme file's absolute path, the diff command, and instructions to:
- review the diff only for issues the theme covers, citing `file:line`, and not edit files;
- read only as much surrounding code as the change and the theme need:
  the changed hunks' enclosing functions and types, and the callers, callees, or peer code the theme judges against.
  Don't read whole files or explore beyond that.
If a theme subagent fails, retry once, then continue without it and name the missing theme in the output.

Check findings before reporting. Cheap reviewers are noisy.
Open the cited code for each finding and keep it only if it holds.
Merge findings that share a root cause across themes.

Output the surviving issues in decreasing order of importance, naming the theme each came from.
Suggest how to resolve them.
Say how many findings the check dropped, and why.
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

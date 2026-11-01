# Errors: classification, propagation, and diagnostics

Load for any diff that creates, classifies, wraps, suppresses, logs, or tests failures — including new error types/codes, validation paths, panics/assertions, and partial-failure loops.

## Diagnostics content
- Every error message must name the failed operation and carry the values needed to act on it: relevant identifiers, the offending input, runtime values, bounds, ownership/actor, and expected-vs-actual. Reject messages that state only that something failed, and check that the values quoted are actually accurate for that path.
- Wrap-and-propagate must preserve both the underlying classification and its descriptive context; wrapping that flattens a structured error into a bare string or generic code is a defect.
- When a failure genuinely cannot be returned, still preserve the diagnosis — log it or surface a reason the caller can render.
- Assertions and panics need contextual messages too: an invariant violation with no context is undiagnosable.
- User-facing messages should use domain-neutral wording that makes sense outside the subsystem.

## Pick the right category
- Malformed, out-of-range, or precondition-violating caller input → the standard invalid-argument/invalid-input classification, rejected explicitly.
- Violated internal invariants, or failures in runtime/infrastructure/persistence internals → internal/system/fatal classification, never a caller-facing "bad input" error.
- Authorization, permission, and policy rejections → forbidden/permission-denied, not invalid-input and not internal.
- Undecodable or malformed external payloads → a serialization/decoding error, distinguished from internal serialization bugs; reject absent or uninitialized values explicitly at serialization boundaries.
- Unsupported operations and unimplemented variants get their own category, distinct from invalid arguments.
- Prefer an operation-specific code that matches the actual cause and the handling the caller must perform; replace placeholder or hard-coded numeric codes with a named classification. Materially different validation failures deserve distinct codes.
- Return the same canonical error for the same condition on every code path. Do not reuse a not-found classification across lookups with different existence or lifecycle semantics, and distinguish "does not exist" from "exists in a terminal state."
- Preserve externally observable error classifications and failure semantics across refactors; a change in what callers observe must be deliberate and called out.
- For ordinary "no such entry" control flow, prefer a non-failing lookup that reports absence directly over a sentinel error.

## Errors vs. panics
- Keep recoverable application errors distinct from terminal failures; route recoverable cases through the error mechanism instead of panicking, and use the runtime's abort path only for unrecoverable failures at top-level entry points.
- Public constructors and library entry points should report invalid caller input as a catchable error, not a panic. Validate preconditions at the call site rather than relying on a library's panic for an expected invalid state; validate mutable indices against bounds before indexing.
- Do not convert unexpected panics or internal failures into ordinary application status codes; an assertion failure must not yield a successful or committed outcome.
- Use the controlled error mechanism for runtime validation rather than production assertions; conversely, do not add defensive handling for failures that documented preconditions exclude — assert instead.
- No reachable placeholder panics in production code: implement the behavior or return an explicit handled failure. In tests, let panics that indicate programming bugs surface rather than downgrading them to ordinary test errors.

## Don't lose failures
- Never ignore an error because it is "impossible," and never suppress errors emitted by validation or invariant checks — propagate them to the caller.
- Propagate failures from required nested state-changing calls, and expose nested-call status consistently unless an interface deliberately returns ordinary results. Let atomic operations propagate so the surrounding mechanism rolls back, rather than restoring state by hand.
- Design fallible callbacks and hooks to return errors so callers can propagate or handle them.
- Reject invalid or unsupported calls explicitly instead of silently continuing or relying on an incidental downstream failure. If a bad input invalidates a whole batch, say so at the boundary.
- Fail early and loudly when an explicitly required resource is unavailable; do not paper over a broken integration by suppressing its connection errors — disable it by configuration instead.
- Fix the root cause of encoding/serialization misuse rather than swapping in a path that hides it.

## Partial failure and continuation
- In batch or streaming processing, isolate expected per-item failures: keep successful results, report the failing items individually, and keep processing later items.
- Failure of a noncritical ancillary action (notifications, observability, outbound preparation) must not abort the primary operation — record the primary result and log the ancillary failure.
- Treat "no applicable work," an unsupported variant needing no state change, or an already-absent item during best-effort cleanup as a successful no-op.

## Layering and contracts
- Validation and authorization belong at the boundary that owns the rule — see invariants. This file is how those failures are classified and reported.
- Emit errors at the abstraction level of the operation; translate low-level details at the layer that owns the relevant policy or can make a meaningful recovery decision, and handle reserved/internal code ranges explicitly when mapping to external statuses.
- Assign the externally visible classification at the boundary, where there is enough context to separate caller error from internal failure.
- Centralize low-level failure handling in a shared helper when all callers need identical behavior; use direct inline validation when a check is needed at only one site.
- Document error contracts callers depend on: which variant signals an expected failure, whether expected failures appear as result values or thrown/returned errors, deliberate propagation of a lower layer's codes, and any intentional reuse of a lower-layer error type for a local failure.

## Logging failures
- Log unexpected operational failures at warning or above; reserve debug level for documented, low-impact conditions, and make the message clearly identify the condition as a failure.
- Include the returned status or exit code when logging a failed operation, and distinguish failure to start/execute a subprocess from a nonzero exit, preserving the latter's status and output.
- Route exception details through the configured logger rather than printing stack traces directly.

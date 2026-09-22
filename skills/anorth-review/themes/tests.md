# Tests

Standards for reviewing test code — coverage design, assertions, fixtures, test doubles, and suite health. Load when a diff adds or changes tests, test helpers, fixtures, doubles, or CI test configuration.

## What earns a test

- Reject tests that re-cover behavior already tested elsewhere, that verify framework/mock-runtime guarantees, or that only exercise delegation to a well-tested dependency. Each case must cover a distinct scenario or boundary.
- Behavior changes must arrive with test updates that verify the new behavior.
- Prefer tests of externally observable behavior across realistic workflows over tests coupled to internal queues, traversal order, or private state. Reach the state under test through the same public transitions production uses, and drive commands through the public API/CLI rather than calling handlers directly.
- Require unit coverage for non-generic logic: calculation helpers directly (including caps and representative magnitudes), each new control-flow branch, each enforced validation condition. When replacing a calculation, add equivalence tests against the old implementation over representative inputs.
- If a change fixes a defect, require a test that reproduces the original failure. Keep such regression tests active — but never encode known-wrong behavior as the expected success result; document it instead.
- Complement integration coverage with isolated unit tests per component, and vice versa: when end-to-end behavior is hard to reach, test at the nearest component boundary.

## Boundaries, negatives, and combinations

- Exercise the exact threshold and the values immediately on either side; assert both lower and upper bounds of a range; derive related boundary values from one another and keep them adjacent so the intended inequality is visible.
- Cover empty, single-element, first/last, before-first/after-last cases for iteration, lookup, and serialized structures; test iterator behavior in addition to direct access.
- Build negative tests as one minimal, clearly labeled deviation from a shared valid baseline, so only the intended condition is invalid. When several inputs are validated, make each invalid in turn while the rest stay valid.
- Pair rejected/unauthorized/failure tables with a passing control case that proves the operation can succeed and that the failure is caused by the intended condition. Explicitly test that unauthorized callers, roles, or types are rejected for every privileged operation.
- Assert the specific error, exit status, or error category — not mutable diagnostic text. Use the framework's expected-failure assertion rather than hand-rolled panic recovery.
- Cover combinations of independent input dimensions, repeated and out-of-order operations, operations on nonexistent resources, self-targeting operations (source == destination), and partial updates that must leave other items untouched. Use table-driven or parameterized cases for variants sharing one mechanism; keep separate tests when the mechanisms differ.

## Assertions

- Never execute a call without verifying its outcome. Assert the intended final value directly rather than inferring it from an intermediate, a proxy, or a "changed/increased" check; for asynchronous behavior assert the expected final value.
- Assert all consequential effects of a state change: status, aggregates, derived and externally visible values, emitted events (every semantically important field), and callback invocations with their expected arguments. Build expected events independently of the production construction code.
- Verify results through public getters or purpose-built state-summary helpers. When an operation should have no effect, assert the observable state and relevant counters explicitly rather than leaving absence implicit; when it should consume all pending work, assert none remains.
- Assert non-empty/meaningful preconditions before asserting they are cleared, and confirm a captured baseline actually satisfies the expected precondition before comparing against it.
- Keep assertions scoped to the behavior under test: don't restate guarantees already established by setup or helper APIs, don't assert transient side effects that are rolled back, and don't exhaustively assert unrelated subsystems unless their inactivity is part of the contract.
- Compare complete collections directly (including exact counts and ordering) when contents and order are part of the contract; construct expected ordering with the same canonicalization mechanism the code under test defines. Assert both the discriminator and the decoded payload of dispatched or serialized messages.
- Failure diagnostics should include expected and actual values without duplicating the inputs already visible in the case. Use non-fatal assertions for independent expectations; fatal only where continuing would be unsafe or misleading.

## Fixtures and values

- Fixtures must be deterministic and explicit. Avoid uncontrolled randomness; use fixed constants when the exact value is irrelevant, and derive variation from stable identifiers when variety is needed.
- Use distinctive, non-default values for any field the behavior should carry, propagate, or distinguish — so ignored, swapped, or confused data fails the test. Give coexisting entities and distinct roles (caller vs. recipient, source vs. destination) distinct identifiers, and set inputs that must not be used to invalid sentinels.
- Everywhere else, prefer simple, round, representative values used consistently; reserve unusual values for tests that specifically verify their effect. Avoid values that accidentally trip caps, clamping, or early returns unless that is the behavior under test.
- Keep magnitudes, durations, and test/dev configuration realistic enough to expose production-scale behavior. Do not make a change pass by loosening unrelated tests or using unrealistic configuration; document any exceptional fixture.
- Replace unexplained literals with named values; make important inputs explicit and independently configurable at the call site rather than hidden in helpers or comments.
- Vary the fixture condition the assertion depends on, so the test cannot pass without exercising the intended path. Set up only what the scenario needs, and advance state only as far as the condition under test requires.

## Test doubles

- Prefer verifying per-operation expectations or resetting state over globally disabling verification. Check that every category of queued expectation was consumed; clear one-shot expectations immediately after they are consumed; never clear or reset in a way that conceals unmet expectations, and don't verify when nothing was configured.
- Place expectations next to the invocation they constrain, set mutable double state immediately before the action that reads it, and verify interactions right after the operation that produces them so failures stay localized.
- Keep doubles configurable rather than editing them per test: caller-supplied responses and payloads for distinct failure modes, inspectable arguments, recorded arguments even when the configured call fails, and support for asserting interaction order where order matters.
- Doubles must fail loudly for unimplemented operations, implement all required methods, enforce the same argument preconditions and canonical representations as production, preserve transactional semantics, derive outputs from inputs deterministically, and keep distinct stable mappings for distinct inputs. Time doubles replace only the clock source and keep production time math.
- Unit tests fake external and cross-component dependencies and construct the narrowest state required; integration tests use the harness's real primitives and stay free of doubles. Keep shared mock infrastructure minimal.

## Structure and helpers

- Factor repeated setup, fixture construction, state navigation, error checks, and assertion clusters into descriptively named, reusable helpers; provide helpers that pair a common operation with its standard success assertion, and parameterize them for related cases and failure paths. Extend an existing helper with an option before adding a near-duplicate; apply a new helper to all analogous call sites.
- Helpers must keep each test's inputs and intent visible: no hidden scenario-specific transformations, no silently reread internal state. Take expected results from callers that already know them instead of duplicating production logic; return derived values and observable outcomes so callers can assert without inspecting internals. Helpers that track expected state must verify the system's actual state before updating their cache.
- Keep setup helpers to their stated purpose; perform scenario-specific transitions in the test itself. Keep test-only helpers in test code, and never add production bookkeeping solely to ease testing.
- Hoist shared immutable setup, config, and constants to the widest common scope or the harness; keep only genuinely case-specific setup inline.
- One behavior per test; put independent scenarios in separate blocks so their variables and boundaries stay isolated, and finish a scenario's assertions before shared setup is mutated for the next. Combine closely related cases into one sequential scenario only when setup is genuinely shared and no distinct assertion is lost.
- Test names must not overclaim. Name tests after the specific condition and expected outcome; name helpers after the observable operation they actually perform — a setup helper must not read like a verification. Keep exact-match, inclusion, and expected-failure assertions distinguishable. Group related cases with the existing tests for the same behavior, and separate current-workflow tests from legacy/transition tests so obsolete coverage can be deleted independently.
- If testability requires it, improve the design (extract the unit, add the inspection capability) rather than coupling tests to internals or weakening assertions.

## Determinism, speed, and tiering

- Unit tests must not sleep or depend on real elapsed time. Use an injectable/fake clock initialized to a fixed value, express time-dependent fixtures relative to it, advance it explicitly, and design timeouts and watchdogs around that abstraction. Avoid short hard-coded timeouts that flake under load; wait on the exact number of expected asynchronous callbacks.
- Move genuinely slow, blocking, or timing-dependent tests to an integration or separate CI tier; classify tests by the scope and cost of behavior exercised, not by incidental mechanics. Prefer fast in-process tests when they validate the same behavior, and keep tests free of large generated artifacts or unnecessary external services.
- Randomized/fuzz tests supplement, not replace, deterministic cases: keep a deterministic baseline, make failing cases reproducible with their exact parameters, and use longer exploration in CI than locally. Don't reduce randomized, long-running, or high-scale coverage without evidence the replacement explores the same states.

## Hygiene and process

- No commented-out assertions, unresolved test TODOs, or silently skipped tests. A temporary skip needs a tracking reference and enough context to explain it; restore or delete it when behavior changes.
- Don't merge tests with missing required assertions or land a known behavior-changing defect before it is fixed and covered; track deferred coverage or cleanup explicitly.
- Keep test diagnostics quiet by default.
- Treat a failing test as possible evidence that the implementation or its specification is missing a case; treat chronic flakiness or long runtimes as a suite-reliability problem, not an accepted cost.

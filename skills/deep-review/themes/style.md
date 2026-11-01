# Style: Clarity, Dead Weight, and Ordering

Always load. Recurring objections about redundant code, named constants, declaration order, and locality.

## Delete what isn't earning its place
- Remove unused, speculative, or dead code — obsolete fields and flags, boilerplate interface hooks with no behavior, no-op statements, compatibility placeholders — unless it serves a concrete, stated compatibility or migration need. Don't land code or configuration ahead of the change that needs it.
- Remove commented-out or disabled implementation fragments; version control is the archive.
- Strip temporary debugging instrumentation, print statements, and placeholder scaffolding before merging.
- Delete calls, computations, and fetches whose results are unused and whose side effects aren't required; likewise arithmetic that cannot change a value, guards that cannot change behavior, defensive checks already guaranteed by preceding logic or by the type, and unused intermediate state/return values/flags.
- Inline single-use temporaries, helpers, type aliases, and small parameter objects that add no reuse, no independent meaning, and no clarity. Keep simple predicates inline; name a value only when the name explains something.

## Constants and literals
- Replace repeated or meaningful numeric literals with typed named constants; the same goes for well-known API/method identifiers, identifier-keyed mappings, recurring fixed test values, buffer limits (with a documented rationale), and recurring collections of values.
- Write large scaled constants as readable arithmetic (explicit powers of ten or meaningful factors) rather than long digit strings.
- Use a named sentinel or shared canonical zero/empty value instead of ad-hoc constructions and repeated equivalent instances; keep legacy and replacement constants separate so intended use is obvious.
- Don't pass values that merely restate a default; don't leave bare boolean literals or unexplained hard-coded defaults at call sites — name the flag or the default.

## Ordering and grouping
- Order top-down: public and higher-level declarations before the private helpers they use; semantically important code before low-level utilities; preserve ordering that communicates conceptual layering.
- In tests, put the test cases first, fakes and utilities after.
- Group struct/config fields by semantics, lifecycle, or dependency relationship (dependencies apart from algorithmic parameters); order fields and parameters by conceptual role and execution flow — primary inputs before derived outputs and ancillary values, base input before values derived from it.
- Keep literals, constructors, and callers in declaration order; keep recurring parameter order consistent across related methods; keep assertion arguments in a consistent expected-then-actual order.
- Respect a file's or manifest's existing ordering convention (lexicographic, enum attribute, terminal states last, table-of-contents order) rather than appending arbitrarily.
- Place helper methods near the operations or lifecycle transitions they support; place configuration values near what they configure.

## Locality and data flow
- Keep dependent operations adjacent: a precondition check immediately before the mutation it authorizes, a state update immediately before its publication or derived computation, cleanup inside the conditional guard that established the value.
- Declare variables close to first use, and compute derived values at the point of use; keep branch-specific intermediates inside their branch.
- Hoist loop-invariant work out of loops, and lift bulk validation/preconditions out of the main processing loop.
- Read a contextual value once and reuse it; name a repeated computation once as the single source of truth; use the value a map iterator already yields instead of looking it up again; hoist identical updates out of both branches so they happen once.
- Construct values in data-flow order — inputs, then derived values, then expected results.

## Control flow and expressions
- Prefer the simplest equivalent structure: `else if` chains over conditionals nested in `else`; no nesting when the inner work doesn't depend on the outer condition; loop termination expressed in the loop condition; return an already-computed boolean directly.
- Collapse duplicated branches into one normalized calculation, and avoid special-casing empty collections or wrapping a single operation in batch machinery when the general path already handles it.
- Write comparisons and signs in the direction that makes the boundary or adjustment obvious (direct negation over multiplying by −1, subtraction over adding a negation, explicit lower-bound comparison); prefer explicit branching where chained min/max hides edge cases.
- Prefer intent-revealing predicates over raw sentinel comparisons, and named-field records over positional tuples when component meanings matter; destructure results into named bindings when parts differ in meaning.
- Process items during a single iteration rather than materializing an extra pass or a redundant parallel collection; combine per-element checks over the same collection into one pass.

## Duplication and helpers
- Factor genuinely repeated logic — setup, assertions, conversions, ordering rules, file writing, retry/poll timing, path literals — into one focused, accurately named helper; reuse existing fixtures and shared constants instead of re-creating them locally.
- Don't extract a one-off constant or helper where the direct computation is clearer; centralize repository-wide boilerplate instead of repeating it per file.

# Dependencies

Scope: load when a diff touches dependency manifests, lockfiles, vendored or generated code, module boundaries, or introduces/duplicates functionality that another library already owns.

## Reuse over reimplementation — and reimplementation over new dependencies
- If a dependency already owns the behavior, call it rather than reproducing the behavior locally. For trivial functionality with no broader payoff, write the small local implementation instead of taking a dependency — e.g. one simple HTTP call rather than a whole client library. Do not add a direct dependency when an existing helper or already-present dependency covers it.
- Don't leave placeholder or stub utilities in place once the real mechanism exists; delete workarounds and compatibility aliases as soon as an upgraded dependency supplies the capability.

## Judging a new dependency
- Treat every new external dependency as a deliberate, security-sensitive decision requiring justification — including framework adoption, which should not be an unquestioned default.
- Weigh maintenance posture: prefer maintained dependencies under shared organizational ownership over lightly maintained or personally owned repositories; vendor small essential code under project maintenance when no good published package exists.
- Add only what the component's scope needs — no fields, dependencies, or infrastructure for features that aren't implemented yet, and no packages that generated tooling dropped into the module graph unused.
- Justify long-term operational and CI cost before adopting infrastructure; quantify the tradeoff rather than assuming.

## Scope, layering, and coupling
- Keep library dependency graphs narrow so consumers don't inherit unrelated code: isolate test, benchmark, and tooling dependencies; avoid pulling heavyweight storage/infrastructure or broad test-utility packages into production paths; depend on the narrowest low-level implementation that satisfies a primitive operation.
- Preserve dependency direction and acyclicity: higher-level components depend on lower-level APIs, never the reverse, and no circular package dependencies.
- Don't leak dependency-owned types through your public API — expose project-owned interfaces and own your tunable configuration constants.
- Keep reusable libraries free of environment-specific SDKs and choices that break supported compilation targets; avoid convenience re-exports that make a module unusable when an optional or platform-specific dependency is absent.
- Keep shared tooling decoupled from consumers by accepting caller-provided metadata rather than importing consumer types.

## Hygiene and removal
- Remove dependencies that are unused, no longer required, or superseded by platform/runtime functionality, and simplify or delete the code their removal makes unnecessary — including unused imports and helpers with no caller.
- Before removing shared constants, types, or assets, check for indirect call sites, intentional references, and deferred work; track any deferred cleanup explicitly.
- Keep manifests and lock/checksum files in sync with code changes; verify versions with a clean rebuild before editing source to accommodate a suspected mismatch, and when an unexpected major version resolves, check range semantics and lockfile resolution rather than trusting the declaration.
- Regenerate generated files from source rather than hand-editing output; provide documented reproducible regeneration, keep generation config in step with deleted types, don't commit reproducible artifacts, and confirm ignored paths really are generated.

## Versioning, provenance, and pinning
- Pin Git dependencies to immutable commits, use stable release-appropriate revisions, and make the provenance of any pin obvious.
- Don't let mainline depend on a dependency's development branch or an unreleased version downstream consumers can't use, without explicit temporary justification and a plan to return to a release.
- Publish a new major version when incompatible changes or dependency upgrades can break consumers; avoid pushing unexpected major-version dependencies into downstream trees or requiring lockstep upgrades.
- Preserve attribution, licensing, and maintenance history when incorporating third-party code or assets, and keep third-party disclosures aligned with what is actually used.
- Prefer stable toolchains over nightly/pre-release unless there is an unavoidable concrete need.
- Keep dependency-only upgrades separate from functional changes, and exclude unrelated submodule or dependency revision bumps from a diff; adopt cross-cutting test infrastructure as its own change applied consistently.

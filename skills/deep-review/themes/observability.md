# Observability

Scope: load when a diff adds, removes, or changes logging, metrics, or audit/journal records — or when it silently tolerates a failure.

## Guidance

- Never let a suppressed, retried, or tolerated error become invisible: if the code swallows a failure or falls back, require a counter or metric for it so the condition can still be seen from outside.
- Instrument validation and admission paths so accepted and rejected inputs are counted separately; a single "processed" counter hides the interesting half.
- Audit and journal records must carry every material input of the operation they describe — enough to understand and reconstruct the request without correlating against other systems.
- Require stable identifiers (participant, request, correlation) in log lines for anything spanning processes or nodes; otherwise a diagnosis cannot be reassembled after the fact.
- When deleting verbose debug logging, check that operationally significant events survive at an appropriate level (info/warn) rather than disappearing with the noise.
- Progress reporting in loops must scale with total work and have a bounded message count — fixed per-iteration or per-N logging floods logs on large inputs.
- Cut routine logging that yields no actionable diagnostic value; downgrade severity for expected conditions needing no operator attention; prefer one summary log for a batch over per-item chatter.
- Refer to the same identifier or value consistently across an operation's logs; declare log tags as private constants, not mutable state.

---
name: arena
description: >-
  Spawns N parallel candidates at the same task on different models, has a judge score them,
  picks a base, and grafts the strongest parts of the others into it.
  Use for /arena, "arena this", or when one attempt at a non-trivial artifact would lock in the wrong shape.
disable-model-invocation: false
metadata:
  credit: "Adapted from Lauren Tan's pstack arena skill, github.com/cursor/plugins (MIT, (c) 2026 Lauren Tan)"
---

# Arena

Run the phases in order: Frame, Fan out, Cross-judge, Pick, Graft, Verify.

## Phase A: Frame

Every candidate gets the same prompt, so the prompt is the contract.

1. State the artifact each candidate is producing.
2. Derive the rubric, 3-6 concrete gradeable criteria for what success looks like on *this* task.
   It is the picker's tool in Phase D. Candidates only see the task.
3. Pick the runners, on the `strong` tier through `/model-tiers`: by default two, each on a different model,
   taking the tier's available entries in order. Fall back to lower tiers if necessary to ensure distinct models.
   Spawn more runners when the arena covers multiple design directions.
4. Give each candidate its own output location: a git worktree when candidates change the repo,
   otherwise `/tmp/arena-<slug>/candidate-<n>/`.

## Phase B: Fan out

Spawn all N subagents at once, in the background where the harness allows,
with this brief:

```
Read and follow <absolute path to this skill's directory>/runner.md.
Task: <the task>
Grounding: <paths to shared grounding, or "none">
Output: <this candidate's output location>
```

If a candidate produces no output, proceed with N-1 and note the dropout.

## Phase C: Cross-judge

After all Phase B candidates complete, spawn one read-only judge subagent on the `strong` tier.
Resolve it as a reviewer through `/model-tiers`: the judge runs on a different model from this session's.
The judge sees the rubric and the candidates by path label, scores each criterion, and recommends a base with rationale.
It runs in parallel with your reading in Phase D. Don't spawn it while candidates are still writing.

## Phase D: Pick a base

Read every candidate end to end before picking.
Score each against the rubric criterion by criterion, not on holistic feel, and compare with the cross-judge.
Agreement on the base confirms the pick.
Disagreement means one of you is biased or the rubric was ambiguous. Read both rationales before deciding.

Pick the base a future maintainer can extend most easily without breaking invariants.
When two feel tied, prefer the cleaner boundary or smaller API.

## Phase E: Graft

Walk each losing candidate once more for what is worth porting into the base,
usually one or two things per candidate, not most of it.
Fold each graft in by hand, so the result stays coherent under one mental model. Don't paste mechanically.

If the candidates converge on one shape, that is strong agreement. Note it and ship the consensus shape.
No graft is needed.
If they wildly diverge, Phase A was under-specified. Reframe and re-run rather than averaging the divergence.

## Phase F: Verify

Verify the synthesized artifact like any other output: run its checks, if it has any, and score it against the rubric.
If verification finds a problem the arena missed, either Phase A was wrong (re-frame and re-run)
or a candidate caught it and you missed the graft (go back to Phase E). Don't paper over it.

## Outputs

One synthesized artifact, with a short synthesis note alongside naming the base and why,
the cross-judge's verdict, each graft with its source candidate, what was rejected and why,
any convergence or dropouts, and the verification result.

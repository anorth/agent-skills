---
name: design-it-twice
description: >-
  Explores radically different designs for one problem through parallel subagents, each under a different
  design constraint, then presents and compares them and recommends one.
  Use when the user wants alternative designs, says design it twice, or when the first idea's shape isn't obvious.
disable-model-invocation: false
metadata:
  credit: "Adapted from Matt Pocock's DESIGN-IT-TWICE.md, github.com/mattpocock/skills (MIT, (c) 2026 Matt Pocock)"
---

# Design It Twice

Use this parallel sub-agent pattern to explore alternative designs for one problem.
Your first idea is unlikely to be the best.

## 1. Frame the problem space

Before spawning sub-agents, write a user-facing explanation of the problem space:

- The constraints any design would need to satisfy
- The dependencies it would rely on, and the existing code it must fit with
- A rough illustrative code sketch to ground the constraints, not a proposal,
  just a way to make the constraints concrete

Show this to the user, then immediately proceed to Step 2.
The user reads and thinks while the sub-agents work in parallel.

## 2. Spawn sub-agents

Spawn 3+ sub-agents in parallel, each with a fresh context window. Each must produce a **radically different** design.
Run them on the current model unless the user asks for others; resolve those with `/model-tiers`.

Share what you've already learned as grounding, so the sub-agents build on it rather than repeating the research.
Include the project's glossary vocabulary, if it has one, so each sub-agent names things in the domain's language.

Give each agent a different design constraint.
Choose constraints that pull the problem's real tensions apart, so the designs differ in shape, not detail.
E.g., for the design of a module's interface, start from these:

- Agent 1: "Minimize the interface: aim for 1–3 entry points max. Maximise leverage per entry point."
- Agent 2: "Maximise flexibility: support many use cases and extension."
- Agent 3: "Optimise for the most common caller: make the default case trivial."
- Agent 4 (if applicable): "Design around ports & adapters for cross-seam dependencies."

Use this brief template:

```
Read and follow <absolute path to this skill's directory>/runner.md.
Problem: <one paragraph>
Constraint: <this agent's design constraint>
Proposal template: <absolute path to the design skill's directory>/proposal.md
Grounding: <paths to shared grounding, or "none">
```

## 3. Present and compare

Present designs sequentially so the user can absorb each one, then compare them in prose. Contrast by:

- **depth**: how much the design hides behind how little callers must learn;
- **locality**: where change, bugs, and knowledge concentrate;
- **fit**: where it meets the existing system, and what that costs.

After comparing, give your own recommendation: which design you think is strongest and why.
If elements from different designs would combine well, propose a hybrid.
Be opinionated: the user wants a strong read, not a menu.

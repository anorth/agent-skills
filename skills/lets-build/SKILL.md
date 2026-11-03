---
name: lets-build
description: >-
  Build from a written ticket or task, collaborating with the user: read the ticket and related open work,
  ground it in the code, clarify requirements and design with the user, then implement
  after they confirm the plan. Use when the user says let's build, build together,
  or asks to build from a ticket or task description.
disable-model-invocation: false
---

# Let's Build

The agent does the work. The user clarifies requirements and confirms design.

The ticket is a starting point, not gospel.

## When to use

- The user says let's build, build together, or asks to build from a ticket or task description.

Don't use this skill if the user asks explicity for you to build independently and make your own decisions.

## Workflow

Run in this order. Do not skip ahead to code.

### 1. Load the ticket and related work

Identify the written ticket or task. The user may give an id, URL, file path, or pasted text.

- If it is unclear which item: ask. Do not guess.
- Read the ticket in full.
- List or skim other open tickets; read the ones that are related to the ticket.

Purpose: context, sequencing, and collisions. Do not expand scope from them.

### 2. Ground in the code

Read the code to build context on what the system does today.

Where the ticket and the code disagree, trust the code for **what is true today**. Raise significant mismatches with the user.

Form your own picture of the problem and plausible solution directions. Do not adopt the ticket's plan uncritically.

### 3. Clarify requirements

Use the `/grilling` skill until the problem is sharp enough to design against.

- Keep this phase to requirements; design forks come in step 4.
- Do not implement in this phase.

### 4. Align on design

Ask further questions that **propose options and trade-offs**, not just open probes.

Point out the key design decisions that a solution would have to make. For each that matters, give a small set of options and what you would pick, then wait for the user.

User answers override the ticket. After a decision lands, keep the ticket's original brief
and append a note saying what changed and why, if necessary.

### 5. Propose a plan

When you have enough context to sketch a solution with confidence, propose a **brief** plan:
approach, main pieces, how we'll know it's done, and anything still assumed.

How we'll know it's done: for each behaviour that matters,

- an observable check that passes or fails;
- the evidence that would show it (a test, a command and its output, a screenshot, a measured number);
- the edge cases worth stating as examples.

"It works" isn't a check. Propose checks an agent could verify without asking.

Significant UI changes will necessarily require human review: acknowledge and plan for that.

### 6. Build

After confirmation: implement the agreed plan. Keep it the minimum that solves the problem.
Run the done checks before moving on, and show the user their evidence with the result.

If new design forks appear mid-build, stop and ask; do not silently pick.

### 7. Reflect

Load and apply the `reflect` skill to the work – thoughtful rather than quick. Write a message to the user noting that you are now reflecting.
Load this skill only *after* implementation.

Update the originating ticket if the work diverged from what it still says.

## Guidelines

The code is the authority on what the system does today. The user is the authority on what the system should do. The ticket is a starting point, not gospel.


Update the ticket when information or decisions change; do not leave it stale.

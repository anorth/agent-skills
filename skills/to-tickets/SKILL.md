---
name: to-tickets
description: >-
  Break a settled design, spec, or the current conversation into ready tickets in the project's issue tracker.
  Use when the user asks to write tickets, split work into tickets, or file a design.
disable-model-invocation: false
metadata:
  credit: "Adapted from Matt Pocock's to-tickets skill, github.com/mattpocock/skills (MIT, (c) 2026 Matt Pocock)"
---

# To Tickets

Break a settled design into **tickets**, each ready to build (see `/ready-ticket`).
A small change becomes one ticket.
A larger one becomes a parent ticket holding the overall design,
with vertical slices as child tickets, each declaring the tickets that block it.

## 1. Gather context

Work from whatever is already in the conversation context.
If the user passes a reference (a spec or design document, a ticket id or URL), fetch it and read it in full.

If the design can't be split into tickets yet, because a ticket would need decisions nobody has made,
stop and say which decisions are missing. Don't make them here.

## 2. Explore the codebase

If you have not already explored the codebase, do so to understand the current state of the code.
Ticket titles and descriptions should use the project's domain glossary vocabulary,
and respect ADRs in the area you're touching.

Look for opportunities to prefactor the code to make the implementation easier.
"Make the change easy, then make the easy change."

## 3. Size

If the change fits in one ready ticket, write one ticket, and skip to step 5.
Otherwise it gets a parent ticket holding the overall design, with child tickets for the parts.

## 4. Draft vertical slices

Prefer breaking the work vertical slices, unless the user asks for a different order,
or you genuinely think a different sequence is more appropriate for this change.

- Each slice cuts a narrow but COMPLETE path through every layer (schema, API, UI, tests):
  vertical, NOT a horizontal slice of one layer.
- A completed slice is demoable or verifiable on its own.
- Each slice is sized to fit in a single fresh agent session.
- Prefactoring comes first, as its own tickets, blocking the slices that build on it.

Give each ticket its blocking edges: the other tickets that must complete before it can start.
A ticket with no blockers can start immediately.

**Wide refactors are the exception to vertical slicing.**
A **wide refactor** is one mechanical change (rename a column, retype a shared symbol)
whose **blast radius** fans across the whole codebase,
so a single edit breaks thousands of call sites at once and no vertical slice can land green.
Don't force it into a vertical slice; sequence it as **expand–contract**.
First expand: add the new form beside the old so nothing breaks.
Then migrate the call sites over in batches sized by blast radius (per package, per directory),
each batch its own ticket blocked by the expand, keeping CI green batch to batch because the old form still exists.
Finally contract: delete the old form once no caller remains, in a ticket blocked by every migrate batch.
When even the batches can't stay green alone, keep the sequence but let them share an integration branch
that all block a final integrate-and-verify ticket; green is promised only there.

## 5. Confirm with the user

For a single ticket, show it and confirm it with the user.

Otherwise, present the proposed breakdown as a numbered list. For each ticket, show:

- **ID**: short ID, code, or slug
- **Title**: short descriptive name
- **Blocked by**: which other tickets (if any) must complete first
- **What it delivers**: the end-to-end behaviour this ticket makes work

Ask the user:

- Does the granularity feel right? (too coarse / too fine)
- Are the blocking edges correct: does each ticket only depend on tickets that genuinely gate it?
- Should any tickets be merged or split further?

Iterate until the user approves the breakdown.

## 6. Publish the tickets

Write the tickets in the project's issue tracker: the single ticket, or each child, in the `/ready-ticket` shape.
If the project has no tracker, ask the user where tickets go.

- Put the overall design in the parent ticket, or reference the spec or design document that holds it.
- Give each child its slice of the design, and reference the parent.
- Publish in dependency order (blockers first), so each ticket's blocking edges can reference real identifiers.
  Use the tracker's native parent and blocking relationships where it has them;
  otherwise list them in the ticket's **Context** and **Blocked by**.
- Set each published ticket's state to `ready-for-agent` (see `/ticket-states`): the single ticket, or each child.
  The parent carries no state: clear any it had.
- If the source was an existing rough ticket, rewrite it into the single ticket or the parent,
  keeping its original text in a note.

For example, in Beads: the parent is an epic with the overall design in its `design` field.
Each child is created with `--parent`, with its slice of the design in `design` and its done checks in `acceptance`;
blocking edges are `bd dep add <ticket> <blocker>`.

Report the tickets created, and which can start now.

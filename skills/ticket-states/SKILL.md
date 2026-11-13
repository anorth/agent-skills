---
name: ticket-states
description: >-
  A small shared vocabulary of ticket states that say who acts next: needs design, ready for an agent,
  needs a human, needs review.
  Use when filing, triaging, or labelling tickets, when a skill sets or clears a ticket's state,
  or when the user asks what needs design, review, or their attention, or what's ready for an agent.
disable-model-invocation: false
metadata:
  credit: "Inspired by Matt Pocock's triage roles, github.com/mattpocock/skills (MIT, (c) 2026 Matt Pocock)"
---

# Ticket states

A ticket's state says who acts next.
The tracker owns lifecycle: claims, blocking edges, deferral, and closing.
These states record only what the tracker can't: whether a ticket is designed, approved, or waiting on a human.

## States

| State | Meaning | Set by | Cleared by |
| --- | --- | --- | --- |
| *(none)* | Untriaged: nobody has looked at it | | whoever triages it |
| `needs-design` | Real work; design is the next step | whoever triages it; `/build-ticket` stopping for redesign | `/to-tickets` |
| `ready-for-agent` | Designed and approved by a human; an agent may pick it up | `/to-tickets`; a human answering | `/build-ticket` |
| `needs-human` | An agent needs a decision or an answer; the ticket's note says what | `/build-ticket` stopping on a question | whoever answers it |
| `needs-review` | Built with evidence, still claimed, not yet landed | `/build-ticket` hand-off | closing the ticket |

## Rules

- A ticket has at most one state: setting one removes any other. Closing a ticket removes its state.
- Parent tickets carry no state; their children do. A parent not yet designed may be `needs-design`.
- Tickets are often filed with no state. An agent may triage them for the user,
  setting any state except `ready-for-agent`, e.g. `needs-design` for work still to be designed.
- Only a human's approval sets `ready-for-agent`: `/to-tickets` after the user approves the tickets,
  or the user answering a `needs-human` ticket. It records that a human approved the design.
- An agent choosing its own work picks only open, unblocked `ready-for-agent` tickets.
  A ticket the user names directly needs no state.
- To answer a `needs-human` ticket, add a note with the answer, then set the next state:
  `ready-for-agent` if the design stands, `needs-design` if it must be redesigned or split.

## Names

Use the state names as labels or tags.
A project overrides a name with one line in its `AGENTS.md`,
e.g. "Use label `agent-ready` for tickets ready for implementation."
Use the override wherever this skill names that state, commands included.
In a tracker with neither labels nor tags, write a `State:` line in the ticket.

## Beads

`needs-human` is beads' own `human` label, so `bd human list` shows it.
Never answer one with `bd human respond` or `bd human dismiss`: both close the ticket.

The state labels are `needs-design`, `ready-for-agent`, `human`, and `needs-review`.
Set a state by adding its label and removing the other three,
e.g. `needs-human`: `bd update <id> --add-label human --remove-label needs-design,ready-for-agent,needs-review`.
Clear it: `bd update <id> --remove-label needs-design,ready-for-agent,human,needs-review`.
Don't use `--set-labels`: it also removes labels that aren't states.
Add a note with `bd update <id> --append-notes "<text>"`; `--notes` replaces the existing notes.

A child created with `--parent` inherits its parent's labels, state included, and labels given at create add to them.
Set the child's state with `bd update` after creating it.
The untriaged query also lists parents: a parent with children (`bd children <id>`) is already triaged.

| Question | Command |
| --- | --- |
| What's ready for an agent? | `bd ready -l ready-for-agent` |
| What needs design? | `bd list -l needs-design` |
| What needs me? | `bd human list`, and `bd list -l needs-review` |
| What's untriaged? | `bd list --status=open --exclude-label needs-design,ready-for-agent,human,needs-review` |

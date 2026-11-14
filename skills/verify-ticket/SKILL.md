---
name: verify-ticket
description: >-
  Verifies a change against a ticket's done checks as a non-author: runs each check on the best surface available,
  the way a user would, and returns PASS, PASS+NOTES, FAIL, or INCONCLUSIVE with evidence.
  Use when the user or agent asks to verify a ticket, a branch, or a built change.
disable-model-invocation: false
metadata:
  credit: "Inspired by Lauren Tan's pstack shipping playbook and Cursor's verify-this skill, github.com/cursor/plugins (MIT)"
---

# Verify ticket

Only a verdict from an agent that did not write the code counts.
A verifier works from the ticket, runs its done checks, and returns a verdict with evidence.
Green tests and an approving review are not verdicts.

You coordinate: load, choose who verifies, brief, relay, record.
The verifier follows [`verifier.md`](verifier.md), in this skill's directory.

## 1. Load

Read the ticket in full, with its notes and comments.
The change to verify is the working tree.
If the user names a ref instead, check it out into a temporary `git worktree`, verify that tree, and remove it after.
If it's unclear which ticket or change, ask.
Find the implementer's model: an `Implementer:` line in the ticket's comments,
else this conversation's model if it wrote the change.

The evidence directory is `${TMPDIR:-/tmp}/verify-ticket/<repo directory name>/<ticket-id>/`.
Empty it if it exists.

## 2. Choose who verifies

If this conversation wrote or edited the change, or you can't tell, spawn a verifier subagent.
Start it with a fresh context window, not a fork, on the `standard` tier (see `/model-tiers`).
Brief it with:

```text
Read and follow <absolute path to this skill's directory>/verifier.md.
Ticket: <ticket id, or its full text with its notes and comments>
Change: working tree at <absolute path>
Implementer: <model, or "unknown">
Evidence directory: <absolute path>
```

Never pass the builder's done-check evidence, results, or report.
A verdict of any kind, FAIL included, is the result.
If the verifier errors or returns no verdict, empty the evidence directory and retry once.
If that fails too, report the blocker and stop.

Otherwise, verify inline: follow `verifier.md` yourself.
If your model is the implementer's, say so in the verdict.

## 3. Relay and record

Report the verdict verbatim. Don't soften, reinterpret, or override it.
Comment on the ticket (see `/ticket-states`) in one line: the verdict, the verifier's model, and the evidence directory.

Change the ticket's state only when the calling skill says to.

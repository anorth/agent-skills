---
name: prepare-commit
description: >-
  Checklist before making a commit: check and update the originating issue or task,
  run tests and lint. Does not commit.
  Use when the user asks to prepare a commit, get ready to commit, or commit changes.
disable-model-invocation: false
---

# Prepare commit

Checklist before a commit. **Do not commit.** Stop when the checklist is done and wait.

## Workflow

Run in this order.

### 1. Originating artifacts

Re-read the issue, task, or any other artifacts that were the starting point for this conversation, and the code diff.

- Is everything in the issue addressed?
- Summarise the issue and what changes have been made.

Where we have made decisions that contradict the issue, update the issue so it reflects what was actually built.

If there is no written starting point, say so and continue.

### 2. Tests and lint

Prefer the project's documented lint and test entrypoints. Run lint, then tests. Fail-stop on either — do not present the work as ready to commit if either fails.

Don't run a full production build unless the project documents that as the check to use.

## Hard rules

- Do not commit, amend or otherwise rewrite history.
- If the user asked to commit, still only prepare. After the checklist, wait for them to confirm.

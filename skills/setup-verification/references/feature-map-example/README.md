# Notes verification map

This directory is the maintained source for verifying the user-facing behaviour of Notes.
Read the index before driving the app, then use the matching feature file as the recipe.

## Baseline preconditions

- Run `.agents/skills/verify-notes/app launch`; it prints the URL and the run-state file.
- `app launch` reuses the dev server for this checkout if `app doctor` passes,
  and otherwise starts one on a free port against a per-run database `notes_verify_<run id>`.
- The database is seeded with notes titled `Quarterly plan` and `Grocery list`,
  and the test user `verify@example.test`, already signed in through the real login form.
- Run `app doctor` and require the expected URL, checkout directory, latest migration, and a valid session.
- Never drive an instance that `app doctor` hasn't passed since it last did something surprising.

## Driving conventions

- Start every journey from the baseline state unless its preconditions say otherwise.
- Prefer roles and accessible names over CSS selectors or DOM position.
- Run a feature's journey with `app journey <feature> <evidence dir>`.
- Look at a page before scripting with `app aria <path>` or `app shot <path> <file>`.
- For a check the map doesn't cover, write a new script that imports `journeys/helpers.ts`.
- Restore seeded data after a mutation. Never remove proof artifacts during cleanup.

## Proof and skip reporting

- Capture the user action and the resulting state, not only the final screen.
- UI proof is a screenshot and an accessibility snapshot, with the app identity visible.
- Mutation proof includes a second, read-only view of the stored value: reopening it in the UI, or `app sql`.
- Record the feature ID and entry point with every artifact.
- Report an unreachable path with the attempted step and the unmet precondition.
- Don't report a skipped entry point as verified through a different path.

## Feature entry contract

Each feature file starts with an H1 title and one paragraph describing the user-visible behaviour.
It then has exactly four H2 sections, in this order:

1. `Sub-features` lists short IDs, with one line for each behaviour.
2. `How to get to it (user POV)` lists every user entry point.
3. `Driving it with Playwright` names its journey script, starts with `Preconditions:`,
   and pairs each user action with its exact handle and observable result, as labelled bullets.
4. `Gotchas` lists traps that can waste or invalidate a verification run.

Keep implementation details out of the map. Name only user paths, stable handles, required state, commands, and observable proof.

## Features

- [Create a note](./create-note.md) covers creating, saving, and cancelling a note, and its persistence.

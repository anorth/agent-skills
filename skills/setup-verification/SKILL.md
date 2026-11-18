---
name: setup-verification
description: >-
  Sets up a project's verification: a driver CLI that launches the app and drives it the way a user does,
  journeys over a map of its features, and a verify-<app> skill that documents them; proven once end to end.
disable-model-invocation: true
metadata:
  credit: "Adapted from Lauren Tan's pstack create-verification-skill, github.com/cursor/plugins (MIT)"
---

# Set up verification

Set up what an agent needs to drive the real app and prove behaviour:
launch it, exercise a feature the way a user would, and capture evidence.
Verifiers (see `/verify-ticket`) and builders reach for it first.

The deliverable is a working driver, and a skill that documents it:

```text
.agents/skills/verify-<app>/
├── SKILL.md      # how to use the driver, written for an agent reading it cold
├── app           # the driver CLI: launch, doctor, cleanup, journey, …
├── journeys/     # one script per mapped feature, plus the helpers they share
└── features/     # the feature map
```

A `SKILL.md` that tells an agent what to do by hand, without a driver that does it, is a draft.

## 1. Interview the repo, not the user

Answer these from the codebase, and ask the user only what you cannot observe:

- **Surface:** what does a user actually touch? A web UI, a CLI or TUI, a desktop app, an API, a library?
  A repo can have several; pick the primary one and note the rest.
- **Run:** how does the app start locally? Prefer the repo's own documented dev command.
  Note ports, env vars, migrations, seed data, and auth.
- **Existing harness:** does the repo have code that launches or drives the app, such as e2e specs or scripts?
  The driver wraps it rather than duplicating it.
  A skill that only finds a running server, or a browser tool from the agent's harness, is not a harness:
  the driver may call it, but still has to launch and drive the app itself.
- **Observe:** what evidence can be captured? Screenshots, accessibility snapshots, terminal transcripts,
  response bodies, network requests, logs, exit codes, DB state.
- **Share:** what does launching or driving change that another instance relies on?
  Branch migrations applied to a shared dev database, data a journey creates, a lock or build directory
  two dev servers in one checkout would fight over.
  Isolate that, and only that: verification runs in the checkout it's given, not a new worktree.

If the checkout doesn't build or start as-is, fix that first, or report it precisely, before generating:
a driver built against a broken base encodes wrong steps.
When an irrelevant missing asset blocks startup (a static dir the app never serves, a sample config),
the driver may create it, clearly marked as verification scaffolding, and remove it in cleanup.

## 2. Build the driver

Read [`driver-shapes.md`](driver-shapes.md) and build the shape for the primary surface:
the `app` driver CLI and the helpers journeys share, in `.agents/skills/verify-<app>/`.
Its commands meet these requirements:

- **`launch`** brings up an instance for verification and returns once it's ready.
  If an instance already serving this checkout passes doctor, it reuses it; otherwise it starts one on a free port.
  It reaches a usable state from empty, including migrations, seed data, and a signed-in test user where there's auth.
  Ready means usable, not just that a process answers: a database health check can pass while its init scripts still run.
  For a short-lived CLI or TUI there is no server: launch builds it once, and each drive runs in its own isolated session.
- **`doctor`** is one read-only check that answers "is this instance worth driving?":
  process up, serving this checkout, port owned by that process, data migrated, auth valid.
- **`cleanup`** tears down what this run started, and nothing else: a reused instance stays up.
  It never kills by process name.
  It removes instances and scratch state, never evidence.
- **`journey <feature> <evidence dir>`** runs one feature's journey script, writing its evidence there.
  Callers name the evidence directory (`/verify-ticket` does); the driver has a default for runs without one.

Drive by stable handles (roles and accessible names, data attributes, prompt strings, routes),
not coordinates or order.
Every script is executable, and every command has `--help` with examples.

## 3. Seed the feature map and its journeys

Create `features/README.md`, plus one file per user-facing feature you can identify:
the top 3–5 to start, from routes, commands, menus, or docs.
Follow the shape in [`references/feature-map-example/`](references/feature-map-example/):
a README index, and one file per feature with four H2s:
`Sub-features`, `How to get to it (user POV)`, `Driving it with <harness>`, and `Gotchas`.
Each feature file says, from the user's point of view, what the feature is, how to reach it,
how to drive it, and what observable end state proves it works.

Write a journey script for each feature file, named in its `Driving it with` section,
that performs its steps in order (see [`references/example-journey.ts`](references/example-journey.ts)).
Journeys meet these proof standards, and the skill states them for verifiers writing new scripts:

- exercise the real user path, not internal setters or test-only endpoints;
- capture the action and the resulting state, not just the final screen;
- verify side effects (rows written, files created, messages sent) alongside what's visible;
- use mocks only where a production boundary already isolates the external system;
- when the safe path is a dry run or test mode, observe what it actually skips (files, network, git refs)
  rather than trusting its name.

If the seed data lacks a precondition a journey needs, the journey reports a failure and the reason goes in `Gotchas`.
Never weaken a journey to make it pass.
The map is the repo's maintained verification source:
a proof that drives one convenient entry point is incomplete when the map lists others.

## 4. Write the skill

Write `SKILL.md`, formatted by `/markdown-for-humans`, with frontmatter:
`name: verify-<app>` and a `description` that names the app, the surface, and when to reach for it.
Without frontmatter the skill never registers.
Symlink the skill directory into each skills directory a harness in use here reads instead of `.agents/skills`,
e.g. `.claude/skills/verify-<app>` → `../../.agents/skills/verify-<app>`.

Write it for the next agent, not for a human: it will be read cold, mid-task, by an agent that has never seen the app.
Give it these sections, each an `app` invocation with what it prints and what to do when it fails,
and no placeholders left:

- **Launch**, **Doctor** (run before the first drive and whenever anything looks off), and **Cleanup**.
- **Drive:** running a mapped journey, looking at the app before scripting, and writing a new script from the helpers
  for a check the map doesn't cover.
- **Evidence:** what a proof captures and where it goes, and the proof standards from step 3.

## 5. Prove it before handing it over

Run the check script and fix every failure:

```bash
<this skill's directory>/scripts/check-verify-skill.sh .agents/skills/verify-<app>
```

Then run it end to end through the driver: `app launch`, `app doctor`, every `app journey`, `app cleanup`.
After cleanup, confirm the evidence still exists where it was named: a cleanup that eats the proof fails this step.
Fix what fails, and run `app cleanup` after every failed attempt too, so attempts don't strand processes and ports.

Then have it read cold.
Spawn a subagent with a fresh context window, not a fork, on the `standard` tier (see `/model-tiers`).
Brief it with one check the map doesn't cover, about a mapped feature, worded as a ticket's done check would be.
It proves the check using only the skill, its driver, and its helpers,
and reports every step it had to guess, work around, ask about, or do by hand.

A step done by hand, by you or the cold reader, is a gap in the driver: add the command or helper that does it.
Fix the skill for each report, and re-run what the fixes touch.

A generated skill that was never executed is a draft, not a deliverable.
If you proved it in a stand-in for the real target (a container in place of a fresh VM, a local stack in place of a remote one),
list every setup step the stand-in did that the target will not.
Those steps stay unverified until a run on the real target covers them.

## 6. Hand over

Report:

- the skill's path, and the driver's commands, from `app --help`;
- the features mapped, each with its journey;
- the check script's output;
- what the proof runs drove, and where their evidence is;
- what the cold reader had to guess or do by hand, and what you added for it;
- anything left unverified.

When the app changes, its feature map and journeys change in the same change.

# Driver shapes

Every generated skill ships a driver.
Pick the shape by the primary surface, and adapt it to the repo's language and tools.
Where the repo already has code that launches or drives the app, the driver wraps it.

Whatever the shape:

- **Ship one driver CLI**, `app`, next to the skill, for agents and humans alike.
  It holds what's specific to this app: how to launch, seed, sign in, check health, and where evidence goes.
  Its commands are non-interactive, each has `--help` with examples, and errors say what to do next
  (Cursor's `cli-for-agents` skill, if available, covers this).
- **Keep its commands stateless.** Each command does its job and exits, apart from the instance `launch` starts.
  `launch` records what it started (pids, ports, databases, whether it reused an instance) in a run-state file,
  and `cleanup` stops only what that file lists.
- **Drive with journey scripts on a standard library**: Playwright for a web UI, tmux or a PTY for a terminal app, HTTP for a service.
  A script can be re-run as evidence, and works the same in any harness.
  `app journey <feature> <evidence dir>` runs one.
  A harness's own browser or terminal tool is fine for exploring, but the skill's proofs don't depend on it.
- **Add stateful step commands only with a reason**, such as `app browser click` on a browser kept open between calls.
  Add them if the repo already has such a driver,
  or if no generic tool can explore the app step by step and stateless looks aren't enough.
  Then `doctor` checks that session too, and `cleanup` closes it.
  Otherwise they add hidden state (current page, focus) and a second way to drive that the map must keep in step with.

## Web app with a database

The shape to start from for a dev-server web app (Next.js, Rails, Django, …) backed by a database.

- **`app` driver** (shell or the repo's language), with these commands:
  - `launch`: if a dev server is already serving this checkout and `doctor` passes, reuse it and record that.
    Otherwise pick a free port.
    If the dev database is shared with other checkouts, create a per-run database and point the app at it;
    if each checkout already has its own, use that.
    Run migrations and seed fixtures, including a test user, then start the documented dev command.
    Wait until a seeded page renders signed in, not just until the port answers.
  - `doctor`: read-only. The process is alive and owns the port, it serves this checkout (its working directory),
    the database is migrated to this checkout's latest migration, and the test user can sign in.
  - `cleanup`: stop the dev server and drop the per-run database, if this run started them.
  - `sql`: a query against the instance's database: read-only for side-effect evidence,
    and writes only to remove fixtures a journey created.
  - `signin`: sign the test user in (below), refreshing the saved session.
  - `aria <path>` and `shot <path> <file>`: open a page signed in, then print its accessibility tree or save a screenshot.
    These let an agent look before it scripts, with nothing left running.
  - `open [path]`: a visible browser, signed in as the test user, for a human to drive.
  - `journey <feature> <evidence dir>`: run one feature's journey script.
- **Sign-in:** `app signin` signs in the test user through the real login path,
  and saves the browser storage state for the other commands and journeys to reuse.
  If the real path can't run locally (an OAuth provider, a magic link with no dev outbox),
  use the app's own non-production path if it has one.
  Otherwise mint a session for the test user, say so in the map's baseline,
  and record sign-in itself as unreachable, with the prerequisite it lacks.
- **Playwright** from the repo's dependencies.
  If the repo has none, ask the user before adding it as a dev dependency.
- **Capture helpers** that journeys import: open a path signed in; save a screenshot and an accessibility snapshot of a state;
  record the requests an action makes and console errors, to files in the evidence directory.
- **One journey script per feature file**, run by `app journey` with the repo's script runner.
  It takes the evidence directory as an argument, performs the feature file's steps in order,
  writes its evidence, and exits non-zero at the first unmet result, naming it.
  See [`references/example-journey.ts`](references/example-journey.ts).

A verifier writes new scripts from the same helpers for checks the map doesn't cover.

## Terminal app (CLI or TUI)

- `launch` builds or installs once. There's no server to keep alive.
- Each drive runs in a fresh tmux session or PTY with a unique name,
  and its own config and data directories (env vars, flags, or `HOME`).
- Drive by sending keys or arguments; wait on prompt strings, not sleeps.
- Evidence: the command, stdout, stderr, exit code, a pane capture for a TUI, and files written.

## Service or API

- Lifecycle as for a web app, without a browser.
- Drive with `curl` or a small HTTP script per journey.
- Evidence: each request, the response status and body, relevant logs, and side effects in storage.

## Library

- There is no app to launch. A drive is a small program that uses the public API the way a caller would.
- Evidence: its output and exit code.
- If the repo's tests already do exactly this, say so in the skill and keep it short.

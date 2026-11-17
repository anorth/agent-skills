---
name: orca-workers
description: >-
  Runs workers through Orca in other harnesses' CLI agents (Codex, Grok, Claude Code, …).
  Covers checking Orca is reachable, each agent's model slugs and efforts, briefing workers,
  collecting results, and creating and removing workers' worktrees.
  Use when the `/model-tiers` skill resolves a model the harness's built-in subagent tool doesn't offer,
  when the user or a calling skill asks for a worker or subagent from another harness,
  or when creating or removing Orca worktrees for workers.
disable-model-invocation: false
---

# Orca workers

Orca's `orchestration` skill is the reference for starting and supervising workers.
Load it, or if it isn't installed, fetch the guide matched to the installed CLI with `orca skills get orchestration`.
Each worker starts with a fresh context window.

That guide says to prefer your own subagents.
That holds only when they offer the model `/model-tiers` resolved; otherwise use an Orca worker.

## Reachable

Run [`scripts/reachable`](scripts/reachable), in this skill's directory.
It reports whether Orca is reachable, and which agents in the table below are installed and signed in here.
It exits non-zero if none can run.
Inside an Orca session, `$ORCA_CLI_COMMAND` names the executable if `orca` isn't on `PATH`; the script uses it.

## Agents and models

Pick the agent by model family, and pass the model's slug as `--model` and the effort `/model-tiers` chose as `--effort`.
Slugs follow each family's pattern, so infer one not listed here from its name, e.g. GPT-6.2 Terra → `gpt-6.2-terra`.
These were current at 2026-11; the list may drift.

| Family | `--agent` | Example slugs | `--effort` |
| --- | --- | --- | --- |
| GPT | `codex` | `gpt-6.1-sol`, `gpt-6.1-terra`, `gpt-6-astra`, `gpt-6-luna` | `low` `medium` `high` `xhigh` `max`; `ultra` except Luna |
| Grok | `grok` | `grok-4.7`, `grok-4.7-build-fast` (Grok 4.7 Fast), `grok-4.6` | `low` `medium` `high` `xhigh` |
| Claude | `claude` | `claude-opus-5-5`, `claude-sonnet-5-5`, `claude-haiku-5-5`, `claude-fable-5-1` | `low` `medium` `high` `xhigh` `max` |
| Cursor | `cursor` | `composer-2.5`, `composer-2.5-fast` | none; omit `--effort` |

Cursor's CLI also lists other families' models, but they need prepaid API credits.
Use the `cursor` agent only for Composer; reach other families through their own agents.

An agent works only if `scripts/reachable` reports it signed in.
When adding a row, add its check to the script.

Orca's guide says to pass `--model` only if the user named one: a model resolved from the user's tiers counts as named.

Orca starts a worker with any `--model` string.
A model the CLI rejects shows up later as an `escalation` with `stopReason: errored`, not as a failed start.
Stop that worker with `worker-stop`, and start a new one on the tier's next entry.

## Brief

Give each worker a self-contained brief, as you would a built-in subagent, plus:

- What it may edit, usually nothing. A worker works in your workspace with `--worktree current`
  unless it needs its own worktree; see [Worktrees](#worktrees).
- A `worker_done` body is three sentences. For anything longer, such as findings,
  have it write the report to a file under `/tmp` and pass that file's path with `--report-path`.

## Collect results

Workers report asynchronously.

1. Once every worker is started, you can end your turn or wait. Don't poll or sleep.
   Orca wakes you with each `worker_done` or `escalation`; some harnesses deliver them mid-turn, as messages.
2. Continue the calling skill once every worker and subagent has reported or been given up on.

A worker in your workspace closes when it finishes.
One in its own worktree stays open until you release it.

## Worktrees

When a worker needs its own worktree, such as when its edits would conflict with yours or another worker's,
start it in one nested under yours: `worker-start --worktree new-child --name <short-name>`.
Leave `--setup` unset so the repo's setup hooks run, unless the user says otherwise.

Remove the worktree once its branch has landed or been abandoned,
always with `--run-hooks`:

```bash
orca worktree rm --worktree <selector> --run-hooks --json
```

Without it, Orca skips the repo's `orca.yaml` archive hooks, even if an example in Orca's guide leaves it out.
Never remove an Orca worktree with `git worktree remove`, which also skips them.
If an archive hook fails, the worktree stays; report the failure to the user
rather than passing `--allow-failed-archive-hook`.

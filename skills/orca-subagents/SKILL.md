---
name: orca-subagents
description: >-
  Runs a subagent as an Orca worker in another harness's CLI agent (Codex, Grok, Claude Code, …).
  Covers checking Orca is reachable, each agent's model slugs and efforts, and collecting results.
  Use when the `/model-tiers` skill resolves a model only Orca reaches,
  or when the user asks for a subagent from another harness.
disable-model-invocation: false
---

# Orca subagents

Orca's `orchestration` skill is the reference for starting and supervising workers.
Load it, or if it isn't installed, fetch the guide matched to the installed CLI with `orca skills get orchestration`.
Each worker starts with a fresh context window, as a subagent should.

## Reachable

Orca is reachable when `orca status` shows `runtimeReachable: true`.
Inside an Orca session, `$ORCA_CLI_COMMAND` names the executable if `orca` isn't on `PATH`.

## Agents and models

Pick the agent by model family, and pass the model's slug as `--model` and the tier entry's effort as `--effort`.
Slugs follow each family's pattern, so infer one not listed here from its name, e.g. GPT-6.2 Terra → `gpt-6.2-terra`.
These were current at 2026-11; the list may drift.

| Family | `--agent` | Example slugs | `--effort` |
| --- | --- | --- | --- |
| GPT | `codex` | `gpt-6.1-sol`, `gpt-6.1-terra`, `gpt-6-astra`, `gpt-6-luna` | `low` `medium` `high` `xhigh` `max`; `ultra` except Luna |
| Grok | `grok` | `grok-4.7`, `grok-4.7-build-fast` (Grok 4.7 Fast), `grok-4.6` | `low` `medium` `high` `xhigh` |
| Claude | `claude` | `claude-opus-5-5`, `claude-sonnet-5-5`, `claude-haiku-5-5`, `claude-fable-5-1` | `low` `medium` `high` `xhigh` `max` |

An agent works only if its CLI is installed and signed in here.

Orca's guide says to pass `--model` only if the user named one: a model resolved from the user's tiers counts as named.

Orca starts a worker with any `--model` string.
A model the CLI rejects shows up later as an `escalation` with `stopReason: errored`, not as a failed start.
Stop that worker with `worker-stop`, and start a new one on the tier's next entry.

## Brief

Give each worker the brief you'd give a built-in subagent, self-contained, plus:

- What it may edit, usually nothing. A reader works in your workspace with `--worktree current`.
- A `worker_done` body is three sentences. For anything longer, such as findings,
  have it write the report to a file under `/tmp` and pass that file's path with `--report-path`.

## Collect results

Workers report asynchronously.

1. Once every subagent is started, you can end your turn or wait. Don't poll or sleep.
   Orca wakes you with each `worker_done` or `escalation`; some harnesses deliver them mid-turn, as messages.
2. Continue the calling skill once every subagent, built-in and Orca, has reported or been given up on.

Finished workers close on their own.

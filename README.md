# agent-skills

Personal agent skills for coding agents. Follow the [Agent Skills](https://agentskills.io) layout.

## Install

```sh
npx skills add anorth/agent-skills
```

Install one skill only:

```sh
npx skills add anorth/agent-skills --skill reflect
```

Skills that spawn subagents pick models by tier through `model-tiers`, which reads `~/.agents/model-tiers.md`.
One list serves every harness; ask an agent to "set up model tiers" to write it.
`deep-review` runs `review-diff`'s flow, so install it together with `review-diff` and `model-tiers`.

List what the repo contains:

```sh
npx skills add anorth/agent-skills --list
```

## Skills

### Workflow

| Skill | Purpose |
| --- | --- |
| `ready-ticket` | What a ticket needs before an agent can build it unattended; check a ticket against it |
| `lets-build` | Build from a written ticket, with the user clarifying design |
| `build-ticket` | Build one ready ticket unattended, through to a reviewed result with evidence |
| `prepare-commit` | Checklist before a commit; commits if asked |
| `land-to-main` | Land a finished work branch onto local `main`, and close its tickets |

### Design

| Skill | Purpose |
| --- | --- |
| `grilling` | Interview the user, round by round, until every decision is settled |
| `domain-modeling` | Sharpen domain terms; keep `GLOSSARY.md` and ADRs current as they come up |

### Quality

| Skill | Purpose |
| --- | --- |
| `reflect` | Second pass after implementation: simplify and raise product forks |
| `review-diff` | Review a git diff via big-picture and detail reviewer subagents, then check, triage, and fix |
| `deep-review` | `review-diff` plus one cheap reviewer per theme, from Alex North's GitHub review preferences |

### Support

| Skill | Purpose |
| --- | --- |
| `model-tiers` | Map cheap/standard/strong tiers to available models; keep reviewers off the implementer's model |

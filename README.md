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

Skills that spawn subagents pick models by tier through `model-tiers`, which ships default tiers.
To change them for one environment, ask an agent to "set up model tiers":
it writes `~/.agents/model-tiers.md`, which replaces the defaults.
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
| `to-tickets` | Break a settled design into ready tickets: one, or a parent plus child slices with blocking edges |
| `lets-build` | Build a ticket with the user in the loop, designing it first if it isn't ready |
| `build-ticket` | Build one ready ticket, unattended by default, through to a reviewed result with evidence |
| `prepare-commit` | Checklist before a commit; commits if asked |
| `land-to-main` | Land a finished work branch onto local `main`, and close its tickets |

### Design

| Skill | Purpose |
| --- | --- |
| `lets-design` | Design a change with the user: ground, grill, size, and design it |
| `design` | How to communicate a design proposal, as a sketch or a detailed design ready to split into tickets |
| `grilling` | Interview the user, round by round, until every decision is settled |
| `domain-modeling` | Sharpen domain terms; keep `GLOSSARY.md` and ADRs current as they come up |
| `design-it-twice` | Explore radically different designs in parallel subagents, compare them, and recommend one |
| `arena` | Parallel candidates on different models, a cross-model judge, then pick a base and graft |

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
| `markdown-for-humans` | Keep markdown readable by humans, especially in diffs: break lines at sentence and phrase boundaries |

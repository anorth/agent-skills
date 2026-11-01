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
| `lets-build` | Build from a written issue, with the user clarifying design |
| `prepare-commit` | Checklist before a commit |
| `land-to-main` | Land a finished work branch onto local `main` |

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

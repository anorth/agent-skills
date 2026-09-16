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

List what the repo contains:

```sh
npx skills add anorth/agent-skills --list
```

## Skills

| Skill | Purpose |
| --- | --- |
| `lets-build` | Build from a written issue, with the user clarifying design |
| `reflect` | Second pass after implementation: simplify and raise product forks |
| `review-diff` | Two-pass review of a git diff |
| `sub-agent-review` | Run `review-diff` via subagents, then triage and fix |
| `prepare-commit` | Checklist before a commit |
| `land-to-main` | Land a finished work branch onto local `main` |

# @anorth's Agent Skills

This repo is a collection of agent skills by and for @anorth.
The goal is to build toward trustworthy, self-verifying, and self-improving agents.
The ideal outcome is that the human user's time is spent (a) describing what they want, (b) reviewing the results,
and (c) improving the processes embodied by these and project-specific skills.

Skills are organized in the [Agent Skills](https://agentskills.io) layout.
Install instructions and the skill list are in the README.

## Layout

Author each skill at `skills/<name>/SKILL.md`, with `name` matching the directory.
Keep notes, themes, and scripts inside that directory.

```
skill-name/
├── SKILL.md              # Required - main instructions
├── reference.md          # Optional - detailed documentation
├── examples.md           # Optional - usage examples
└── scripts/              # Optional - utility scripts
    ├── validate.py
    └── helper.sh
```

The markdown files (and diffs on them) are read by humans too; format them for human readability.
Break long lines at sentence or clause boundaries to keep lines below ~120 chars (rough target).
This file is an example.

## Changing a skill

For authoring — frontmatter, description, and structure — follow Cursor's `create-skill` skill if available.
Credit a skill adapted from someone else's with a one-line `metadata.credit` in its frontmatter.

Update the README tables in the same change that adds, removes, or retitles a skill.
When one skill loads another, keep both sides consistent. Grep for usage in other skills after significant edits.

Outside `model-tiers`, skills name a model tier (`cheap`, `standard`, `strong`), never a model or slug.
The `model-tiers` skill resolves tiers to whatever models the harness offers.

Every skill that dispatches a subagent says to start it with a fresh context window. 
Some harnesses fork the parent conversation by default, and a fork inherits the parent's context, 
which is what the subagent was meant to escape.

## Authoring principles

### 1. Concise is Key

The context window is shared with conversation history, other skills, and requests. Every token competes for space.

**Default assumption**: The agent is already very smart. Only add context it doesn't already have.

Challenge each piece of information:
- "Does the agent really need this explanation?"
- "Can I assume the agent knows this?"
- "Does this paragraph justify its token cost?"

### 2. Automate where possible

Don't make the agent carry out routine logic that doesn't need judgement: script it instead.

## Glossary
- **ticket**: record of a unit of work
- **issue tracker**: place where tickets are tracked

<!-- BEGIN BEADS INTEGRATION v:1 profile:minimal hash:46cd31e7 -->
## Beads Issue Tracker

This project uses **bd (beads)** for issue tracking. Run `bd prime` to see full workflow context and commands.

### Quick Reference

```bash
bd ready              # Find available work
bd show <id>          # View issue details
bd update <id> --claim  # Claim work
bd close <id>         # Complete work
```

### Rules

- Use `bd` for ALL task tracking — do NOT use TodoWrite, TaskCreate, or markdown TODO lists
- Run `bd prime` for detailed command reference and session close protocol
- Use `bd remember` for persistent knowledge — do NOT use MEMORY.md files

**Architecture in one line:** issues live in a local Dolt DB; sync uses `refs/dolt/data` on your git remote; `.beads/issues.jsonl` is a passive export. See https://github.com/gastownhall/beads/blob/main/docs/core-concepts/sync-concepts.md for details and anti-patterns.

## Agent Context Profiles

The managed Beads block is task-tracking guidance, not permission to override repository, user, or orchestrator instructions.

- **Conservative (default)**: Use `bd` for task tracking. Do not run git commits, git pushes, or Dolt remote sync unless explicitly asked. At handoff, report changed files, validation, and suggested next commands.
- **Minimal**: Keep tool instruction files as pointers to `bd prime`; use the same conservative git policy unless active instructions say otherwise.
- **Team-maintainer**: Only when the repository explicitly opts in, agents may close beads, run quality gates, commit, and push as part of session close. A current "do not commit" or "do not push" instruction still wins.

## Session Completion

This protocol applies when ending a Beads implementation workflow. It is subordinate to explicit user, repository, and orchestrator instructions.

1. **File issues for remaining work** - Create beads for anything that needs follow-up
2. **Run quality gates** (if code changed) - Tests, linters, builds
3. **Update issue status** - Close finished work, update in-progress items
4. **Handle git/sync by active profile**:
   ```bash
   # Conservative/minimal/default: report status and proposed commands; wait for approval.
   git status

   # Team-maintainer opt-in only, unless current instructions forbid it:
   git pull --rebase
   bd dolt push
   git push
   git status
   ```
5. **Hand off** - Summarize changes, validation, issue status, and any blocked sync/commit/push step

**Critical rules:**
- Explicit user or orchestrator instructions override this Beads block.
- Do not commit or push without clear authority from the active profile or the current user request.
- If a required sync or push is blocked, stop and report the exact command and error.
<!-- END BEADS INTEGRATION -->

In a new checkout, run `bd bootstrap && bd hooks install` to set up the issue database and git hooks.

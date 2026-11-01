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

Cursor's `create-skill` skill describes where an installed copy lives.
In this repo, the source of truth is `skills/`.
Consumers install with `npx skills add anorth/agent-skills`.

The markdown files (and diffs on them) are read by humans too; format them for human readability.
Break long lines at sentence or clause boundaries to keep lines below ~120 chars.
This file is an example.

## Changing a skill

For authoring — frontmatter, description, and structure — follow Cursor's `create-skill` skill.
While editing an existing skill, keep its `disable-model-invocation` value unless the agreed change says otherwise.

Update the README tables in the same change that adds, removes, or retitles a skill.
When one skill loads another, keep both sides consistent
(`lets-build` → `reflect`; `review-diff` and `deep-review` → `model-tiers`).

Outside `model-tiers`, skills name a model tier (`cheap`, `standard`, `strong`), never a model or slug.
The `model-tiers` skill resolves tiers to whatever models the harness offers.

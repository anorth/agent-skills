---
name: review-diff
description: >-
  Reviews git diffs (typically worktree vs current branch HEAD) for quality and
  correctness. Two-pass workflow: architecture and design first, then detail and
  edge cases. Use when the user asks for a code review, PR review, sanity check
  on changes, or review of unstaged or committed diffs.
disable-model-invocation: false
---

# Review diff

Read the change set (usually `git diff` against `HEAD` of the current branch). Also read existing code surrounding and/or relevant to the diff. Usually read the files touched significantly in full, as well as functions and methods that are called by the changed code, and peer files that can serve as reference for patterns and conventions.

Focus both on problems to fix and opportunities to improve. Output numbered points in **decreasing order of importance**. A useful shape is: short summary, then issues and opportunities, then open questions—but no rigid template is required.

Do make suggestions for how to resolve any issue encountered. Do **not** apply substantive edits before discussion; at most make trivial formatting changes.

Repository policy files (for example `AGENTS.md`) are background: assume they were already followed. Instead, judge the diff against **how the rest of the codebase actually behaves**—open unchanged files the diff touches or depends on when judging patterns and boundaries.

You do not need to run tests or lints, assume that's already been done.

## Pass 1 — Big picture

- Is the approach appropriate for the problem being solved?
- Does it fit the surrounding codebase in structure, conventions, and patterns?
- Are concerns decoupled sensibly? Where the change meets existing modules, are boundaries clean?
- For patterns that already exist (database access, routes, HTTP APIs, repetitive UI): is this use **consistent** with other uses, or is divergence justified and obvious?
- Are there chances to **clarify** intent—through structure, naming, or a brief comment—without adding noise?
- Are there opportunities to **simplify** the codebase by extracting common patterns or functions?

## Pass 2 — Detail and risk

- Inspect complex areas carefully: logic errors, edge cases, and **unintended effects** on callers or data.
- Watch for **inconsistency** at the small scale: similar snippets elsewhere should look similar or explain why not.
- Trace **data flow**: especially anything sensitive leaving the server or database when the client does not need it.
- When authorization matters, check that data and actions remain limited to **appropriate users**.
- Treat **schema and query changes** seriously: read affected queries and their call paths for correctness and leaks.

Duplication is acceptable; still call out **reasonable extraction** opportunities when they would reduce drift. Do not perform a full accessibility audit—only flag **obvious** basic gaps if the diff introduces user-facing controls.

Avoid merge-blocking language (for example “do not merge”). Stay factual and direct.

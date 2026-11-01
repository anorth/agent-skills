---
name: review-diff
description: >-
  Reviews a git diff through one or more reviewer subagents, then triages the findings and fixes clear problems.
  Use when the user asks for a code review, PR review, sanity check on changes,
  or reviews with specific or multiple models.
disable-model-invocation: false
---

# Review diff

Reviews always run in subagents: a fresh context, on a different model from the implementer (which is probably you).
You coordinate: scope, launch, triage, fix, report.

## 1. Scope

The default change set is the working tree against the current branch's `HEAD`:
`git diff HEAD` plus untracked files (`git status --short`), which the diff doesn't show.
If that's empty (for example, a clean tree on a feature branch),
ask the user for the range, such as the merge-base with `main`.
Don't launch reviewers on an empty change set.

Find the originating issue, task, or plan, if there is one, so reviewers can judge the change against it.

## 2. Choose reviewers

- User names models → one reviewer per model.
- User gives a count → that many reviewers.
- Otherwise → one reviewer.

Resolve models with the `/model-tiers` skill: named models as the user named them, the rest from the `strong` tier,
each distinct and different from the implementer.

## 3. Launch

Launch all reviewers in parallel, in one message, as `/model-tiers` describes, and wait for their results.
Brief each with:

```text
Read and follow <absolute path to this skill's directory>/reviewer.md.
Review: <diff command, e.g. git diff HEAD, plus any untracked files by path>
Originating work: <issue/task/plan pointer, or "none">
```

Point at `reviewer.md`; don't summarise it into the brief.

If a reviewer fails, retry once. If it fails again, continue with the other reviewers' findings and report the failure.
If every reviewer fails, report the blocker and stop.

## 4. Triage

Merge findings from all reviewers. Deduplicate overlapping items.
Note where reviewers disagree, especially on design questions.

Check each fix-now and fix-trivial finding against the code before acting on it.
Drop findings that don't hold, and say why in the report.
A finding you can't confirm either way is a design question.

| Category | Action |
|----------|--------|
| **fix-now** | Fix directly. |
| **fix-trivial** | Fix directly when the fix is local and uncontroversial. |
| **design-question** | Don't fix. Present to the user with enough context to decide. |
| **informational** | Mention briefly; no change unless the user asks. |

Treat a fix-now as a design question when:

- another reviewer calls it a design question,
- it has more than one reasonable remediation, or
- it changes user-visible behaviour.

Skip fixes that expand scope beyond the reviewed diff, unless the diff introduced the bug.

## 5. Fix

Apply fix-now and fix-trivial items. Match existing codebase style. Run the project's lint, if known.

Don't re-run the review unless the user asks.

## 6. Report

1. **Reviewers**: model per reviewer, with its finding counts.
   Note any fallback: another tier, or a reviewer on the implementer's model.
2. **Fixed**: what changed and why; group trivial fixes briefly.
3. **Dropped**: findings the check rejected, one line each with the reason.
4. **Design questions**: numbered, with the trade-off and each reviewer's view where they disagreed.
5. **Informational**: one line, if anything noteworthy remains.

If nothing needed fixing and there are no design questions, say so in one sentence.

---
name: sub-agent-review
description: >-
  Reviews local code changes via a subagent using the review-diff skill, then triages findings and fixes clear problems directly.
  Use when the user asks for a sub-agent review, a review with a specific model, or parallel reviews with multiple models.
disable-model-invocation: false
---

# Sub Agent Review

Review local changes through one or more subagents that follow the **review-diff** skill, then act on the feedback.

## When to use

- User invokes `/sub-agent-review` or asks for a sub-agent diff review
- User wants review **and** fixes (unlike review-bugbot / review-security, which report only)
- User requests parallel reviews with one or more named models

## Models

Default: **Kimi K3** → `kimi-k3-high`

Default effort/reasoning/thinking level: `high` or `medium`, depending on what's offered by the model.

If the user names model(s) and or reasoning levels, use those instead. Map common names to slugs.

If the user gives a slug directly, use it as-is. If a requested model is unavailable, say so and ask which available model to use.

### How many subagents, which models

Launch one subagent per model, **in parallel** (single message, multiple Task calls).

**Count** — how many reviews to run:
- No count given → **1**
- User names one or more models → count = number of models named
- User gives a count only (e.g. "3 reviews") → use that count

**Which models** — resolve in this order:
1. **User named specific model(s)** → use exactly those (map names via the table above). Ignore the priority list.
2. **Count only, no models named** → take the first *N* from the priority list below.
3. **Neither count nor models** → priority list item 1 only (Terra).

**Priority list** (for count-only requests; Luna, Opus, Fable, Composer are opt-in only):
1. `kimi-k3-high`
2. `gemini-3.7-flash`
3. `gpt-5.6-terra-medium`
4. `cursor-grok-4.6-high-fast`
5. `claude-sonnet-5-thinking-high`

If the user asks for more reviews than the priority list provides, use all four and say so.

## Step 1 — Launch review subagent(s)

For each model, launch one `generalPurpose` subagent:

- `run_in_background: false` unless the user asks for background
- `description`: `"Review diff (<model display name>)"`
- `model`: the slug for that model
- `subagent_type`: `"generalPurpose"`

Use this prompt shape almost exactly as-is:

```text
Read and follow the review-diff skill (abort if you can't find it).
Perform a review per that skill. Return numbered findings in decreasing importance.
Surface observations, trade-offs and opportunities for improvement, not just problems to fix.

For each finding, label its category immediately after the number:

Category: fix-now | fix-trivial | design-question | informational

Use:
- fix-now — clear bug, significant oversight, correctness/security issue, or violation of an established codebase pattern
- fix-trivial — small, uncontroversial improvement (naming, comment, minor consistency) with an obvious fix
- design-question — architectural or product tradeoff that needs a human decision
- informational — observation or open questions with no action needed

Include file:line when known. 

End with a short summary of the review. Describe what was checked and found clean. Finish with a one-liner: "N findings (X fix-now, Y fix-trivial, Z design-question)".
```

- Directly instruct the subagent to use the review-diff skill, rather than summarise that skill in the prompt.
- If the current work is described by an issue, task or plan document, reference it in the prompt.

Launch all subagents in one turn when using multiple models.

### Subagent failure

On failure, retry once. If still failing, report the blocker and stop.

If the sub-agent reports that it can't find the review-diff skill, retry with the review-diff skill instructions included in the prompt.

## Step 2 — Triage combined feedback

Merge findings from all subagents. Deduplicate overlapping items; note when models disagree (especially on design-question items).

| Category | Action |
|----------|--------|
| **fix-now** | Fix directly (asking for user guidance if needed) |
| **fix-trivial** | Fix directly when the fix is local and uncontroversial. |
| **design-question** | Do **not** fix. Collect and present to the user with enough context to decide. |
| **informational** | Mention briefly in the summary; no code change unless the user asks. |

When the same issue is both fix-now and design-question across models, treat it as a design-question.

If a fix-now has more than one reasonable remediation, present options to the user instead of choosing the simplest code change.

If a fix-now has UX impact, treat as a design question that needs user input, even if the bug is clear.

Skip fixes that would expand scope beyond the reviewed diff unless the bug is clearly introduced by that diff.

## Step 3 — Apply fixes

Implement fix-now and fix-trivial items. Match existing codebase style. Keep changes surgical.

Run the project's linting tool, if known.

Do **not** re-run review unless the user asks.

## Step 4 — Report to the user

Structure the final message:

1. **Review summary** — one line per model, or a merged count
2. **Fixed** — bullet list of what was changed and why (group trivial fixes briefly)
3. **Design questions** — numbered list with the tradeoff and, if models disagreed, each viewpoint
4. **Informational** — optional one-liner if anything noteworthy remains

If nothing needed fixing and there are no design questions, say so in one sentence.

## Examples

**Single default review:**
> /sub-agent-review

→ One subagent with `gpt-5.6-terra-medium`, fix and report.

**Specific model:**
> sub-agent review with Opus

→ One subagent with `claude-opus-4-8-thinking-high`.

**Parallel multi-model:**
> sub-agent review with Terra and Gemini

→ Two parallel subagents: `gpt-5.6-terra-medium` and `gemini-3.5-flash`. Merge, triage, fix, report.

**Count only:**
> run 3 sub-agent reviews

→ Three parallel subagents from the priority list: Terra, Gemini, Sonnet. Merge, triage, fix, report.

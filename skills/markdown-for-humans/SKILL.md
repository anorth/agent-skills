---
name: markdown-for-humans
description: >-
  Conventions for authoring markdown so humans can read it easily, in the source and in diffs.
  Use when writing or editing markdown files, such as READMEs, docs, designs, ADRs, and skills.
disable-model-invocation: false
---

# Markdown for humans

Markdown files are read by humans too, often as diffs.
Format them for human readability.

## Line breaks

Break lines at sentence boundaries, or at clause and phrase boundaries, to keep lines below ~120 chars (rough target).
An edit to a sentence then touches one line, and displays cleanly in a diff view.
This file is an example.

Don't wrap at a fixed column: one edit would the rest of the paragraph, and every reflowed line shows in the diff.
For the same reason, leave lines you aren't otherwise changing as they are.

This applies to files.
GitHub issues, PR descriptions, and comments render each line break, so write their paragraphs on one line.

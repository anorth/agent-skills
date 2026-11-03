---
name: design
description: >-
  How to think about and communicate a design proposal: the questions a design must answer, as a template,
  at two levels: a sketch to choose between shapes, and a detailed design to split into tickets.
  Use when proposing, writing up, or reviewing a design, or when another skill needs the proposal shape.
disable-model-invocation: false
metadata:
  credit: "Adapted from pstack architect's rationale template, github.com/cursor/plugins (MIT, (c) 2026 Lauren Tan)"
---

# Design

A design proposal answers the questions in [proposal.md](proposal.md).
Use them while designing, as the questions to ask, and when presenting, as the shape of the proposal.

## Levels

A proposal is written at one of two levels. Say which one you're asking for, or writing.

- **Sketch**: enough to compare against alternatives and choose a shape. Open questions are fine.
  Use it when exploring alternatives: detail spent on a design that loses is wasted.
- **Detailed**: enough to split into ready tickets without making new decisions,
  so each part could be built as written (see `/ready-ticket`).
  Every question is resolved or explicitly left to the builder.
  Use it for the design that's agreed and built.

A detailed design continues the chosen sketch; it doesn't start again.

## Scale

Scale the proposal to the design. A small design needs a few lines per section;
omit a section with nothing to say, except **Alternatives considered**.

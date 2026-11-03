---
name: lets-design
description: >-
  Design a change with the user, from a rough ask, a ticket, or a problem:
  ground it in the code, grill until it's understood, size it, and design it.
  Small asks get options and trade-offs in conversation; big ones get alternative designs explored in parallel.
  Use when the user says let's design, or asks to design a change together.
disable-model-invocation: false
---

# Let's Design

The agent does the design work. The user settles requirements and decisions, and approves the design.
Design is the primary activity: there is no separate plan.

## 1. Ground

Identify the ask. The user may give a ticket id, URL, file path, or pasted text, or just describe it.
If it's unclear which ticket, ask.

- Read the ask in full, and skim other open tickets; read the related ones. Don't expand scope from them.
- Read the project's glossary and the ADRs in the area, if it has them.
- Read the code the change touches, to know what the system does today.

Where the ask and the code disagree, trust the code for what is true today. Raise significant mismatches.
Restate what's being asked, and why, in a few lines, so a misunderstanding shows up early.

## 2. Grill

Use the `/grilling` skill until the problem and requirements are sharp enough to design against.

## 3. Size

Say whether this is a small or a big design, and why. The user may overrule.

- **Small**: fits one implementation ticket, and a few decisions settle its shape.
- **Big**: needs several implementation tickets, or its shape isn't obvious.

## 4. Design

### Small

Point out the key design decisions a solution has to make.
For each that matters, give a small set of options with trade-offs and what you would pick, then wait for the user.

### Big

1. Explore alternatives as sketches with `/design-it-twice`.
   Use `/arena` instead when the user asks for it, or would rather have one combined design than choose;
   its task asks for a sketch-level proposal in the `/design` skill's shape, with the path to its template,
   and its synthesis note fills the proposal's **Synthesis decision**.
2. Compare and recommend; the user chooses a sketch, or a hybrid.
   After `/arena`, the user reviews its combined sketch instead.
3. Develop the chosen sketch into a detailed design with the user,
   working its decisions through as for a small design.

### Either size

Settle, with the user, everything a detailed proposal in the `/design` skill's shape needs,
including its done checks.

## Done

Present the settled design as a detailed proposal in the `/design` skill's shape.
The design is done when the user approves it. The user says where it goes next.

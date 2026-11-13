# Design proposal

How a design proposal is communicated: prose plus types/schema when the design has them.
Sentence-case headings, no boilerplate. Replace the italic notes with actual content.

A **sketch** fills only some sections; a **detailed** design fills them all:

| Section | Sketch | Detailed |
| --- | --- | --- |
| Problem, Key ideas, Usage | yes | yes |
| Shape | outline | full |
| Design detail | | yes |
| Done checks | | yes |
| Synthesis decision | if synthesized | if synthesized |
| Tradeoffs accepted, Alternatives considered | yes | yes |
| Open questions and risks | yes | only those left to the builder |

## Problem

*One paragraph. What we're trying to do, and what about the existing system or constraints makes the shape non-obvious.
If grounding surfaced constraints the design must honor
(existing types to interop with, callers we can't break, invariants that crossed our boundary),
name them here so the reader sees the same constraints you saw.*

## Key ideas

*Highlight the few key ideas that form the core of this design intent.
Name the load-bearing decisions, each with why.*

## Usage (caller's view)

*Write this first, before the shape.
The caller is whoever uses the design: code calling a module, a client of an API, another service, or a person.
Show the README or quickstart the consumer reads, plus two or three realistic call sites in their own code,
or the flow a person goes through.
What they import, what they call, what comes back. The types/schema in [Shape](#shape) is derived from this.
The two must agree. When they diverge, reconcile the sketch to the usage, not the reverse.
The caller's experience is the spec. The types serve it.*

## Shape

*The recommended architecture. Schema and data structures first. Then how data flows through the signatures.
State which invariants are encoded in types, where validation lives, and what the system deliberately does not do.
Describe coupling and dependencies explicitly.
Judge interface depth explicitly. State what complexity the public surface hides, what remains exposed to callers,
and why the interface is no larger than needed.*

## Design detail

*Deeper technical design detail: design patterns, query patterns, indices, caching, etc.
Include all important decisions an implementer must follow to realise the design intent.*

## Done checks

*How we'll know it's done (in brief): a done check, with its evidence, for each behaviour that matters,
as the `/ready-ticket` skill describes them.
Significant UI changes need human review: say so.*

## Synthesis decision

*Only when the design was synthesized from several candidates, as by `/arena`.
Records which candidate became the base and why, what was adapted from each of the others,
and what was rejected and why.*

## Tradeoffs accepted

*One bullet per tradeoff the chosen shape makes. Form: "we accept X in exchange for Y."
Name anything a future reader might mistake for an oversight,
including things that look like premature optimization or premature simplification.*

## Alternatives considered

*Required. Name at least one concrete alternative shape, with one line on why it lost.
Judge each alternative on interface depth, not implementation simplicity alone.
Name the complexity it exposes to callers and the complexity it hides.
Two or three alternatives belong here when the design space had real contenders.
One is fine when the constraints forced the answer,
with the conclusion phrased as "this was the only viable shape because..."
Avoid listing flavors of the same shape.
This section covers design alternatives the chosen shape considered and rejected, not other runner candidates.*

## Open questions and risks

*Things you noticed during design that the human needs to weigh in on,
and risks worth flagging before implementation starts.
Phrase as questions, not assertions, so the human's answer is the resolution rather than a comment.*

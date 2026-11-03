# Big picture

Is this the right change, in the right shape, in the right place?

Read broadly: the files touched significantly in full, the modules they plug into,
and peer files that serve as reference for patterns and conventions.
If the brief points at an originating ticket, task, or plan, read it.

- Does the change do what the originating work asked? Note what it misses, and what it adds that wasn't asked for.
- Is the approach appropriate for the problem being solved?
- Does it fit the surrounding codebase in structure, conventions, and patterns?
- Are concerns decoupled sensibly? Where the change meets existing modules, are boundaries clean?
- For patterns that already exist (database access, routes, HTTP APIs, repetitive UI):
  is this use **consistent** with other uses,
  or is divergence justified and obvious?
- Are there chances to **clarify** intent—through structure, naming, or a brief comment—without adding noise?
- Are there opportunities to **simplify** the codebase by extracting common patterns or functions?
  Duplication is acceptable; still call out **reasonable extraction** opportunities when they would reduce drift.

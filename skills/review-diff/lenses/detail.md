# Detail and risk

Does the change work, line by line, and what could it break?

Read closely: the changed code in full, the functions it calls, its callers,
and similar snippets elsewhere that it should match.

- Inspect complex areas carefully: logic errors, edge cases, and **unintended effects** on callers or data.
- Watch for **inconsistency** at the small scale: similar snippets elsewhere should look similar or explain why not.
- Trace **data flow**: especially anything sensitive leaving the server or database when the client does not need it.
- When authorization matters, check that data and actions remain limited to **appropriate users**.
- Treat **schema and query changes** seriously: read affected queries and their call paths for correctness and leaks.

Do not perform a full accessibility audit.
Only flag **obvious** basic gaps if the diff introduces user-facing controls.

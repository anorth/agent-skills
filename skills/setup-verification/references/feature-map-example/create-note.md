# Create a note

Create note lets a signed-in user save a titled note, cancel an unfinished draft,
and find the saved note again from the note list.

## Sub-features

- `create-open` opens a blank editor from each entry point.
- `create-save` persists a title and body.
- `create-cancel` discards an unfinished draft.

## How to get to it (user POV)

- Choose the `New note` button in the toolbar.
- Press `n` while focus is outside an editable field.

## Driving it with Playwright

Journey: `journeys/create-note.ts`.

Preconditions:

- `app doctor` passes, and the session is the test user's.
- No note is titled `Release checklist`.

- **Open from toolbar.** Choose `New note`: `getByRole('button', { name: 'New note' })`.
  A form named `Note editor` appears, with focus in the `Title` textbox.
- **Open from keyboard.** Return to `All notes`, focus the page, and press `n`.
  The same form appears, and no `n` is typed anywhere.
- **Save note.** Fill `Title` with `Release checklist` and `Body` with `Tag and publish`, then choose `Save note`.
  A status named `Note saved` appears, the heading reads `Release checklist`, and one POST to `/api/notes` returns 201.
- **Confirm persistence.** Choose the `All notes` link, then the `Release checklist` link.
  The editor shows both saved values.
  `app sql "select title, body from notes where title = 'Release checklist'"` prints one row.
- **Cancel draft.** Open a new note, fill `Title` with `Discard me`, and choose `Cancel`.
  The note list returns, with no `Discard me` link.
- **Proof.** The journey writes `create-note/saved.png`, `create-note/saved.aria.txt`,
  and `create-note/requests.jsonl` to the evidence directory.

## Gotchas

- Pressing `n` while a textbox has focus types the character instead of opening an editor.
- Titles are trimmed on save. Assert the rendered title, not the draft input value.
- A save status alone is insufficient proof. Reopen the note from the list.
- The journey deletes `Release checklist` at the end, but keeps its proof artifacts.

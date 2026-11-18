// Example journey for the Notes feature map: journeys/create-note.ts.
// Run: .agents/skills/verify-notes/app journey create-note <evidence dir>
// The helpers (generated per repo) read the run-state file written by `app launch`
// for the URL and the saved sign-in state.
// Abridged: the keyboard-entry and cancel steps follow the same pattern.
import { expect } from "@playwright/test";
import { openSignedIn, capture, recordRequests, sql, step } from "./helpers";

const evidence = process.argv[2];
if (!evidence) throw new Error("usage: create-note.ts <evidence dir>");

const { page, close } = await openSignedIn("/notes", { evidence, feature: "create-note" });
try {
  await step("create-open: toolbar", async () => {
    await page.getByRole("button", { name: "New note" }).click();
    await expect(page.getByRole("form", { name: "Note editor" })).toBeVisible();
    await expect(page.getByRole("textbox", { name: "Title" })).toBeFocused();
  });

  await step("create-save", async () => {
    await page.getByRole("textbox", { name: "Title" }).fill("Release checklist");
    await page.getByRole("textbox", { name: "Body" }).fill("Tag and publish");
    const requests = recordRequests(page, "/api/notes");
    await page.getByRole("button", { name: "Save note" }).click();
    await expect(page.getByRole("status", { name: "Note saved" })).toBeVisible();
    await requests.expectOne({ method: "POST", status: 201 });
  });

  await step("create-save: persistence", async () => {
    await page.getByRole("link", { name: "All notes" }).click();
    await page.getByRole("link", { name: "Release checklist" }).click();
    await expect(page.getByRole("textbox", { name: "Body" })).toHaveValue("Tag and publish");
    await capture(page, "saved");
    const rows = await sql("select title, body from notes where title = 'Release checklist'");
    if (rows.length !== 1) throw new Error(`expected one stored note, got ${rows.length}`);
  });
} finally {
  await sql("delete from notes where title = 'Release checklist'", { write: true });
  await close();
}

# Session Log — 2026-09-04 | claude | workspace

## Task
Owner decision, reached in the session discussion after the folder-per-repo
change: scope documents are maintained state — no Changes sections, no struck
findings kept, git is the history. Apply it to the rules, the specifications
and `docs/workspace.md` on `main`; `docs/rea.md` (which exists only on `rea`)
follows after the rebase, logged there.

## Completed
1. `docs/README.md` — scope document is two parts (Body, Open findings) with a
   `History:` line; "never delete history" → "maintain, don't accumulate";
   promoted/refuted findings are deleted, ids never reused, the deleting
   session fixes live references, pruning is a closeout duty; ingest
   provenance = derivative header + session log; rename, split and
   cross-scope-ship procedures lose their Changes-entry step (the last one
   becomes a Body › Integration points update).
2. `AGENTS.md` — closeout step 5 gains the pruning duty.
3. `docs/BLUEPRINT.md` — §4 loses the `archive.md` row; §5 records the two
   rejections (the in-document ledger; struck-and-kept findings / archive).
4. `docs/workspace/scope-grammar.md` §14 and `document-layer.md` §15 — dated
   amendments listing exactly which sentences they supersede.
5. `docs/workspace.md` — Changes section removed (10 entries, 83 lines);
   `History:` line under the title; findings 14–17 and 22 rewritten to what is
   still open (the resolved parts simply gone).
6. `CHANGELOG.md` entry.

## Decisions & pitfalls        ← the valuable part
- **Why no `archive.md`.** I proposed it first; the owner refused it as "never
  delete" wearing a different hat — a second tray nobody reads, growing
  forever. They are right: the only thing an archive gives over git is
  in-place readability of dead text, which is the cost we are removing. Ids
  never reused + `git log -S 'F<n> —'` covers reference recovery.
- **Two edit mechanisms, deliberately different.** The specifications amend
  themselves by *appending* a dated section that names what it supersedes
  (their own header rule — the body text stays as written). The rulebook and
  the rationale (`docs/README.md`, `AGENTS.md`, `BLUEPRINT.md`) are edited *in
  place*, as the 2026-09-03 sessions did. Do not "amend" the README by
  appending, and do not rewrite a specification's body.
- **First application of the pruning duty, on the document I was editing.**
  Findings 14–17 were `~~struck~~` or "→ partly resolved" with the resolved
  half still in the text; 22 opened with the very contradiction this change
  resolves. Each was rewritten to its residual only — no "(resolved on …)"
  parentheticals either: the positive facts now live in the rules, so nothing
  re-files them, and the history is one `git log -p` away. Finding 8 is
  untouched (still unruled).
- **Predicted rebase shape for `rea`.** Four of its replayed commits append a
  Changes entry into the region `main` now deletes (`abb79dc`, `43ab4bf`,
  `6189814`, `debc084`) and one (`abb79dc`) also adds a note to finding 8;
  `debc084` appends finding 23 at EOF and `7f8c4d2` a note under it. At each
  stop the Changes hunk resolves as "take HEAD" (the section is gone); the
  EOF additions apply. CHANGELOG conflicts once, at the top anchor, main-first.
  Verify at the end: no `## Changes` in `docs/workspace.md`, finding 23 and its
  note present, `~~` absent.
- `README.md`'s file table needed nothing: its `docs/<scope>.md` row already
  says "Open-findings intake + examined body".

## TODO / known-incomplete
- On `rea` after the rebase: remove `docs/rea.md` › Changes, add its
  `History:` line, and make the first pruning pass over F1–F15 only where a
  finding is plainly resolved (none are struck today; F5/F8 are "doc fix
  only" candidates — decide there, not here).
- Owner-flagged, to handle afterwards, not forgotten: (1) finding 23 — the
  English-only OCR (`workspace.sh:153`); (2) the issue the screenshot
  inspection surfaced — F14 (proto's eight-mode 主設定 vs the ui's flat
  seven-field form; which schema produced the ui rendering) and F15 (the
  `每_週限制次數` underscore).
- Push `main` and `rea` (no SSH identity here).
- Carried over: Open finding 8, `origin/nabu-dashboard`.

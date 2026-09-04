# Session Log — 2026-09-04 | claude | workspace

## Task
Owner, completing the orphan rule: not only unused originals but their
derivatives under `docs/<scope>/sources/` must be removed once a task's
closeout no longer needs them. Infrastructure → `main`, then rebase `rea`
and apply it there (logged on `rea`).

## Completed
1. Definition: a derivative is needed only while a document under `docs/`
   outside `sources/` cites it by its full file name; session logs do not
   count; abbreviated `…-001.png.md` forms do not count. Unneeded pairs are
   removed at closeout (`git rm` derivative, `rm` original) by agents and
   humans alike. `AGENTS.md` write surface and evidence sentence;
   `docs/README.md` writing rule and tree; `README.md` tree and table;
   `document-layer.md` §15 amendment; CHANGELOG.
2. `workspace.sh check` — per-derivative notice with both commands and a
   count, beside the orphan-original notice. Sandbox: five derivatives, two
   cited (one by bare file name, one by full path) → three listed; a
   citation placed in a session log did not count.

## Decisions & pitfalls        ← the valuable part
- **"Needed" = cited from docs/ by file name, mechanically.** Anything
  softer ("might be useful later") cannot be checked and would keep
  everything forever — the failure mode the owner is removing. A document
  worth keeping for reference costs one citation line in its scope document.
- **Basename match, not path match.** Citations name
  `docs/<scope>/sources/[<repo>/]<name>.md@<blob>`; matching the basename
  keeps the check correct across the optional repo folder and across a
  rename of the scope, and it makes my own `…-001.png.md` abbreviation from
  earlier today a non-reference — which is right: an abbreviation is not
  something a reader can grep for.
- **Session logs excluded on purpose.** They cite blobs as journey; counting
  them would resurrect every removed document through its own log entry.
- **Git remains the archive.** `git show <blob>` resolves a removed
  derivative's text; the evidence sentence in AGENTS.md now says so, so a
  future reader of an old log's citation knows the text is one command away.
- **The two notices are siblings, both warn-only.** A missing derivative
  and an unused derivative are the two directions of the same pair; neither
  may block a closeout (§1 of the document layer).

## TODO / known-incomplete
- On `rea`: remove the 13 code-303 pairs and the leftover blob map in
  `docs/rea.md`; verify `check` lists nothing. Logged there.
- Carried over: Open finding 8, `origin/nabu-dashboard`, SSH for github.com.

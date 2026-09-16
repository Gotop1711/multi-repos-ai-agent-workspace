# Session Log — 2026-09-16 | claude | workspace

## Task
Owner decision, carried from an organization's branch as two `[workspace]`
proposals: (1) a human-written `Verified:` lifecycle line with a new
terminal `Status: verified`; (2) the document layer's removal made visible
and one command, `prune`, with a plan's verification as its moment. Adopt on
`main`.

## Completed
1. `workspace.sh` — `keepers()`, `unref_derivatives()`, `orphan_originals()`
   (one scan for `check` and `prune`); `check` › plans: `Verified` in the
   stray-line pattern, at most one, requires `Shipped:` and the
   `<name> — <date>` prefix, `want=verified`, and an `info:` line naming
   the shipped plans still awaiting the owner's line; `prune [--apply]`
   (report: kept-by document › nearest heading / removable; apply: `git rm`
   or `rm` for a never-committed derivative, `rm` originals and orphans);
   usage header and `help` range.
2. Rule text — `docs/README.md` › The signature gate (the line, the
   `Status:` derivation, the `check` conditions, a "Verification closes what
   the signature opened" paragraph) and › Writing rules (`prune`);
   `AGENTS.md` › Every session › 5 and › Red lines › write surface;
   `README.md` (tree, table); amendments dated today in
   `docs/workspace/scope-grammar.md` and `document-layer.md`.
3. `docs/workspace.md` — F34 deleted (adopted). `CHANGELOG.md` entry with
   the organization-branch migration.
4. Sandbox (a clone in the session scratchpad on a non-`main` branch, bash
   3.2): seven plan headers — verified ok; `Status: shipped` with a
   `Verified:` FAILs (expected verified); `Verified:` without `Shipped:`
   FAILs; the pre-rule form without a name FAILs; two lines FAIL;
   verified-then-superseded ok; a `Verified:` below the first `##` FAILs as
   stray and the plan is still listed as awaiting. `prune` report names the
   keeper's heading (`docs/<scope>.md › ### Architecture`, `› ### 1. …`);
   `prune --apply` over a tracked uncited derivative (`D` staged, original
   gone), a never-committed one (`rm`), an orphan — and `check` is quiet
   afterwards.

## Decisions & pitfalls        ← the valuable part
- **The human writes `Verified:`; the agent never does.** The owner chose
  this over the agent recording the confirmation as `Amended:` (the form two
  plans on an organization's branch had used): the reviewer's own hand is
  the point. `check` enforces the `<name> — <date>` prefix so the pre-rule
  form (`Verified: <date> — …`, no name) cannot pass as a verification —
  that is the migration.
- **`verified` is terminal; `shipped` is no longer.** Terminal-for-citations
  is a different property from terminal-for-status: a shipped plan's
  citations already stopped keeping documents alive (2026-09-04), and that
  stays keyed on `Shipped:` — the text now says both things separately.
- **Removal is still keyed on citation, not on approval.** The owner's
  complaint was visibility and timing, not the rule; `prune` shows the
  keepers, and the verification closeout is the named moment because
  settling the plan's findings is what releases its documents.
- **`prune --apply` had to tolerate an untracked derivative.** First
  sandbox run: `git rm` on a derivative ingested and never committed dies
  with "pathspec did not match", after which the original had already been
  removed. Now `git ls-files --error-unmatch` decides between `git rm` and
  `rm`.
- **Keeper heading via awk, not grep -n.** A line number is useless to the
  owner; the nearest `^#+ ` above the citation names the finding or Body
  section that holds the file. Lines inside fenced code that start with `#`
  could mislead — accepted; it is a report.
- The name check's warnings in the sandbox (`MY_API` in three boilerplate
  files) are the placeholder colliding with the planted id — pre-existing
  and not an organization's name.

## TODO / known-incomplete
- Organization branches: `git rebase main`, then rewrite any pre-rule
  `Verified:` line in the adopted form (owner's hand) and set
  `Status: verified`; `check` lists the shipped plans awaiting the line.
- `docs/workspace.md` Body › Current architecture still says "examined at
  workspace@8e4db92" (eleven tracked files) — long stale; a re-examination
  session is due.
- The `help` output's `sed -n '2,12p'` range is hand-maintained with the
  usage header — a future subcommand must bump it.

# Session Log — 2026-09-08 | claude | workspace

## Task
Owner: change the plan-lifecycle rule — a plan must not collect repeated
`Signed:` lines; small changes are confirmed in the session discussion,
large ones become a new signed plan, and every lifecycle marker (human or
agent) lives in the file header. Lead scope `workspace`; on `main` per the
owner's branch rule (infrastructure → `main`).

## Completed
1. `docs/README.md` › The signature gate rewritten: one signature per plan
   for a `Writes:` set; header block with the full line list; `Status:`
   word and its derivation; amendments confirmed in session (`Amended:` +
   `### A<n>`); the new-plan criterion (a repository or branch outside
   `Writes:`, another lead scope, another deliverable than the H1 names)
   with `Supersedes:` / `Superseded:`.
2. `docs/workspace/scope-grammar.md` §14 amendment (what it supersedes in
   §3, §6, §7, §8, and why); `docs/BLUEPRINT.md` item 6 one clause.
3. `workspace.sh check`: plan-header validation (Scope, Status, no
   lifecycle line below the first `##`, ≤ 1 `Signed:`, `Status:`
   consistent, `Writes:` present and manifest ids on a signed plan);
   `Superseded:` joins the history regex of the derivative scan.
4. `CHANGELOG.md` entry; this log.

## Decisions & pitfalls        ← the valuable part
- **The criterion had to be mechanical or the gate erodes.** The owner's
  "small vs large" is decided by what the signature covered: the new
  `Writes:` line (repositories and branches) plus the lead scope and the
  H1's deliverable. Anything inside → session confirmation; anything
  outside → new plan. Without that line, "small" would be argued case by
  case in every session.
- **`Status:` is derived, not free text.** The old block-quote status notes
  went stale twice this week (two plans said "unsigned — discussion" after
  being signed and executed). One word, checked against the lines by
  `check`, cannot drift silently.
- **`paused` is a `Status:` value, not a new lifecycle line.** The owner
  paused two plans today; the reason belongs in the `Amended:` line that
  records the pause, and another `Amended:` lifts it. Kept the line
  vocabulary small.
- **`Superseded:` as a terminal state** instead of §8's "Abandoned … renamed
  to": abandoned means dropped; superseded means continued elsewhere.
  `check` treats both as history for derivatives.
- **`Writes:` uses `<repo> (<branch>)`**, not `<repo>@<branch>`, so it can
  never be mistaken for a `<repo>@<sha>` citation.
- **Not changed:** `AGENTS.md`'s red line still reads "a signed plan" —
  true as before; the format lives in `docs/README.md`. `docs/workspace.md`
  got no finding: the owner adopted the rule directly (README: a workspace
  proposal starts in findings only until adopted).
- `check` on `main` sees no plans (they live on the project branch), so the
  new validation is exercised in the organization branch's closeout that
  migrates the three plans; a failure there is the migration's to fix, not
  a reason to soften the check.

## TODO / known-incomplete
- Owner: push `main` (`origin` = Gotop1711/multi-repos-ai-agent-workspace;
  the agent shell cannot push there — memory note).
- The organization's branch: rebase onto `main` (owner workflow), migrate the three
  plans to the header form (`Writes:`, `Status:`, `Amended:` lines for the
  existing amendments; block-quote status notes removed), decide A7 under
  the new rule (in-session confirmation, no second signature) and the two
  paused plans' `Status: paused`; force-push with lease is the owner's.

## Update — same session: CHANGELOG is the workspace's record only
- Owner, on seeing the branch's stray 2026-09-07 entry: `CHANGELOG.md`
  records this workspace's rules and infrastructure, never `projects/*`
  adjustments or `docs/plans/*` changes. Made explicit in the CHANGELOG
  header, `AGENTS.md` › Close out, `README.md`'s table and `BLUEPRINT.md`'s
  tree; a CHANGELOG entry records the clarification itself (it is a rule).
- Why it was ambiguous: "workspace-level changes" named the inclusion, not
  the exclusion; a manifest access change for a plan reads as
  "workspace" (the file is infrastructure) although its content is
  project state. Rule now keys on what the change is *about*.
- The misfiled entry is removed on the project branch at its next rebase
  (its facts are in both plans' headers and the 09-07 log); after that the
  branch's `CHANGELOG.md` equals `main`'s again.

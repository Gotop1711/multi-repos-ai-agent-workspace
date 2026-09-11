# Session Log — 2026-09-11 | claude | workspace

## Task
Owner: which files besides `CHANGELOG.md` may change only for the
workspace's rules and infrastructure (proposed: the sessions folder,
`docs/workspace.md`, `docs/BLUEPRINT.md`, `docs/workspace/*`; unsure:
`docs/README.md`, given `README.md`) — then restrict all such changes to
`main`, with no organization named in them.

## Completed
1. `AGENTS.md` › Boilerplate and organizations (new section): two parties
   — organization content as a closed list (`catalog/*.yaml`,
   `docs/<scope>.md` + `docs/<scope>/` for its scopes, `docs/plans/`, logs
   not scoped `workspace`), boilerplate = everything else, changed on `main`
   only and never naming an organization; `[workspace]` TODO proposals as
   the channel from an organization's branch; close-out and write-surface
   lines qualified.
2. `workspace.sh check` — party check (on `main`: FAIL on organization
   content; elsewhere: FAIL on each boilerplate path changed since the merge
   base with `main`, warn when behind `main`, warn where `main` names one of
   the branch's own ids; `git config workspace.boilerplate` for forks;
   detached HEAD skips). Orphan scan skips scopes absent on the branch.
3. Rule text: `docs/README.md`, `TEMPLATE.md`, `README.md` (new section,
   table, Growing it), `BLUEPRINT.md` (§2, §3 rationale, §4 row + adoption
   rule, two §5 rows, §6 item 9); amendments in `scope-grammar.md` §14 and
   `document-layer.md` §15; `docs/workspace.md` id note (next id 34);
   CHANGELOG entry with the one-time migration.
4. Organization names removed from `CHANGELOG.md`, both specifications,
   `workspace.sh` comments and eight `-workspace--` logs — names replaced by
   generic wording, facts kept.
5. Sandbox (a clone in the session scratchpad, bash 3.2): `main` PASS; a
   planted manifest entry, scope document, plan and log FAIL on `main`; the
   existing organization branch rebased onto the new `main` FAILs on exactly
   the six files it had written into the boilerplate, and PASSes after the
   migration; a new file under `docs/workspace/` on it FAILs; a name planted
   on `main` warns there; fork mode FAILs without the config key (the
   message names it) and PASSes with it; a `workspace` original is still an
   orphan while another branch's is left alone.

## Decisions & pitfalls        ← the valuable part
- **Defined by exclusion, not by listing the boilerplate.** The owner asked
  for "more files" to join the CHANGELOG's range; any list of boilerplate
  files goes stale with the first file added later. The organization's side
  is small and stable, so it is the list, and every other path is
  boilerplate without anyone remembering to add it.
- **The sessions folder is split, not one party.** Every organization must
  write logs (a session may not end without one), so only `TEMPLATE.md` and
  the `-workspace--` logs are boilerplate; the scope token decides. An
  organization's own infrastructure (fleet, sync, migration) takes one of its
  scope ids — the gap that made branches write `-workspace--` logs and
  CHANGELOG entries in the first place.
- **`docs/README.md` joins; it is not a duplicate of `README.md`.** A party
  says who may change a file, not what it is for: `README.md` is the
  human's front door (setup, daily loop, file table), `docs/README.md` the
  agent's docs-system rulebook. It needed an explicit mention because it sits
  inside the otherwise agent-writable `docs/`.
- **Branch name, not a tracked marker, decides "am I on `main`".** A tracked
  instance file was the heavier alternative explored earlier; the branch
  model in use needs none, and a fork sets one config key that the FAIL
  message prints. Detached HEAD (a rebase) skips, since the hook does not
  run there anyway.
- **Findings stay on `main`; organizations send proposals.** A findings tray
  written from two sides collides at its end on every sync and hands out the
  same ids twice (it happened); a TODO proposal has no id and no names. Cost:
  it rests on the owner carrying it over — no mechanism detects a forgotten
  one.
- **Name check keys on the branch's own ids, so `main` needs no list of
  organizations** — which would itself name them. Ids under three characters
  are skipped; it warns rather than fails because a scope id can be an
  ordinary word.
- **Pitfall found in the sandbox:** the organization branch's rebase onto
  the new `main` stops on `docs/workspace.md`, which that branch had edited
  on the same preamble line. `-X ours` is right for this one sync only —
  recorded in the CHANGELOG's migration bullet with the warning.
- **Redaction touched journey text.** Logs and CHANGELOG are append-only by
  rule; the owner's "without mentioning" was taken as the instruction to
  redact names only, recorded in the entry. Git history still holds the old
  wording — `main` is pushed, so a purge would mean rewriting history, which
  was not done.

## TODO / known-incomplete
- Owner: sync the organization branch (`git rebase -X ours main`, this once),
  then run the migration `check` lists — two boilerplate files restored after
  their workspace findings become `[workspace]` proposals, four
  `-workspace--` logs renamed. A session on that branch can do it, logged
  under its scope.
- Owner: push `main` if the closeout push fails here (no SSH identity for
  github.com in the agent shell, as before).
- Not done: a purge of organization names from git history (owner's
  decision; it would rewrite `main` and every branch built on it).
- Carried over: Open finding 8 (write surface vs growth path) is untouched;
  the new rule narrows it on organization branches but does not settle it.

## Addendum — the migration's two proposals, carried to `main` (owner authorised all branches)
- The owner then authorised the agent to modify every branch and to carry
  out the migration itself. Before syncing the organization's branch, its
  two workspace findings (a `Verified:` plan-header line outside the
  vocabulary; a pre-rule plan whose writes grew after signing) were
  re-observed on `main` — both rule sides are visible here — and filed as
  Open findings 34 and 35, worded without the organization's names. The
  branch's corroboration note on finding 8 (manifest entries written under
  human instruction while the write surface omits `catalog/`) is not filed
  separately: finding 8 already asks that question.
- Done on `main` first, so the branch's rebase brings 34 and 35 in and its
  migration restores `docs/workspace.md` to a version that already has them.
- The second organization's workspace (a separate clone) had three
  workspace findings stranded in its history since its 2026-09-07 sync. One
  is still open on `main` — `textutil` loses headings and table rows while
  §3 prescribes a `§<heading>` locator — re-measured here and filed as
  finding 36. The other two are settled: the slug rule dropping non-Latin
  titles is covered by `document-layer.md`'s 2026-09-03 amendment (`ingest`
  refuses such titles without `NAME=`), and "a rebase rewrites a branch's
  `workspace@<sha>` citations" ends with this change (workspace findings
  cite `main` only).
- Residual, not changed: `document-layer.md` §15 (2026-09-03 amendment)
  cites "`docs/workspace.md` finding 25", and two CHANGELOG entries cite
  "finding 23" — ids `main` never held (they were an organization branch's).
  Left as history; a reader resolves them through the branch logs.

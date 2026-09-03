# Session Log — 2026-09-03 | claude | workspace

## Task
The owner's second-round instructions in the document-intake session: (1) a
store only humans may write made autonomous agent work impossible — change
it; (2) the two workspace plans do not belong under `docs/plans/` — keep that
content as workspace specifications. Both are workspace infrastructure, so
this work is committed to `main` under the owner's branch rule stated this
session (infrastructure → `main`; Book AI project work → `nabu-dashboard`).
The project side — ingesting the dashboard report under scope `nabu` — follows
on `nabu-dashboard` and is logged in that branch's intake log.

## Completed
1. `workspace.sh` — new `ingest <scope> <file>…`: copies a document from
   anywhere into `originals/<scope>/YYYY-MM-DD-<slug>.<ext>`, mounts
   `originals -> $WORKSPACE_STORE` (default `~/Documents/workspace-originals`)
   when absent, then runs `extract`. `mount_store` is shared with `extract`
   (which now remounts a missing symlink when the store exists). Derivatives
   gain `received: <as-received name>`. `setup` prints the ingest hint; help
   lines updated.
2. Verified by a 15-case run of the real script in the disposable sandbox
   `.agents/scratch/ingest-test/`: a CJK title is refused without `NAME=` and
   accepted with it; identical re-ingest is reused; different bytes under an
   existing name are refused; leading and trailing dates in ASCII titles
   become the document date; `DATE=` overrides; a credential-bearing file is
   refused by `extract` and removed from the store again; files inside
   `projects/` or already in the store are skipped; `NAME=` with two files
   fails; a malformed `NAME=` is skipped; `extract` on a human-placed file is
   unchanged; `check` passes with five derivatives.
3. `AGENTS.md` — the store joins the write surface through `ingest` only;
   existing originals stay untouchable; the credential sentence names the
   rollback.
4. `docs/README.md`, `README.md`, `docs/BLUEPRINT.md` — `ingest` documented;
   `docs/workspace/<topic>.md` named as the home of workspace specifications;
   `docs/plans/` reserved for child-repo work.
5. `docs/plans/workspace--document-layer.md` → `docs/workspace/document-layer.md`
   and `docs/plans/workspace--docs-scope-grammar.md` →
   `docs/workspace/scope-grammar.md` by `git mv`: H1 in the topic form, a
   status note prepended, an Amendments section appended to each recording
   today's changes. `docs/workspace.md` gained Body › Specifications pointers
   and a Changes entry; `CHANGELOG.md` gained the entry.

## Decisions & pitfalls        ← the valuable part
- **The owner's in-session instruction outranks the checked-in rules.** Said
  in so many words this session: "Any request I demand in the session
  discussion here should surpass the importance of this workspace's
  specifications." That dissolved the stall of the previous closeout, which
  had refused to place a document because the store was human-only. The rule
  is changed permanently rather than excepted once, so no later session
  re-litigates it — and the earlier answers the owner gave through the
  question tool (scope `nabu`, the report plus its three sources, authorise the
  store write) were genuine; the doubt recorded in the intake log was mine.
- **Why `ingest` adds but never overwrites.** The reason the store was
  human-only — an agent must not alter bytes a citation's sha256 anchors — is
  kept mechanically: different bytes under an existing name are refused and a
  new version is a new dated name. Only the *adding* was ever needed for
  autonomy.
- **Why non-ASCII titles must be named by hand.** The §4 slug recipe deletes
  CJK silently (`docs/workspace.md` finding 25); an auto-name that looks
  plausible but has lost its subject is worse than a refusal. `ingest`
  refuses and prints the exact `NAME=` invocation to run.
- **Why the plans moved rather than being rewritten into BLUEPRINT/README.**
  Their durable content — routing table, naming, extraction details,
  tradeoffs, the owner's settled answers — is detailed design far larger than
  the rationale document, and `docs/<scope>/<topic>.md` is the sanctioned home
  for an examined topic of a scope; `workspace` is a scope. A verbatim move
  with a prepended note and appended amendments keeps their history readable,
  and the old plan ids still resolve to the files.
- **`docs/plans/` is now empty, hence untracked** — git drops empty
  directories; it reappears with the first child-repo plan. Until then the
  gate audit `grep -L '^Signed:' docs/plans/*.md` errors on the empty glob
  under zsh.
- **Pitfall (same trap as the previous session's log):** a `cd` into the
  sandbox persisted into the next Bash call, so `git mv` ran inside the
  sandbox and failed with "bad source", and a `mkdir -p docs/workspace` landed
  there too (removed). Use absolute paths or `git -C "$R"`. Nothing outside
  scratch was touched by the misfire.
- **Merge shape for the owner's branch model.** `nabu-dashboard` is ahead of
  `main` by the fleet-manifest, hook-wiring and intake commits, and both
  branches now add a `CHANGELOG.md` entry at the top and a `docs/workspace.md`
  Changes entry at the same position, so `git merge main` on `nabu-dashboard`
  conflicts in exactly those two hunks; both resolve by keeping both sides
  (fleet entry below today's in the CHANGELOG; Changes entries in session
  order).

## TODO / known-incomplete
- A transliterating slug for CJK titles (pinyin) was not attempted — no
  dependency-free tool on macOS; hand-naming via `NAME=` is the rule.
- `docs/workspace.md` findings 23 (store never mounted) and 25 (slug) live on
  `nabu-dashboard`, not `main`; their resolution notes are appended there
  after the merge.
- Consider a `check` line that reports an original in the store with no
  derivative (`ingest` always writes one, but a human-placed file does not).
  Not added: it has not bitten.

## Closeout push — not pushed
`git push origin main` fails from the agent environment with
`Permission denied (publickey)`: the ssh-agent holds no identity and
`~/.ssh/config` binds no key to `github.com` (the `bookai` key authenticates
as the `Jarvis-bookai` account, which is denied on this repository — see the
intake log on `nabu-dashboard`). The commit is local; the owner pushes
`main` from their own terminal.

## Addendum — no tombstone documents (owner instruction, same session)
The owner saw `docs/nabu-ui.md` as a struck-through tombstone beside
`docs/nabu.md` and does not want historical-marker documents. Rule changed on
`main`: an id change is a recorded rename (`git mv` + one Changes entry), ids
are "stable" not "immutable", plans move with their scope id — `docs/README.md`
› Scopes, BLUEPRINT tree line, `docs/workspace/scope-grammar.md` §14
amendment, CHANGELOG. The tombstone is deleted on `nabu-dashboard` after the
rebase. Lesson: the repo-id default for an unnamed scope is the root cause;
prefer `scope:` keys at fleet declaration. The owner's workflow is rebase — the
project branch is rebased onto `main` after every infrastructure commit.

## Addendum — originals copied into gitignored docs/assets/ (owner instruction)
The owner does not want the symlinked external store: originals are copied
into the repository directory. Asked (question tool) and answered: originals
gitignored, not tracked; central `docs/assets/<scope>/` for originals; text
derivatives under `docs/<scope>/sources/`. Mechanics: `ASSETS="docs/assets"`
replaces the store, `mount_store` is gone, `ingest` refuses to run unless
`docs/assets/` is ignored, `check` scans `docs/*/sources/` and fails on any
tracked file under `docs/assets/`, `restore` skips `*sources/*@*` tokens.
Rules: AGENTS.md, docs/README.md (tree, reserved `assets`, rename rule,
citation form), README.md, BLUEPRINT.md; §15 amendment in the document-layer
specification. The four nabu documents are migrated on `nabu-dashboard` after
the rebase: `git mv sources/nabu docs/nabu/sources`, re-ingest from the pile
so the headers gain the new `source:` path (blobs change; the 31 findings'
citations are updated to the new blobs; `received:` is preserved by
re-ingesting rather than re-extracting). The repo-root `originals` symlink was
removed; `~/Documents/workspace-originals/` is the owner's folder and was left
in place — it is now unused.

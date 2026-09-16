# Workspace rules

Governance workspace for cross-repository analysis and gated development.
Child repositories live under `projects/` (gitignored clones) and are
**read-only by default**; `catalog/repos.yaml` lists the fleet and each repo's
access level (`write` / `pr-only` / `read-only`).

All records and documentation here are produced by agents: session logs
written by the agent at every closeout (`check` only reports the newest one);
the docs system per `docs/README.md` (findings into a scope document's Open
findings; the examined body only past the examination bar). The one exception
is the document layer — `docs/<scope>/sources/`, text derivatives of
human-supplied documents, written only by `./workspace.sh ingest` (copies the
original to gitignored `docs/assets/<scope>/` under a dated name, then extracts
it) or `extract` (a file already there). Originals are never committed.

## Every session

1. Run `./workspace.sh check` — halt on failure.
2. Read the newest 3 date-prefixed logs in `.agents/memory/sessions/` — plus,
   when the task names a scope, its newest 3
   (`ls .agents/memory/sessions | grep -- '-<scope>--' | tail -3`) — your
   memory of previous sessions.
3. If the task names a scope (`ls docs/` lists the ids; a repo's scope is its
   `scope:` in `catalog/repos.yaml`, default the repo id), read
   `docs/<scope>.md` and, if `docs/<scope>/` exists, the topic files the task
   needs; for a feature also `docs/plans/<scope>--<feature>.md`; and list
   `docs/<scope>/sources/` — the human-supplied documents about it.
4. Work (rules below).
5. Close out — mandatory:
   - Write the session log
     `.agents/memory/sessions/YYYY-MM-DD-{agent}-{scope}--{task}.md`
     (copy `TEMPLATE.md`): the task, what was completed, **decisions &
     pitfalls** (failed attempts and WHY — the part that matters), TODO.
     Findings do NOT go here.
   - Record findings in the owning scope's `docs/<scope>.md` → **Open
     findings** (filing and `[<feature>]` tag rules in `docs/README.md`;
     evidence rules below; never coin a product or system id — propose it in
     the log's TODO); promote into the document body only past the
     examination bar (`docs/README.md`); prune what you found stale there —
     a promoted or refuted finding is deleted, a Body claim is rewritten in
     place; git is the document's history. A plan whose header newly carries
     the owner's `Verified:` line: settle its `[<feature>]`-tagged findings
     (promote or delete) and run `./workspace.sh prune --apply`
     (`docs/README.md` › The signature gate). Changes to the workspace's own
     rules or infrastructure go to `./CHANGELOG.md`, on `main` only (›
     Boilerplate and organizations) — never a child repository's state, an
     organization's own fleet or sync, a manifest change made for a plan,
     or a plan's progress (those live in the plan's header, the scope
     document and the log).
   - The closeout commit of THIS repo + push. That commit is the **one
     standing git authorization**; every other git action here — and any
     state-changing git action in a child repo (branch, commit, tag, push,
     PR) — waits for explicit human instruction. Read-only git in children
     and in this repo (`rev-parse`, `hash-object`, `show`, `log` for
     citations and re-examination) and the checkouts `./workspace.sh
     restore` performs (they move HEAD, never history) are part of the
     sanctioned loop.

## Boilerplate and organizations

This repository is a boilerplate: branch `main` carries it, and each
organization using it works on its own branch (or fork), synced from `main`
by the owner — `git rebase main`, then `./workspace.sh check` and the
migration it asks for; never by an agent. Every tracked path belongs to one
of two parties:

- **Organization content** — the closed list an organization's branch
  changes: `catalog/*.yaml` (on `main`, `repos.yaml` is the template, with
  no entries); `docs/<scope>.md` and `docs/<scope>/` for its own scopes;
  `docs/plans/`; session logs whose scope token is not `workspace`.
- **Boilerplate** — every other path: the workspace's rules and
  infrastructure, among them `AGENTS.md`, `README.md`, `CLAUDE.md`,
  `CHANGELOG.md`, `workspace.sh`, `.githooks/`, `.gitignore`,
  `docs/README.md`, `docs/BLUEPRINT.md`, `docs/workspace.md`,
  `docs/workspace/`, `.agents/memory/sessions/TEMPLATE.md` and the
  `-workspace--` logs. A path added later is boilerplate unless the change
  that adds it joins it to the list above. Boilerplate is changed on `main`
  only, is identical on every branch, and **never names an organization** —
  none of its repositories, scopes, plans, people or facts: examples use
  placeholders (`<scope>`, `my-service`), and a change that one
  organization's case prompted says what happened in generic terms.

On an organization's branch, a defect in the workspace or a change it needs
goes to the log's TODO as a `[workspace]` proposal — worded without the
organization's names, carrying what a `main` session needs to re-observe
it; the owner takes it to `main`, where it is filed in `docs/workspace.md`
(whose finding ids are allocated on `main` only) or adopted. The
organization's own infrastructure — declaring its fleet, a sync with
`main`, the migration after one — is organization content, logged under one
of its scope ids. `check` enforces the split: on `main` it fails on
organization content; on any other branch, on a boilerplate path changed
since the merge base with `main` (in a fork: `git config
workspace.boilerplate upstream/main`).

## Red lines

- ⛔ No branch, commit, tag, PR, or push in any child repo without a signed
  plan in `docs/plans/` (signature format in `docs/README.md`).
  Read-only repos' push URLs are disabled regardless.
- ⛔ The write surface is exactly: `.agents/memory/sessions/` (logs), `docs/`
  (per its rules; on an organization's branch not its boilerplate paths),
  `./CHANGELOG.md` (on `main`), `docs/<scope>/sources/[<repo>/]*.md` **only as
  `./workspace.sh ingest` or `extract` output** (never hand-edited) — and
  removed at closeout (`./workspace.sh prune --apply`: `git rm`, together
  with its original) once nothing live under `docs/` outside `sources/`
  cites it by file name; `check` lists such derivatives, `prune` what keeps
  the others, and git keeps their text — gitignored
  `docs/assets/<scope>/[<repo>/]` **only through `./workspace.sh ingest`** (it adds a
  dated original and never overwrites or renames one) — plus one removal
  anyone makes: an original that no derivative names any more (an **orphan**:
  its derivative was removed or re-filed; `check` lists them) is deleted at
  closeout (`prune --apply`), by agents and human maintainers alike, so `docs/assets/` holds
  only what `docs/*/sources/` uses — and gitignored
  `.agents/scratch/` for
  disposable working artifacts (safe to delete anytime; their conclusions go
  into findings or the log). Never write inside `projects/`; never overwrite, rename or
  edit an existing original; remove only orphans.
- ⛔ No secrets in any file, ever; report a credential's location, not its value.
- ⛔ Nothing binary and nothing over 1 MiB enters this repository — the
  pre-commit hook refuses it; document originals stay in gitignored
  `docs/assets/`. A document containing a credential is never ingested —
  `ingest` refuses it and removes its copy again; a human vaults the value and
  provides a redacted copy, ingested under a new name. Documents already
  inside `projects/` are never copied into `docs/`.
- ⛔ No production systems unless a task explicitly authorizes it (then
  read-only credentials only); no destructive commands; inspect source rather
  than executing it.
- ⛔ Start cross-repository sessions from this directory, never inside a child.
- ⛔ Never end a session without its session log.

## Evidence

Every finding cites: repository id + the commit it was observed at — written
`<repo>@<sha>`, read with `git -C projects/<repo> rev-parse --short HEAD` —
plus file + symbol; evidence type (direct / corroborated / inferred /
unverified); confidence (high / medium / low); unresolved questions. Never
assume same-named things in different repos are the same entity without
file-level evidence.

A finding drawn from a human-supplied document cites the derivative it read:
`docs/<scope>/sources/[<repo>/]<name>.<ext>.md@<blob>` — read with
`git hash-object <path> | cut -c1-12` (equal to
`git rev-parse --short=12 HEAD:<path>` after the closeout commit) — plus
`p.<N>`, `L<n>` or `§heading`, and optionally a ≤12-word verbatim quote.
Re-examine with `git show <blob>` — it resolves even after the derivative has
been removed; a changed `hash-object` means re-verify. A
document is direct evidence of what it says; a claim about code or the fleet
drawn from it is `inferred` until re-verified in `projects/` at a
`<repo>@<sha>`. OCR-derived text caps confidence at medium; when layout,
figures or formulas matter, open the original in `docs/assets/<scope>/` before
promotion. Document tokens and locators on a pasted citation line are skipped
by `restore`.

A claim about how repositories **interact** cites every involved repo from a
single `./workspace.sh cite` run — it prints the whole fleet as one coherent
line; paste the involved subset, or the **full line when the claim's
dependency surface is uncertain**. `cite` warns on stderr for any child with
uncommitted changes — do not cite a warned repo until it is clean, or note
the discrepancy in the finding. To re-examine any finding at its cited
state, paste its `<repo>@<sha>` citations after `./workspace.sh restore`
(bare `<repo>` returns a child to its manifest branch).

## Before analyzing any child

Read its README and its own AGENTS.md first; identify runtime, entry points,
APIs, storage; exclude generated-output and dependency directories (a
`docs/<scope>/sources/` derivative is the agent-readable form of its original, not
excluded output).

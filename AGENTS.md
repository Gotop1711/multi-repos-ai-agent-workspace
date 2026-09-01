# Workspace rules

Governance workspace for cross-repository analysis and gated development.
Child repositories live under `projects/` (gitignored clones) and are
**read-only by default**; `catalog/repos.yaml` lists the fleet and each repo's
access level (`write` / `pr-only` / `read-only`).

All records and documentation here are produced by agents: session logs
automatically at every closeout; the docs system per `docs/README.md`
(findings into a scope document's Open findings; the examined body only past
the examination bar).

## Every session

1. Run `./workspace.sh check` — halt on failure.
2. Read the newest 3 date-prefixed logs in `.agents/memory/sessions/` — your
   memory of previous sessions.
3. If the task targets a product, read `docs/<scope>.md`.
4. Work (rules below).
5. Close out — mandatory:
   - Write the session log
     `.agents/memory/sessions/YYYY-MM-DD-{agent}-{scope}-{task}.md`
     (copy `TEMPLATE.md`): the task, what was completed, **decisions &
     pitfalls** (failed attempts and WHY — the part that matters), TODO.
     Findings do NOT go here.
   - Record findings in `docs/<scope>.md` → **Open findings** (evidence rules
     below); promote into the document body only past the examination bar
     (`docs/README.md`). Workspace-level changes go to `./CHANGELOG.md`.
   - The closeout commit of THIS repo + push. That commit is the **one
     standing git authorization**; every other git action here — and any
     state-changing git action in a child repo (branch, commit, tag, push,
     PR) — waits for explicit human instruction. Read-only git in children
     (e.g. `rev-parse` for citations) and the checkouts `./workspace.sh
     restore` performs (they move HEAD, never history) are part of the
     sanctioned loop.

## Red lines

- ⛔ No branch, commit, tag, PR, or push in any child repo without a signed
  plan in `docs/plans/` (signature format in `docs/README.md`).
  Read-only repos' push URLs are disabled regardless.
- ⛔ The write surface is exactly: `.agents/memory/sessions/` (logs), `docs/`
  (per its rules), `./CHANGELOG.md`, and gitignored `.agents/scratch/` for
  disposable working artifacts (safe to delete anytime; their conclusions go
  into findings or the log). Never write inside `projects/`.
- ⛔ No secrets in any file, ever; report a credential's location, not its value.
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
APIs, storage; exclude generated-output and dependency directories.

# Workspace rules

Governance workspace for cross-repository analysis and gated development.
Child repositories live under `projects/` (gitignored clones) and are
**read-only by default**; `catalog/repos.yaml` lists the fleet and each repo's
access level (`write` / `pr-only` / `read-only`).

## Every session

1. Run `./workspace.sh check` — halt on failure.
2. Read the newest 3 date-prefixed logs in `.agents/memory/sessions/` — your
   memory of previous sessions.
3. If the task targets a product, read
   `docs/<scope>/{background,specification,CHANGELOG}.md`.
4. Work (rules below).
5. Close out — mandatory:
   - Session log `.agents/memory/sessions/YYYY-MM-DD-{agent}-{scope}-{task}.md`
     (copy `TEMPLATE.md`; **Decisions & pitfalls** is the part that matters —
     log failed attempts and WHY they failed).
   - If something shipped: CHANGELOG entry — product work in
     `docs/<scope>/CHANGELOG.md`, workspace work in `./CHANGELOG.md`.
   - The closeout commit of THIS repo + push. That commit is the **one standing
     git authorization**; every other git action here — and ANY git action in a
     child repo — waits for explicit human instruction.

## Red lines

- ⛔ No branch, commit, tag, PR, or push in any child repo without a signed
  plan in `docs/<scope>/plans/` (signature format in `docs/README.md`).
  Read-only repos' push URLs are disabled regardless.
- ⛔ Write outputs only under `tasks/` and `docs/` — never inside `projects/`.
- ⛔ No secrets in any file, ever; report a credential's location, not its value.
- ⛔ No production systems unless a task explicitly authorizes it (then
  read-only credentials only); no destructive commands; inspect source rather
  than executing it.
- ⛔ Start cross-repository sessions from this directory, never inside a child.
- ⛔ Never end a session without its session log.

## Evidence

Run `./workspace.sh snapshot <task>` before analysis. Every important finding cites:
repository id + commit (from that lockfile) + file + symbol; evidence type
(direct / corroborated / inferred / unverified); confidence (high / medium /
low); unresolved questions. Never assume same-named things in different repos
are the same entity without file-level evidence.

Start every findings file under `tasks/` (and each `docs/<scope>/specification.md`)
with a line `snapshot: snapshots/<date>-<task>.lock.yaml` — `./workspace.sh check`
verifies these citations resolve.

## Before analyzing any child

Read its README and its own AGENTS.md first; identify runtime, entry points,
APIs, storage; exclude generated-output and dependency directories.

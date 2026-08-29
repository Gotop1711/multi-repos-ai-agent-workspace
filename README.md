# multi-repos-ai-agent-workspace

One governance repo that lets AI agents work across many independent code
repositories — safely, with durable memory, and with evidence for every claim.

> **Start here: [docs/BLUEPRINT.md](docs/BLUEPRINT.md)** — why this repository
> exists and the seven ideas behind its design, in ~150 lines. Everything else
> in this repo is an implementation of that document.

**12 files, one script.** The rules live in [AGENTS.md](AGENTS.md); the
mechanics live in [workspace.sh](workspace.sh).

```
this repo                 ← governance: rules, memory, snapshots, docs
└── projects/             ← gitignored clones of your child repos
```

## Get started

```bash
./workspace.sh setup           # 1. wires the safety hook, prints what to do next
# edit catalog/repos.yaml      # 2. declare your child repos + access levels
./workspace.sh clone           # 3. fleet appears under projects/
```

Then add a **private remote** for this repo and push — its memory must survive
a dead disk. (It ships with none on purpose.)

## Daily loop

```bash
./workspace.sh snapshot <task>  # 1. pin the fleet
# 2. agent works: reads projects/, writes tasks/<date>-<task>/ and docs/
# 3. agent closes out: session log + closeout commit + push — you review the diff
```

## What each file and folder is

| Path | One line |
|---|---|
| `docs/BLUEPRINT.md` | Why this repo exists; the design rationale |
| `AGENTS.md` | The whole rulebook — canonical for every agent runtime |
| `CLAUDE.md` | ≤5-line bridge to `AGENTS.md` (one per installed runtime that needs it) |
| `workspace.sh` | `setup` \| `clone` \| `snapshot <task>` \| `restore <lockfile>` \| `check` |
| `catalog/repos.yaml` | The fleet manifest — also the authorization record |
| `snapshots/` | Committed lockfiles; every finding cites one *(appears on your first `snapshot` — git cannot track an empty directory)* |
| `.agents/memory/sessions/` | The diary: one log per session — decisions & pitfalls |
| `docs/<scope>/` | The library: settled per-product state + signed plans (see `docs/README.md`) |
| `tasks/` | Working records, one directory per task |
| `.githooks/pre-commit` | Runs `workspace.sh check`; broken states cannot be committed |

## Growing it

Add nothing until a real need bites **twice**; then add the piece and note it
in the CHANGELOG. The full trigger table is in
[docs/BLUEPRINT.md §4](docs/BLUEPRINT.md) — in short: skills when how-tos
repeat, schemas when finding shapes drift, `policies/` when the rulebook
outgrows a page, catalog knowledge when relationships get re-derived, `labs/`
when prototyping precedes plans, `reports/` when analyses leave the team.

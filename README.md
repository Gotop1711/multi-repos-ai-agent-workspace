# multi-repos-ai-agent-workspace

One governance repo that lets AI agents work across many independent code
repositories — safely, with durable memory, and with evidence for every claim.

> **Start here: [docs/BLUEPRINT.md](docs/BLUEPRINT.md)** — why this repository
> exists and the seven ideas behind its design, in one short read. Everything else
> in this repo is an implementation of that document.

**11 files, one script.** The rules live in [AGENTS.md](AGENTS.md); the
mechanics live in [workspace.sh](workspace.sh). Every record and document is
agent-written — except `sources/`, the extracted text of documents you hand
it (`ingest` files the originals in your document store): session logs written by the
agent at closeout, findings into the docs system, the examined parts of
`docs/` only past an examination bar.

```
this repo                 ← governance: rules, memory, docs
├── sources/              ← tracked text of your documents, one .md per original (workspace.sh ingest / extract)
├── originals -> <store>  ← gitignored symlink to your document store
└── projects/             ← gitignored clones of your child repos
```

## Get started

```bash
./workspace.sh setup           # 1. wires the safety hook, prints what to do next
# edit catalog/repos.yaml      # 2. declare your child repos + access levels
./workspace.sh clone           # 3. fleet appears under projects/
./workspace.sh ingest <scope> <files>   # 4. (optional) documents become agent-readable: copied into the store (~/Documents/workspace-originals, or $WORKSPACE_STORE), text under sources/<scope>/
```

Then add a **private remote** for this repo and push — its memory must survive
a dead disk. (It ships with none on purpose.)

## Daily loop

```bash
# 1. agent works: reads projects/; findings land in docs/<scope>.md
#    ("Open findings"); the examined body changes only past the bar
# 2. agent closes out: session log + closeout commit + push — you review the diff
```

## What each file and folder is

| Path | One line |
|---|---|
| `README.md` | This file: what the workspace is, setup, the daily loop |
| `docs/BLUEPRINT.md` | Why this repo exists; the design rationale |
| `AGENTS.md` | The whole rulebook — canonical for every agent runtime |
| `CLAUDE.md` | ≤5-line bridge to `AGENTS.md` (one per installed runtime that needs it) |
| `workspace.sh` | `setup` \| `clone` \| `cite` \| `restore` \| `ingest` \| `extract` \| `check` |
| `catalog/repos.yaml` | The fleet manifest — also the authorization record; optional `scope:` per repo names its home scope document |
| `CHANGELOG.md` | Workspace-level record of what changed and why, newest entry first |
| `.gitignore` | Keeps `projects/`, `originals`, scratch, secrets and local runtime state out of the repo |
| `.agents/memory/sessions/` | Simple journey logs, one per agent run — decisions & pitfalls, never findings |
| `docs/README.md` | The docs system's rules: scopes, intake, examination bar, signature gate |
| `docs/<scope>.md` + `docs/plans/<scope>--<feature>.md` | The knowledge system: per-scope document (Open-findings intake + examined body) plus signed plans (see `docs/README.md`) |
| `sources/<scope>/` + `originals/` | Human-supplied documents: tracked text derivatives (`ingest`/`extract` output, cited `…@<blob>`) / gitignored symlink to their originals in the store |
| `.githooks/pre-commit` | Runs `workspace.sh check` and refuses binaries and files over 1 MiB; broken states cannot be committed |

## Growing it

Add nothing until a real need bites **twice**; then add the piece and note it
in the CHANGELOG. The full trigger table is in
[docs/BLUEPRINT.md §4](docs/BLUEPRINT.md) — in short: skills when how-tos
repeat, schemas when finding shapes drift, `policies/` when the rulebook
outgrows a page, catalog knowledge when relationships get re-derived, `labs/`
when prototyping precedes plans, `reports/` when analyses leave the team.

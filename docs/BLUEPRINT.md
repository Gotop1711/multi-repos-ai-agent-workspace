# Blueprint — why this repository exists

> This repository is a **governance workspace**: one repo that lets AI agents
> (and the humans directing them) work across many independently managed code
> repositories — safely, with durable memory, and with evidence for every
> claim. This document is the design rationale: the problems it solves, the
> seven ideas it is built on, and the reasoning behind every file that ships.

**Provenance.** This design synthesizes two earlier documents — an
AI-researched workspace specification (git-submodule superproject,
evidence-backed analysis) and a practitioner's multi-agent governance handbook
(proven over months of real operation) — each taken critically, neither
wholesale. Their heavyweight layers (catalog knowledge files, JSON schemas,
policy files, day-one skill libraries, generator scripts) turned out to
describe a *mature* workspace, not a starting one; here they are **triggered
extensions**, never foundation.

---

## 1. The seven load-bearing ideas

1. **Two layers, one filesystem.** This governance repo (rules, memory,
   snapshots, docs) sits above gitignored working clones of independent child
   repos under `projects/`. Child histories are never merged; nothing is ever
   generated into a child.
2. **Manifest + lockfiles, not submodules.** `catalog/repos.yaml` declares the
   fleet (path, remote, branch, per-repo `access`); `workspace.sh snapshot`
   pins every child's commit into a committed lockfile that findings cite;
   `workspace.sh restore` reproduces any clean-tree analysis state. For
   `read-only` repos the push URL is disabled at clone time — violations fail
   mechanically, not socially.
3. **One rulebook, thin bridges.** `AGENTS.md` is the single canonical
   instruction file (the cross-vendor standard most agent runtimes read
   natively); any vendor file (`CLAUDE.md`, …) is a ≤5-line bridge pointing at
   it, created only for runtimes actually installed.
4. **Diary + library.** `.agents/memory/sessions/` is the append-only diary —
   one date-prefixed log per session, its value concentrated in *decisions &
   pitfalls* (failed attempts and why). `docs/<scope>/` is the library — the
   settled current state per product (human-set `background.md`,
   agent-maintained `specification.md`, `CHANGELOG.md`, `plans/`). Confirmed
   knowledge is distilled from diary to library; dead ends stay in the diary.
5. **Evidence discipline.** Every important finding cites repository id +
   commit (from the task's lockfile) + file + symbol, an evidence type
   (direct / corroborated / inferred / unverified), a confidence level
   (high / medium / low), and unresolved questions. Same-named things in
   different repos are never assumed identical without file-level evidence.
6. **One human gate.** No write of any kind to a child repository before a
   human signs the plan in `docs/<scope>/plans/` (format in `docs/README.md`).
   The one standing git authorization is the session-closeout commit (and its
   push) of the workspace repo itself; everything else waits for explicit
   instruction.
7. **One script, machine-checked.** All mechanics live in `workspace.sh`
   (`setup | clone | snapshot | restore | check`); the pre-commit hook runs
   `workspace.sh check` so a broken state cannot be committed. No agent
   vigilance where a script can verify.

The workspace repo gets **one private remote** (its memory must survive a dead
disk); the root `.gitignore` and a secret scanner (if installed) keep child
code and credentials out of it.

## 2. Structure — 12 files

```text
multi-repos-ai-agent-workspace/
├── README.md                        ← what this is + setup + daily loop
├── AGENTS.md                        ← the whole rulebook (canonical)
├── CLAUDE.md                        ← bridge: "@AGENTS.md"
├── CHANGELOG.md                     ← workspace-level record (append-only)
├── .gitignore                       ← projects/ .env* keys local settings
├── workspace.sh                     ← setup | clone | snapshot | restore | check
├── .githooks/pre-commit             ← runs workspace.sh check (+ gitleaks if installed)
├── catalog/repos.yaml               ← the fleet manifest (edit first)
├── docs/README.md                   ← scope layout, signature gate, writing rules
├── docs/BLUEPRINT.md                ← this document
├── .agents/memory/sessions/TEMPLATE.md  ← session-log template
├── tasks/README.md                  ← one dir per task; findings cite lockfiles
│
├── snapshots/                       ← lockfiles appear here (tracked)
├── docs/<scope>/                    ← created per product as work begins
└── projects/                        ← gitignored; created by workspace.sh clone
```

## 3. The daily loop

```bash
# once per machine
git clone <workspace-url> && cd <workspace>
./workspace.sh setup           # wires the safety hook, prints what to do next
./workspace.sh clone

# per task — three steps
./workspace.sh snapshot <task>  # 1. pin the fleet
# 2. agent works: reads projects/, writes tasks/<date>-<task>/ and docs/
# 3. agent closes out: session log + closeout commit + push (you review the diff)
```

The agent's own loop is defined in `AGENTS.md`: check → read newest session
logs → read the task's `docs/<scope>/` → work → session log + closeout commit.

## 4. Deferred extensions — add when the trigger bites

| Trigger (a real, recurring pain) | Add |
|---|---|
| The same how-to gets re-explained across sessions | `.agents/skills/<name>/SKILL.md`; a generated registry only once skills are numerous |
| Finding shapes drift between tasks | JSON Schemas (`schemas/`) |
| AGENTS.md's rules outgrow one page | Split into `policies/`, linked not duplicated |
| The same cross-repo relationship gets re-derived from source in a second task | `catalog/systems.yaml`, `relationships.yaml`, glossary |
| Prototyping needed before a plan can be judged | `labs/` (tracked; no production standards) |
| One-off queries clutter tasks/ | `scratch/` (gitignored, disposable) |
| Reviewed analyses shared beyond the team | `reports/` (+ `audits/<date>/`) |
| Sessions keep starting inside a child directory | Generated `CLAUDE.local.md` child bridge |
| The sessions folder outgrows eyeballing | Generated `index.md` |
| A second agent runtime joins | Nothing structural — the `{agent}` tag in session-log filenames already carries it; add that vendor's ≤5-line bridge only if it doesn't read `AGENTS.md` natively |

Rule of adoption: **did it bite twice?** If yes, add the extension and note it
in the CHANGELOG. If no, a session-log entry suffices.

## 5. Alternatives considered and rejected

Each of these was weighed and deliberately not built in:

| Alternative | Here | Why |
|---|---|---|
| A day-one `policies/` directory | Folded into `AGENTS.md` for now | Splitting a one-page rulebook duplicates it, and duplication drifts; split (linked, not duplicated) only when `AGENTS.md` outgrows a page (§4) |
| Day-one JSON Schemas (`schemas/`) | Deferred | The evidence format is five lines in `AGENTS.md`; contracts earn their keep only when shapes drift |
| Day-one catalog knowledge files (systems/domains/relationships/glossary) | Deferred; only `repos.yaml` ships | Knowledge grows from confirmed findings, not from scaffolding |
| A day-one skill library + generated registry | Deferred | With no skills on day one there is nothing to route or generate |
| One script per mechanism | One `workspace.sh` with five subcommands | Fewer files to understand beats separation of concerns at this scale |
| A wider consistency checker | `workspace.sh check` (manifest + cited lockfiles) | The extra checks would guard machinery that doesn't exist day one |
| Pre-created `reports/`, `labs/`, `scratch/`, task templates | Deferred / single `TEMPLATE.md` | Not used weekly at the start |
| Per-directory READMEs everywhere | Three READMEs + this blueprint | The rulebook is one page; orientation files for empty trees are noise |
| Git submodules | Manifest + lockfiles | Submodules dirty the parent on every child pull, detach HEADs, clone emptily when `--init` is forgotten, and hard-fail on one inaccessible private child; lockfiles keep all of the pinning value with none of that |
| A never-pushed, local-only governance repo | Private remote required | No remote makes irreplaceable memory a single-disk point of failure; secret hygiene achieves the same privacy without the fragility |

## 6. Acceptance

The workspace is correct when:

1. Editing `repos.yaml` + `./workspace.sh clone` produces the fleet; an
   inaccessible repo fails individually; a `read-only` repo's `git push` fails
   loudly.
2. `./workspace.sh snapshot t` writes a lockfile findings can cite, and
   `./workspace.sh restore` returns clean children to those SHAs.
3. Deleting a cited lockfile (or breaking the manifest) makes
   `workspace.sh check` — and therefore the pre-commit hook — fail.
4. A second session (any runtime) picks up the first session's decisions and
   pitfalls from the logs with no human re-briefing.
5. No write to any child repo is possible under the rules without a signed
   plan, and the only unprompted git actions are the closeout commit and its
   push.
6. With the private remote configured, a dead machine costs at most
   uncommitted local work — never the memory.

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
   docs) sits above gitignored working clones of independent child
   repos under `projects/`. Child histories are never merged; nothing is ever
   generated into a child.
2. **Manifest, not submodules.** `catalog/repos.yaml` declares the fleet
   (path, remote, branch, per-repo `access`); `workspace.sh clone` rebuilds
   it. For `read-only` repos the push URL is disabled at clone time —
   violations fail mechanically, not socially. Evidence is anchored per
   finding — each cites the commit it was observed at (`<repo>@<sha>`) —
   with no fleet-wide pinning machinery.
3. **One rulebook, thin bridges.** `AGENTS.md` is the single canonical
   instruction file (the cross-vendor standard most agent runtimes read
   natively); any vendor file (`CLAUDE.md`, …) is a ≤5-line bridge pointing at
   it, created only for runtimes actually installed.
4. **Logs + a docs system.** `.agents/memory/sessions/` holds simple journey
   logs — one automatically written log per agent session: the task, what was
   completed, *decisions & pitfalls* (failed attempts and why), TODO. All
   knowledge —
   even tentative — lives in the docs system: each `docs/<scope>.md` has an
   **Open findings** intake (every finding, evidence-labeled) and an examined
   **body**, separated by the examination bar (`docs/README.md`); `docs/plans/`
   holds the signed plans. Logs are append-only; documentation is maintained.
5. **Evidence discipline.** Every finding cites repository id + the commit it
   was observed at (`<repo>@<sha>`) + file + symbol, an evidence type
   (direct / corroborated / inferred / unverified), a confidence level
   (high / medium / low), and unresolved questions. Same-named things in
   different repos are never assumed identical without file-level evidence.
6. **One human gate.** No write of any kind to a child repository before a
   human signs the plan in `docs/plans/` (format in `docs/README.md`).
   The one standing git authorization is the session-closeout commit (and its
   push) of the workspace repo itself; everything else waits for explicit
   instruction.
7. **One script, machine-checked.** All mechanics live in `workspace.sh`
   (`setup | clone | check`); the pre-commit hook runs `workspace.sh check`
   so a broken state cannot be committed. No agent vigilance where a script
   can verify.

The workspace repo gets **one private remote** (its memory must survive a dead
disk); the root `.gitignore` and a secret scanner (if installed) keep child
code and credentials out of it.

## 2. Structure — 11 files

```text
multi-repos-ai-agent-workspace/
├── README.md                        ← what this is + setup + daily loop
├── AGENTS.md                        ← the whole rulebook (canonical)
├── CLAUDE.md                        ← bridge: "@AGENTS.md"
├── CHANGELOG.md                     ← workspace-level record (append-only)
├── .gitignore                       ← projects/ .env* keys local settings
├── workspace.sh                     ← setup | clone | check
├── .githooks/pre-commit             ← runs workspace.sh check (+ gitleaks if installed)
├── catalog/repos.yaml               ← the fleet manifest (edit first)
├── docs/README.md                   ← docs system rules: intake, examination bar, gate
├── docs/BLUEPRINT.md                ← this document
├── .agents/memory/sessions/TEMPLATE.md  ← session-log template
│
├── docs/<scope>.md                  ← created per product, as findings arrive
├── docs/plans/                      ← created with the first gated plan
├── .agents/scratch/                 ← gitignored; disposable working artifacts
└── projects/                        ← gitignored; created by workspace.sh clone
```

## 3. The daily loop

```bash
# once per machine
git clone <workspace-url> && cd <workspace>
./workspace.sh setup           # wires the safety hook, prints what to do next
./workspace.sh clone

# per task — two steps
# 1. agent works: reads projects/; findings land in docs/<scope>.md
#    ("Open findings"); the examined body changes only past the bar
# 2. agent closes out: session log + closeout commit + push (you review the diff)
```

The agent's own loop is defined in `AGENTS.md`: check → read newest session
logs → read the task's `docs/<scope>.md` → work → session log + closeout
commit.

## 4. Deferred extensions — add when the trigger bites

| Trigger (a real, recurring pain) | Add |
|---|---|
| The same how-to gets re-explained across sessions | `.agents/skills/<name>/SKILL.md`; a generated registry only once skills are numerous |
| Finding shapes drift between sessions | JSON Schemas (`schemas/`) |
| AGENTS.md's rules outgrow one page | Split into `policies/`, linked not duplicated |
| The same cross-repo relationship gets re-derived from source in a second task | `catalog/systems.yaml`, `relationships.yaml`, glossary |
| Prototyping needed before a plan can be judged | `labs/` (tracked; no production standards) |
| A scope document outgrows one file | Split `docs/<scope>.md` into a `docs/<scope>/` folder |
| Analyses must be reproducible for audits or a second engineer | Whole-fleet snapshot lockfiles (pin + restore machinery) |
| Reviewed analyses shared beyond the team | `reports/` (+ `audits/<date>/`) |
| Sessions keep starting inside a child directory | Generated `CLAUDE.local.md` child bridge |
| The sessions folder outgrows eyeballing | Generated `index.md` |
| A second agent runtime joins | Nothing structural — the `{agent}` tag in session-log filenames already carries it; add that vendor's ≤5-line bridge only if it doesn't read `AGENTS.md` natively |

Rule of adoption: **did it bite twice?** If yes, add the extension and note it
in the CHANGELOG. If no, a note in the session log suffices.

## 5. Alternatives considered and rejected

Each of these was weighed and deliberately not built in:

| Alternative | Here | Why |
|---|---|---|
| A day-one `policies/` directory | Folded into `AGENTS.md` for now | Splitting a one-page rulebook duplicates it, and duplication drifts; split (linked, not duplicated) only when `AGENTS.md` outgrows a page (§4) |
| Day-one JSON Schemas (`schemas/`) | Deferred | The evidence format is five lines in `AGENTS.md`; contracts earn their keep only when shapes drift |
| Day-one catalog knowledge files (systems/domains/relationships/glossary) | Deferred; only `repos.yaml` ships | Knowledge grows from confirmed findings, not from scaffolding |
| A day-one skill library + generated registry | Deferred | With no skills on day one there is nothing to route or generate |
| One script per mechanism | One `workspace.sh` with three subcommands | Fewer files to understand beats separation of concerns at this scale |
| A wider consistency checker | `workspace.sh check` (manifest validation) | The extra checks would guard machinery that doesn't exist day one |
| Pre-created `reports/` and `labs/` | Deferred | Not used weekly at the start |
| A separate `tasks/` workbench directory for working findings | Findings go straight into the docs system | A third home for knowledge would mean two hand-offs (task file → distillation → docs); the Open-findings intake inside each scope document keeps exactly one |
| Multi-file scope folders (`background` / `specification` / `CHANGELOG` per scope) | One examined `docs/<scope>.md`, split only when it outgrows a file | Fewer files to keep coherent; the examination bar, not file boundaries, is what protects documentation quality |
| Per-directory READMEs everywhere | Two READMEs + this blueprint | The rulebook is one page; orientation files for empty trees are noise |
| Git submodules | A plain manifest | Submodules dirty the parent on every child pull, detach HEADs, clone emptily when `--init` is forgotten, and hard-fail on one inaccessible private child; a manifest composes the fleet without any of that |
| Whole-fleet snapshot lockfiles (pin/restore machinery, citation checks) | Per-finding `<repo>@<sha>` citations | Fleet-wide pinning earns its keep in multi-engineer audit settings; a single-operator workspace only needs each claim anchored to the commit it was observed at — one `rev-parse`, zero machinery |
| Findings recorded inside the session logs | Findings live in the docs system's Open-findings intake | Logs are the journey; knowledge — even tentative — belongs where it will be examined and maintained, not in an append-only diary |
| A never-pushed, local-only governance repo | Private remote required | No remote makes irreplaceable memory a single-disk point of failure; secret hygiene achieves the same privacy without the fragility |

## 6. Acceptance

The workspace is correct when:

1. Editing `repos.yaml` + `./workspace.sh clone` produces the fleet; an
   inaccessible repo fails individually; a `read-only` repo's `git push` fails
   loudly.
2. Every claim in a scope document's body carries a `<repo>@<sha>` citation
   and survives re-verification against source at that commit.
3. Breaking the manifest makes `workspace.sh check` — and therefore the
   pre-commit hook — fail.
4. A second session (any runtime) picks up the first session's decisions and
   pitfalls from the session logs with no human re-briefing.
5. No write to any child repo is possible under the rules without a signed
   plan, and the only unprompted git actions are the closeout commit and its
   push.
6. With the private remote configured, a dead machine costs at most
   uncommitted local work — never the memory.

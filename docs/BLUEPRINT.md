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
   generated into a child. Beside the code sits the document layer:
   human-supplied originals in an external store mirrored at gitignored
   `originals/`, one tracked text derivative each under `sources/<scope>/` —
   readable on any machine without the originals or the extraction tools,
   cited by git blob.
2. **Manifest, not submodules.** `catalog/repos.yaml` declares the fleet
   (path, remote, branch, per-repo `access`); `workspace.sh clone` rebuilds
   it. For `read-only` repos the push URL is disabled at clone time —
   violations fail mechanically, not socially. Evidence is anchored per
   finding — each cites the commit it was observed at (`<repo>@<sha>`) —
   with no lockfile machinery: `workspace.sh cite` prints the whole fleet
   as one coherent citation line, and `restore` checks cited commits back out.
3. **One rulebook, thin bridges.** `AGENTS.md` is the single canonical
   instruction file (the cross-vendor standard most agent runtimes read
   natively); any vendor file (`CLAUDE.md`, …) is a ≤5-line bridge pointing at
   it, created only for runtimes actually installed.
4. **Logs + a docs system.** `.agents/memory/sessions/` holds simple journey
   logs — one written log per agent session: the task, what was
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
   Claims about repo *interactions* cite every involved repo from one
   `cite` run — the full fleet line when the dependency surface is uncertain.
6. **One human gate.** No write of any kind to a child repository before a
   human signs the plan in `docs/plans/` (format in `docs/README.md`).
   The one standing git authorization is the session-closeout commit (and its
   push) of the workspace repo itself; everything else waits for explicit
   instruction.
7. **One script, machine-checked.** All mechanics live in `workspace.sh`
   (`setup | clone | cite | restore | extract | check`); the pre-commit hook
   runs `workspace.sh check` and refuses binaries and files over 1 MiB, so a
   broken state cannot be committed. No agent vigilance where a script can
   verify.

The workspace repo gets **one private remote** (its memory must survive a dead
disk); the root `.gitignore`, the hook's binary / 1 MiB gate and a secret
scanner (if installed) keep child code, binaries and credentials out of it.

## 2. Structure — 11 files

```text
multi-repos-ai-agent-workspace/
├── README.md                        ← what this is + setup + daily loop
├── AGENTS.md                        ← the whole rulebook (canonical)
├── CLAUDE.md                        ← bridge: "@AGENTS.md"
├── CHANGELOG.md                     ← workspace-level record (append-only)
├── .gitignore                       ← /projects/ /originals .env* keys local settings
├── workspace.sh                     ← setup | clone | cite | restore | extract | check
├── .githooks/pre-commit             ← runs workspace.sh check + refuses binaries and > 1 MiB (+ gitleaks if installed)
├── catalog/repos.yaml               ← the fleet manifest (edit first); optional scope: per repo = its home scope document (default: the repo id)
├── docs/README.md                   ← docs system rules: intake, examination bar, gate
├── docs/BLUEPRINT.md                ← this document
├── .agents/memory/sessions/TEMPLATE.md  ← session-log template
│
├── docs/<scope>.md                  ← one per scope (a product or system a human names), created as findings arrive; never moves
├── docs/<scope>/<topic>.md          ← growth only: examined Body topics moved out beside the root
├── docs/plans/<scope>--<feature>.md ← created with the first gated plan
├── sources/<scope>/                 ← created by workspace.sh extract; tracked text derivatives of human documents
├── originals/                       ← gitignored; per-machine symlink to the document store
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
| The same cross-repo relationship gets re-derived from source in a second task | `catalog/systems.yaml`, `relationships.yaml`, glossary — keyed by the same scope ids as `docs/`; the glossary trigger is the same term defined differently in two scopes' Terms sections |
| Prototyping needed before a plan can be judged | `labs/` (tracked; no production standards) |
| Two sessions in a row needed one Body section of a scope document and paid for the whole file | Move that topic verbatim to `docs/<scope>/<topic>.md`, pointer left under the heading; the root stays with Changes and Open findings (`docs/README.md`) |
| A human's word for a product failed to resolve to a scope id twice, or `ls docs/` exceeds one screen | An `Aliases:` line under the scope's H1; at ~25 scopes a scope table (id → name → aliases → repos) in `docs/README.md` |
| A scope's Open findings tray is dominated by struck entries and a session paid for it twice | Roll struck entries verbatim into `docs/<scope>/archive.md` (append-only), one pointer line left in the tray |
| A `scope:` value names a scope with no document, or a plan/log filename carries a scope id no document has, twice | ~10 lines in `workspace.sh check`: warn on an unbound `scope:`, fail on a filename token outside the id grammar |
| `ls`/`grep` over `sources/` stop answering "do we have a document about X" (or > ~100 documents) | Generated `sources/INDEX.md`, regenerated at each ingest and checked by `check` |
| Two findings disagree about which version of a store file they read, or the store's version history proves too short | Originals into a git repo listed `read-only` in `repos.yaml` (`projects/originals`), `originals` symlinked to it; `cite` then carries its sha |
| A store mismatch is discovered late twice | `workspace.sh verify` (batch `shasum` of the store against headers; launchd schedule) |
| A re-examination of a document citation is done by hand twice | `restore` writes `git show <blob>` into `.agents/scratch/restore/` |
| An analysis spans multiple sessions against moving upstreams, or a third party must verify what the fleet looked like independent of any finding | Standalone snapshot artifacts: task-named fleet lockfiles committed to git |
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
| One script per mechanism | One `workspace.sh` (`setup | clone | cite | restore | check`) | Fewer files to understand beats separation of concerns at this scale |
| A wider consistency checker | `workspace.sh check` (manifest validation) | The extra checks would guard machinery that doesn't exist day one |
| Pre-created `reports/` and `labs/` | Deferred | Not used weekly at the start |
| A separate `tasks/` workbench directory for working findings | Findings go straight into the docs system | A third home for knowledge would mean two hand-offs (task file → distillation → docs); the Open-findings intake inside each scope document keeps exactly one |
| Multi-file scope folders (`background` / `specification` / `CHANGELOG` per scope) | One examined `docs/<scope>.md`, split only when it outgrows a file | Fewer files to keep coherent; the examination bar, not file boundaries, is what protects documentation quality; after a growth split only examined Body topics become files — the intake and Changes stay in the root |
| Per-directory READMEs everywhere | Two READMEs + this blueprint | The rulebook is one page; orientation files for empty trees are noise |
| Git submodules | A plain manifest | Submodules dirty the parent on every child pull, detach HEADs, clone emptily when `--init` is forgotten, and hard-fail on one inaccessible private child; a manifest composes the fleet without any of that |
| Whole-fleet snapshot lockfiles (generated files, naming ceremony, dangling-citation checks) | Per-finding citations + `cite`/`restore` | The lockfile's two real capabilities survive without the file: `cite` captures a coherent cross-repo moment as one inline line, and `restore` reproduces any cited state straight from a finding. What stays rejected is the standalone artifact — a fleet record independent of any finding — whose value waits on the §4 audit trigger |
| Findings recorded inside the session logs | Findings live in the docs system's Open-findings intake | Logs are the journey; knowledge — even tentative — belongs where it will be examined and maintained, not in an append-only diary |
| A never-pushed, local-only governance repo | Private remote required | No remote makes irreplaceable memory a single-disk point of failure; secret hygiene achieves the same privacy without the fragility |
| Documents tracked as binaries in this repo (`docs/<scope>/sources/`) | Text only; originals in a store | Append-only history keeps every byte forever, git-lfs is absent, GitHub caps files at 100 MB; agents read text, not PDFs |
| A documents git repository as a read-only child on day one | A folder in a store + tracked text | Versioning originals is a §4 trigger; a folder costs nothing, a multi-GB corpus child would be full-cloned by every machine and a leaked secret could only be purged by rewriting its history, killing every later citation |
| A central `catalog/documents.yaml` | The header of each derivative | Duplicates what the derivative carries, conflicts when two machines ingest, thousands of lines on day one |
| Git LFS | Not used | A dependency on every clone, quotas, and pointers still fill history |

## 6. Acceptance

The workspace is correct when:

1. Editing `repos.yaml` + `./workspace.sh clone` produces the fleet; an
   inaccessible repo fails individually; a `read-only` repo's `git push` fails
   loudly.
2. Every claim in a scope document's body carries a `<repo>@<sha>` citation
   and survives re-verification against source at that commit.
3. Pasting a finding's citations after `./workspace.sh restore` checks those
   children out at the cited commits; a child with local changes is refused;
   bare `restore <repo>` returns it to its manifest branch.
4. Breaking the manifest makes `workspace.sh check` — and therefore the
   pre-commit hook — fail.
5. A second session (any runtime) picks up the first session's decisions and
   pitfalls from the session logs with no human re-briefing.
6. No write to any child repo is possible under the rules without a signed
   plan, and the only unprompted git actions are the closeout commit and its
   push.
7. With the private remote configured, a dead machine costs at most
   uncommitted local work — never the memory; document originals are as safe
   as the store they live in (versioned or snapshotted by requirement), their
   extracted text as safe as the remote.
8. A staged binary or > 1 MiB file makes the hook fail; a stray file or a
   headerless derivative under `sources/` makes `check` fail, an edited stored
   original makes it warn; `git show <blob>` of a document citation returns
   the exact text the finding read.

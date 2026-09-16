# Workspace rules

Governance workspace for cross-repository work. Child repositories are gitignored clones under `projects/`, **read-only by default**; `catalog/repos.yaml` lists the fleet — each repo's access (`write` / `pr-only` / `read-only`) and its `product:`. Rules are here; mechanics in `workspace.sh` (`./workspace.sh help`).

## Documents — made and unmade by command, small by rule

```
docs/<product>/index.md            the product: what it is; links to its modules, repositories, open plans   ≤ 80 lines
docs/<product>/<module>.md         one subsystem each — the only place facts live                              ≤ 150
docs/<product>/<repo>/index.md     a related repository: run, test, entry points, integration                  ≤ 100
docs/<product>/[<repo>/]sources/   ingested documents' text — `ingest` / `extract` output only, never hand-edited
docs/<product>/plans/<feature>.md  task-oriented: goal, writes, steps, done-when; removed by `plan done` / `rm`  ≤ 80
docs/assets/<product>/[<repo>/]    the originals — gitignored, added by `ingest` only, removed by `prune`
.agents/memory/sessions/           one log per session — the journey, never the facts                          ≤ 40
```

`doc init` / `doc add` / `doc rm` / `plan new` / `plan done` / `plan rm` create and remove these (a plan goes with its logs and the sources only it used); `check` fails a file over its cap (lines counted wrapped at 100 columns) — split it into a module, or cut: git keeps the rest. Every document is **maintained state**: rewritten in place when stale, never appended with history — `git log -- <file>` is its history. There is no findings tray and no status note in prose; the workspace's own rule changes are one line each in `CHANGELOG.md` (`main` only, ≤ 60 lines).

## Every session

1. `./workspace.sh check` — halt on failure.
2. Read `docs/<product>/index.md`, the modules and repository docs the task needs, its plan if it has one, and the newest 3 logs for the product (`ls .agents/memory/sessions | grep -- "-<product>--" | tail -3`).
3. Before analysing a child: its README and AGENTS.md; runtime, entry points, APIs, storage; skip generated-output and dependency directories.
4. Work. A fact you establish goes into the module or repository doc it belongs to, cited; a defect or decision that needs child-repo work becomes `plan new`; nothing else is written.
5. Close out — mandatory: the log (task, done, **decisions & pitfalls** — failed attempts and why — todo); `plan done` for a plan the owner has verified or abandoned, once what it delivered is in the modules; `check`; the closeout commit. That commit is the **one standing git authorization** — push `main`; an organization's branch as its owner instructs. Every other git action here, and any state-changing git action in a child (branch, commit, tag, push, PR), waits for explicit human instruction; read-only git and the checkouts `restore` performs are always allowed.

## Plans and the signature gate

A plan is `docs/<product>/plans/<feature>.md`. Its header — the lines between the H1 and the first `##` — is its whole lifecycle, one line each, appended and never overwritten:

```
Writes: <REPO> (<branch>), …            the write set the signature covers
Status: draft | signed | shipped | verified | abandoned
Signed: <name> — <YYYY-MM-DD>           human, exactly once — the gate
Amended: <YYYY-MM-DD> — <what>          agent, on the owner's word in session, inside the write set
Shipped: <YYYY-MM-DD> — <repo>@<sha>…   agent — the landed commits
Verified: <name> [— <YYYY-MM-DD>]       human, exactly once — final
Abandoned: <YYYY-MM-DD> — <why>
```

⛔ No write of any kind to a child repository before `Signed:` exists, and none outside `Writes:`. A change that leaves the write set is a new plan. `check` derives `Status:` from the lines and lists shipped plans awaiting `Verified:`. A decision with a "no change" answer ends as `Abandoned: — decided: <ruling>`, the ruling written into the module it concerns.

## Evidence

Every claim in a module or repository doc says where it was seen: `<repo>@<sha> <path>:<line>` — `./workspace.sh cite` prints the fleet as one line (paste it for a claim about how repositories interact; it warns on a dirty child); `restore` returns the fleet to a citation — or, for a document, `docs/<product>/[<repo>/]sources/<name>.md@<blob> L<n>` (`git hash-object`; `git show <blob>` re-reads it even after removal). Same-named things in different repositories are not the same thing without file-level evidence. Say what is inferred.

## Boilerplate and organizations

`main` is the boilerplate; each organization works on its own branch (or fork), synced by its owner — `git rebase main`, then `check`. **Organization content** is `catalog/*.yaml`, everything under `docs/`, and session logs whose product token is not `workspace`; **every other path is boilerplate** — changed on `main` only, identical on every branch, never naming an organization. A defect in the workspace found on an organization's branch goes to that log's TODO as a `[workspace]` line, worded generically; `check` enforces the split.

## Red lines

- ⛔ Write surface: `docs/<product>/**` (by the commands, and by hand inside index / module / repository / plan text), `.agents/memory/sessions/`, `docs/assets/` through `ingest` only, gitignored `.agents/scratch/` for disposable work. Never write inside `projects/`; never edit a `sources/` file or an original.
- ⛔ No secrets in any file, ever — report a credential's location, not its value; `ingest` refuses a document that contains one.
- ⛔ Nothing binary and nothing over 1 MiB enters this repository — the pre-commit hook refuses it.
- ⛔ No production systems unless a task explicitly authorizes it (then read-only credentials only); no destructive commands; inspect source rather than executing it.
- ⛔ Start cross-repository sessions from this directory, never inside a child.
- ⛔ Never end a session without its log.

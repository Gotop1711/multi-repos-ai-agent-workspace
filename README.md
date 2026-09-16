# Multi-repo agent workspace

One governance repository from which AI agents work across many independently managed child repositories — gitignored clones under `projects/`, a fleet manifest with per-repo access, small command-made documentation, and a signature gate before any child is written. Rules: [AGENTS.md](AGENTS.md). Mechanics: [workspace.sh](workspace.sh).

```
docs/<product>/index.md            the product — what it is, links to modules, repositories, open plans
docs/<product>/<module>.md         one subsystem each; the facts, each cited <repo>@<sha> path:line
docs/<product>/<repo>/index.md     a related repository: run, test, entry points, integration
docs/<product>/[<repo>/]sources/   text of documents you hand it (ingest); originals in gitignored docs/assets/
docs/<product>/plans/<feature>.md  a piece of child-repo work: you sign it, the agent ships it, you verify it, plan done removes it
.agents/memory/sessions/           one short log per agent session
projects/                          the child repositories (gitignored)
```

## Get started

```bash
./workspace.sh setup                   # wires the safety hook
# edit catalog/repos.yaml              # child repos: access level, product
./workspace.sh clone                   # fleet appears under projects/
./workspace.sh doc init <product>      # docs/<product>/index.md
./workspace.sh doc add <product> <module>   # a module — or a repository doc when the name is a manifest id lowercased
./workspace.sh ingest <product> <file> # REPO=<id> files it under that repository's sources/
```
Add a **private remote** and push — the memory must survive a dead disk.

## Daily loop

Agent: `check` → read `docs/<product>/` → work → log → commit. You: review the diff; sign a plan (`Signed: <name> — <date>` in its header) before the agent writes a child; write `Verified: <name>` when you have checked the result; then `./workspace.sh plan done <product> <feature>` clears the plan, its logs and the documents only it used.

| Command | Does |
|---|---|
| `check` | structure, line caps, plan headers, derivatives, the main/organization split — runs at every commit |
| `doc init` · `doc add` · `doc rm` | create and remove index / module / repository docs, keeping `index.md`'s links |
| `plan new` · `plan done` · `plan rm` | open a draft plan; remove a verified or abandoned one — or any (`rm`, `--force` for a signed/shipped one) — with its logs and the sources only it used |
| `ingest` · `extract` · `prune` | documents in (originals gitignored, text tracked); text nothing cites out |
| `cite` · `restore` · `clone` | the fleet as one citation line; check a citation out; rebuild the fleet |

Line caps (`check` fails above them; lines counted wrapped at 100 columns): index 80 · module 150 · repository doc 100 · plan 80 · log 40.

## One boilerplate, many organizations

`main` is the boilerplate. Each organization works on its own branch (or fork) and syncs with `git rebase main`, then `./workspace.sh check`. Rules and infrastructure change on `main` only, name no organization, and are recorded one line each in [CHANGELOG.md](CHANGELOG.md); an organization's branch changes only `catalog/`, `docs/` and its own logs. Branch `v1` keeps the previous rules; the migration is in `CHANGELOG.md` › v2.

# docs/ — the knowledge system and the write gate

`BLUEPRINT.md`, beside this file, is the design rationale for the whole
repository — read it first. Everything else here is agent-written
(human-supplied documents are not in `docs/`: their text lives in
`../sources/<scope>/`, their originals in the store — see `../AGENTS.md`):

```
docs/
├── <scope>.md                    ← one document per scope: a product or system a human names
├── <scope>/<topic>.md            ← growth only: examined Body topics moved out; the root stays
└── plans/<scope>--<feature>.md   ← discussion → 🚦 signature → execution
```

## Scopes

A **scope** is a product or a cross-cutting system a human names when
assigning work — never a repository, never a feature. Ids are lowercase kebab
(`[a-z0-9]+(-[a-z0-9]+)*`), immutable handles (the H1 carries the display
name); `readme`, `blueprint`, `plans`, `sources`, `workspace` are reserved. A
repo's home scope is its `scope:` in `../catalog/repos.yaml`, default the repo
id. An agent creates `docs/<scope>.md` for a scope the task names, or for a
repo's id when no scope is named; it never invents a product boundary or a new
system — it files under the nearest existing scope and proposes the id in its
log's TODO. `workspace` is this repository's own scope: `docs/workspace.md`
holds findings about its mechanics; its rationale is `BLUEPRINT.md`, its
mechanics `../README.md`, its history `../CHANGELOG.md`. References name ids,
never paths (`scope auth`, `plan ledger--refund-sync`).

## Scope documents — intake and examined body

`docs/<scope>.md` has three parts:

1. **Body** — purpose & framing, current architecture, and other examined
   facts about the system (integration points with other scopes, how it is
   run and tested, its terms): only claims that passed the examination bar.
   Factual claims carry `<repo>@<sha>` citations; claims about what a document
   states carry `sources/…@<blob>` citations.
2. **Changes** — append-only (entry format per the header of `../CHANGELOG.md`,
   one heading level down).
3. **Open findings** — the intake tray, appended as work happens: each finding
   with full evidence (`<repo>@<sha>` + file + symbol, or
   `sources/<scope>/<name>.<ext>.md@<blob>` + locator for documents, evidence
   type, confidence, unresolved questions). A finding about how repos interact
   cites every involved repo from one `./workspace.sh cite` output — the full
   fleet line when its dependency surface is uncertain. Findings never enter
   the body directly. A finding that feeds a plan is prefixed `[<feature>]`,
   spelled as in the plan's filename. A finding is filed once: under the scope
   the task named; else under the home scope of the repo it cites; an
   interaction between scopes neither of which was named goes to the scope
   whose repo exposes the called interface. The provider scope owns a contract
   (its Body › Consumers cites each consumer's use site); the consumer scope
   owns its own usage (Body › Integration points, referring to the provider by
   id).

## The examination bar (promotion from Open findings into the body)

A claim is promoted only after being carefully and analytically examined:

1. **Re-verified against source** at the moment of promotion — in `projects/`
   for code claims; for document claims `git hash-object` of the cited
   derivative still equals the cited blob (or the difference is re-read); the
   promoted claim keeps (or updates) its `<repo>@<sha>` / `…@<blob>` citation.
2. **Direct or corroborated evidence at high confidence** — inferred,
   unverified, or low-confidence findings stay in Open findings with their
   unresolved questions.
3. **Re-examined when reality moves** — if a cited repo's current HEAD differs
   from a claim's cited sha, re-verify the claim before trusting or extending
   the document. To see exactly what a finding described, paste its
   `<repo>@<sha>` citations after `./workspace.sh restore`; return with
   `restore <repo>`. For a document, reality moves when the derivative's
   `hash-object` differs from the cited blob or a newer dated edition sits
   beside it; `git show <blob>` shows exactly what was read.

Superseded, refuted or promoted findings are struck with an appended note —
never deleted. (Scope of the bar: it governs scope documents. `BLUEPRINT.md`
and this README are the governance texts themselves; plans are gated by the
signature below, though a plan's factual premises should meet the bar. When
two sessions in a row record that a scope document's size got in their way,
move its largest examined Body topic, verbatim, into `docs/<scope>/<topic>.md`
(H1 `# <scope>/<topic> — purpose`; named for the subsystem, never a feature),
leave `→ see <scope>/<topic>.md` under the vacated heading and record the move
in Changes; the root `docs/<scope>.md` never moves and keeps Changes and Open
findings — a growth trigger, not a day-one structure.)

## The signature gate

A plan authorizes child-repo work only after a human adds, inside the file:

    Signed: <name> — <YYYY-MM-DD>

⛔ No write of any kind to a child repository before that line exists.

A plan lives at `docs/plans/<scope>--<feature>.md` under its lead scope — the
scope the task named, else the one whose repos it mainly writes — with
`Scope: <lead>` under the H1 and `Scopes: <lead>, <other>…` when it touches
several (each other scope receives a Changes entry when it ships). Lifecycle
lines are appended, never overwritten: `Signed:` (human),
`Shipped: <YYYY-MM-DD> — <repo>@<sha>…` (agent; the landed commits),
`Abandoned: <YYYY-MM-DD> — <reason>`. Plans are never renamed or moved.

## Writing rules

- Append or update; **never delete history**. Corrections are appended notes,
  not overwrites.
- Session logs (`.agents/memory/sessions/`) hold the *journey* only; every
  finding and all documentation live here, in the docs system.
- A verbatim move recorded in Changes is the only sanctioned relocation of
  text; citations name repositories, never document paths, so no move can
  break evidence.
- Files under `../sources/` are generated by `workspace.sh extract` only (a
  restricted document via `RESTRICTED=<name>`); a bad extraction is fixed by
  re-running it, never by editing the derivative; a superseded document gets a
  new dated file and the old derivative stays; removal or re-scoping of a
  derivative is a human commit; each ingest appends a Changes entry (files,
  as-received names or URLs, provenance, supersessions,
  `NOT ingested: … lives at …`).

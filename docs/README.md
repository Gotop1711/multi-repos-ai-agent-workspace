# docs/ — the knowledge system and the write gate

`BLUEPRINT.md`, beside this file, is the design rationale for the whole
repository — read it first. Everything else here is agent-written
(human-supplied documents enter only through `workspace.sh ingest`: their
text under `<scope>/sources/`, their originals in gitignored `assets/<scope>/`):

```
docs/
├── <scope>.md                    ← one document per scope: a product or system a human names
├── <scope>/<topic>.md            ← growth only: examined Body topics moved out; the root stays
├── <scope>/sources/[<repo>/]<name>.<ext>.md ← human-supplied documents as text (ingest / extract output only; removed with the original once no document cites it); <repo> = a manifest id lowercased, for a document that is evidence about one fleet repo
├── assets/<scope>/[<repo>/]<name>.<ext>   ← their originals, copied in by ingest; gitignored, never committed; an original no derivative names (orphan) is removed at closeout
├── workspace/<topic>.md          ← the workspace's own specifications (document layer, scope grammar)
└── plans/<scope>--<feature>.md   ← child-repo work only: discussion → 🚦 signature → execution
```

## Scopes

A **scope** is a product or a cross-cutting system a human names when
assigning work — never a repository, never a feature. Ids are lowercase kebab
(`[a-z0-9]+(-[a-z0-9]+)*`), stable handles (the H1 carries the display
name; an id changes only when the owner names the product differently, and
then by the rename rule below, never by a second document); `readme`, `blueprint`, `plans`, `sources`, `assets`, `workspace` are reserved. A
repo's home scope is its `scope:` in `../catalog/repos.yaml`, default the repo
id. An agent creates `docs/<scope>.md` for a scope the task names, or for a
repo's id when no scope is named; it never invents a product boundary or a new
system — it files under the nearest existing scope and proposes the id in its
log's TODO. `workspace` is this repository's own scope: `docs/workspace.md`
holds findings about its mechanics; its rationale is `BLUEPRINT.md`, its
mechanics `../README.md`, its history `../CHANGELOG.md`, and its detailed
specifications — the document layer, the scope grammar — are
`docs/workspace/<topic>.md`, adopted by the owner's instruction and recorded
in `../CHANGELOG.md`, never gated by a signature (`docs/plans/` holds only
plans that authorize child-repo work). References name ids,
never paths (`scope auth`, `plan ledger--refund-sync`).

**Rename, never a tombstone.** When the owner names a scope that an existing
document already covers — typically a product scope replacing a document
created under a repo id — the document is renamed, not superseded, in one
commit: `git mv docs/<old>.md docs/<new>.md` (and `docs/<old>/` to
`docs/<new>/` if split); H1 and the manifest `scope:` keys updated; plans
`git mv`ed to `docs/plans/<new>--<feature>.md` with an appended
`Renamed: <YYYY-MM-DD> — from <old>--<feature>` line; documents re-extracted
under `<new>/sources/` after `mv docs/assets/<old> docs/assets/<new>` (gitignored
copies, no git involved). Afterwards the old id exists nowhere
in `docs/`; session-log filenames keep it, as history. Git keeps the moved
file's history and citations never name document paths, so no evidence
breaks. Declaring `scope:` keys for every repo of a multi-repo product when the
fleet is declared avoids most renames.

## Scope documents — intake and examined body

`docs/<scope>.md` has two parts, and both are **maintained state** — git is
the document's history (`git log -- docs/<scope>.md`), the scope's session
logs are its journey, and one `History:` line under the title says so:

1. **Body** — purpose & framing, current architecture, and other examined
   facts about the system (integration points with other scopes, how it is
   run and tested, its terms): only claims that passed the examination bar.
   Factual claims carry `<repo>@<sha>` citations; claims about what a document
   states carry `docs/<scope>/sources/…@<blob>` citations.
2. **Open findings** — the intake tray: each finding
   with full evidence (`<repo>@<sha>` + file + symbol, or
   `docs/<scope>/sources/[<repo>/]<name>.<ext>.md@<blob>` + locator for documents, evidence
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

A promoted finding is deleted from the tray once its content is in the Body;
a refuted or superseded one is deleted outright — and if the refutation proved
a positive fact ("X is by design"), that fact becomes a Body claim so the
finding is not re-filed. Finding ids are never reused; the session that deletes
one updates any live reference to it (a plan, another scope, a Body sentence);
`git log -S 'F<n> —' -- docs/<scope>.md` recovers the text. (Scope of the bar: it governs scope documents. `BLUEPRINT.md`
and this README are the governance texts themselves; plans are gated by the
signature below, though a plan's factual premises should meet the bar. When
two sessions in a row record that a scope document's size got in their way,
move its largest examined Body topic, verbatim, into `docs/<scope>/<topic>.md`
(H1 `# <scope>/<topic> — purpose`; named for the subsystem, never a feature),
leave `→ see <scope>/<topic>.md` under the vacated heading; the root
`docs/<scope>.md` never moves and keeps the Open findings — a growth trigger,
not a day-one structure.)

## The signature gate

A plan authorizes child-repo work only after a human adds, inside the file:

    Signed: <name> — <YYYY-MM-DD>

⛔ No write of any kind to a child repository before that line exists.

A plan lives at `docs/plans/<scope>--<feature>.md` under its lead scope — the
scope the task named, else the one whose repos it mainly writes — with
`Scope: <lead>` under the H1 and `Scopes: <lead>, <other>…` when it touches
several (when it ships, each other scope's Body › Integration points is
updated to what now exists). Lifecycle
lines are appended, never overwritten: `Signed:` (human),
`Shipped: <YYYY-MM-DD> — <repo>@<sha>…` (agent; the landed commits),
`Abandoned: <YYYY-MM-DD> — <reason>`. Plans are renamed only together with
their scope id (Scopes › rename), never otherwise moved.
A proposal about the workspace itself is not a plan: it starts in
`docs/workspace.md` Open findings and the log's TODO, and once the owner adopts
it, its specification lives in `docs/workspace/<topic>.md` with a `Status:`
line under the H1 and a `../CHANGELOG.md` entry.

## Writing rules

- **Maintain, don't accumulate.** Body and Open findings are rewritten in
  place whenever a session finds them stale, and pruning what is obsolete is
  part of every closeout that touches a scope document. Nothing is kept in a
  document because it used to be true: git is the document's history, the
  session logs are the journey, `../CHANGELOG.md` is the workspace's own
  release history. The examination bar is unchanged — a Body claim is still
  promoted only after re-verification at source.
- Session logs (`.agents/memory/sessions/`) hold the *journey* only; every
  finding and all documentation live here, in the docs system.
- Text moves between documents only verbatim (a split, a rename), with a
  pointer left under the vacated heading; citations name repositories and
  blobs, never document paths, so no move can break evidence.
- Files under `<scope>/sources/` are generated by `workspace.sh ingest` or `extract`
  only (a restricted document via `RESTRICTED=<name>`); a bad extraction is fixed by
  re-running it, never by editing the derivative; a new edition is a new dated
  file. A derivative is **needed** only while a *live* document under `docs/`
  outside `sources/` cites it by its full file name — a scope document, a
  specification, or a plan that has not yet shipped. Session logs are journey
  and do not count, and neither does a plan carrying `Shipped:` or
  `Abandoned:`: its knowledge has dissolved into the Body (Scopes › the
  signature gate; `docs/workspace/scope-grammar.md` §6), so what keeps the
  document alive from then on is the Body claim or finding that uses it. One
  nothing cites any more — its findings promoted or deleted, its edition
  superseded, its scope re-filed, its plan shipped — is removed at closeout,
  `git rm` for the derivative and `rm` for its original, by agents and humans
  alike; `check` lists them. Git keeps the text, and a cited blob still
  resolves with `git show`. Provenance lives in the derivative's header
  (`source:`, `sha256:`, `received:`) and, for the narrative — where the files
  came from, what was not ingested and why, which edition supersedes which —
  in the ingesting session's log.

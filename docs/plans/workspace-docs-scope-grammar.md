# Plan — governing `docs/`: scope-first, with a naming grammar

Scope: workspace
Status: discussion — **unsigned**. Nothing below has been applied; every rule
edit in §9 is outside the agent write surface and waits for a human.
Observed at: workspace@8e4db92 (this repository's HEAD when analysed).
Origin: 2026-09-03 session (log `2026-09-03-claude-workspace-analyze-and-document-layout.md`);
four independent designs (scope-first, feature-first, kind-first, hybrid), each
refuted by a rules-conformance critic and a two-year scaling critic, then
synthesised. Mechanical claims marked *(verified)* were re-run under zsh on
this machine in gitignored `.agents/scratch/`.

## 1. The question and the answer

**Question.** Should `docs/` be organised by feature, by product/project,
both, or something else?

**Answer.** By **scope** — a product or a cross-cutting system a human names
when assigning work — not by feature, not by document kind, not by repository.

- **Scope = the folder axis.** One document per scope, `docs/<scope>.md`.
  Products (`storefront`, `ledger`) and cross-cutting systems (`auth`,
  `observability`, `data-platform`) are both scopes with identical rules.
- **Feature = a filename token and a tag, never a folder.** A feature is
  `docs/plans/<scope>--<feature>.md` plus `[<feature>]`-tagged findings in
  its scope's Open findings. When it ships, its knowledge dissolves into the
  scope's examined Body; the feature name survives in the plan, the Changes
  entry and the tags.
- **Document kind = a heading, never a file.** Architecture, integration
  points, operating facts, terms are Body subsections. Decisions already have
  homes: a decision that authorises child work *is* the plan; a conclusion
  about the system is a promoted Body claim plus a Changes entry; a journey
  decision is the session log's Decisions & pitfalls.
- **Repository = the evidence axis.** `<repo>@<sha>` on every claim
  (AGENTS.md:55-57). A repo maps to its home scope through an optional
  one-token `scope:` key in `catalog/repos.yaml`, default = the repo id.

Rule of thumb: *folder = what a human names; feature = `--<feature>` in a
filename and `[feature]` in a tag; kind = a heading; repo = a citation.*

Why the alternatives lost:

- *Feature-first*: feature names are transient judgements that collide across
  products and sprawl without anyone deciding; the machinery needed to contain
  that (headers, hubs, aliases, `depends-on:`) is the deferred catalog of
  BLUEPRINT.md:113/133 relocated into every file.
- *Kind-first* (`architecture/`, `decisions/`, `runbooks/`): overturns
  BLUEPRINT.md:139, doubles the mandatory session-start read (AGENTS.md:18),
  and creates second homes for "why" (beside TEMPLATE.md:14-16) and for how-tos
  (beside the skills trigger, BLUEPRINT.md:110).
- *Repo-first*: forces every task to first derive which repos serve the
  product — the re-derivation this workspace exists to stop — and has no home
  for interaction claims (AGENTS.md:62-65).
- *Scope-first* is what the text already assumes (docs/README.md:8;
  TEMPLATE.md:3-4; AGENTS.md:18). It needs only a naming grammar, a filing
  rule and a split rule to become governable.

## 2. What a scope is, who registers one

A scope is a bounded system that (1) a human names in a sentence when
assigning work, (2) has a describable architecture, (3) persists across the
features that pass through it. Two kinds, one grammar: **product** (1..n
repos) and **system** (a cross-cutting concern owning 0..n repos; a pure
convention with no home repo is still a scope, documented through its
consumers' repos).

**Id grammar.** `<id> := [a-z0-9]+(-[a-z0-9]+)*` — lowercase kebab, no `_`
`.` `/`, never two hyphens in a row (so `--` cannot occur inside an id). The
same class serves scope ids and feature ids. Reserved: `readme`, `blueprint`,
`plans`, `sources`, `workspace`. A scope id is an immutable handle; a product
rename changes the H1 display name, never the id or any filename.

**Repo ↔ scope binding — one place, one direction.** Each entry in
`catalog/repos.yaml` may carry `scope: <id>` (single token, optional,
informational like `owner:` at catalog/repos.yaml:15). Absent, the scope id
is the repo id. One home scope per repo; a monorepo hosting code for two
systems has one home and the other scope's document cites it by path. Scope
documents carry no `Repos:`/`Related:`/`Aliases:` header lines — the inverse
map is derived (§7), so nothing drifts. *(verified: an unmodified
`workspace.sh check` passes with a `scope:` key present.)*

**Who creates a scope.** The human, by naming a product in a task or adding
`scope:` keys. An agent may create `docs/<id>.md` (skeleton in §5) for a
scope the task names, or — with no scope named — for the **repo id** of the
repo it analyses (removes the bootstrap deadlock of an empty fleet). An agent
never invents a product boundary spanning repos or a new cross-cutting
system: it files under the nearest existing scope and proposes the id in its
log's TODO. The live registry is `ls docs/`; its history is git. No registry
file.

**`workspace`.** The synthesis proposed `workspace` as a log tag only, with
`BLUEPRINT.md`, `README.md` and `CHANGELOG.md` as its documents. Amendment
recorded here: findings *about the workspace's own mechanics* (defects in
`workspace.sh`, rule contradictions) still need an Open-findings tray with
evidence, which those three files cannot hold. Keep `docs/workspace.md` as the
workspace's own scope document for exactly that; workspace-level *proposals*
still go to the log's TODO and, when substantial, to an unsigned
`docs/plans/workspace--<topic>.md` such as this one.

## 3. Naming grammar

```
docs/<scope>.md                          the scope document — always exists for a live scope; NEVER moves
docs/<scope>/<topic>.md                  growth only: an examined Body topic moved out, named for the SUBSYSTEM
                                         (checkout.md, operating.md), never for a feature; H1 = "# <scope>/<topic> — purpose"
docs/plans/<scope>--<feature>.md         plan; <scope> = LEAD scope (the one the task named, else the one whose
                                         repos it mainly writes). Header lines under the H1:
                                           Scope: <lead>          Scopes: <lead>, <other>…  (only when it touches several)
                                           Signed: <name> — <YYYY-MM-DD>            (human; docs/README.md:52, unchanged)
                                           Shipped: <YYYY-MM-DD> — <repo>@<sha>…    (agent; the landed commits)
                                           Abandoned: <YYYY-MM-DD> — <reason>
                                         lifecycle lines are appended, never overwritten; plans are never renamed or moved
.agents/memory/sessions/YYYY-MM-DD-<agent>-<scope>--<task>.md
                                         <scope> = lead scope id or workspace; <task> = the feature id when the task is one
catalog/repos.yaml   scope: <id>         optional single token; default = the repo id
finding entry        - [<feature>] <claim> — <repo>@<sha> <file> <symbol>; <evidence type>; <confidence>; Q: …
                                         tag only when the finding feeds a plan; spelled exactly as the plan's <feature>
cross-reference      by id, never by path: "scope auth", "plan ledger--refund-sync", "Body › Checkout"
```

`--` is the one separator between a scope and whatever follows it. Because
ids cannot contain `--`, `docs/plans/data-platform--schema-registry.md` and
`2026-09-14-claude-data-platform--schema-audit.md` tokenise exactly
*(verified: `grep -- '-data--'` matches nothing; `-- '-data-platform--'`
matches the one file)*. This fixes the kebab-in-kebab ambiguity of today's
`plans/<scope>-<feature>.md` (docs/README.md:9). Zero migration cost: no
plans or product logs exist yet.

Examples:

1. Single-repo product, no key: repo `ledger` → `docs/ledger.md`; log
   `2026-09-20-claude-ledger--multi-currency.md`.
2. Product whose name differs from its repo: `admin-console` carries
   `scope: admin` → `docs/admin.md`.
3. Product spanning three repos: `storefront-web`, `storefront-api`,
   `storefront-infra` each `scope: storefront` → one `docs/storefront.md`;
   claims cite the repo: `storefront-api@a1b2c3d src/cart/total.ts recompute`.
4. Cross-cutting system with home repos: `platform-auth` carries
   `scope: auth` → `docs/auth.md`; Body › Consumers cites each product's use
   site from one `cite` line.
5. Cross-cutting system with no home repo: `docs/logging.md`, created when a
   human names it; every claim cites a consumer repo.
6. Feature plan: `docs/plans/storefront--checkout-v2.md`; findings tagged
   `[checkout-v2]` in `docs/storefront.md`.
7. Cross-product plan: `docs/plans/ledger--refund-sync.md` with
   `Scope: ledger` / `Scopes: ledger, storefront`; found from storefront by
   `grep -l '^Scopes:.*storefront' docs/plans/*.md`.
8. Split scope: `docs/storefront.md` stays (framing, pointers, Changes, Open
   findings) + `docs/storefront/checkout.md`, `docs/storefront/operating.md`.
9. Workspace session: `2026-09-12-claude-workspace--scope-grammar.md`.
10. A second change to a shipped subsystem: `docs/plans/storefront--checkout-express.md`;
    its as-built truth folds into `docs/storefront/checkout.md`, never a new file.

## 4. Example tree (8 repos, 3 products, 2 systems, 12 features, ~month 8)

```
catalog/repos.yaml
  - id: storefront-web        scope: storefront
  - id: storefront-api        scope: storefront
  - id: storefront-infra      scope: storefront     (access: read-only)
  - id: admin-console         scope: admin
  - id: ledger                                      (no key → scope ledger)
  - id: platform-auth         scope: auth
  - id: platform-mono         scope: auth           (also hosts observability code; observability.md cites it by path)
  - id: otel-collector-config scope: observability

docs/
├── README.md, BLUEPRINT.md            governance texts
├── workspace.md                       the workspace's own scope document (findings about its mechanics)
├── admin.md                           product, unsplit: Body / Changes / Open findings
├── ledger.md                          product, unsplit; id == repo id
├── auth.md                            system; Body › Architecture (contract) + Body › Consumers
├── observability.md                   system
├── storefront.md                      product, SPLIT: framing, "→ see storefront/checkout.md" pointers, Changes, Open findings
├── storefront/
│   ├── checkout.md                    examined Body topic (checkout-v2 and guest-cart dissolved into it)
│   ├── search.md                      examined Body topic
│   └── operating.md                   examined how-to: run / test / deploy, each step cited
└── plans/
    ├── storefront--checkout-v2.md     Signed + Shipped
    ├── storefront--guest-cart.md      Signed + Shipped
    ├── storefront--image-cdn.md       unsigned (discussion)
    ├── storefront--unified-search.md  Scopes: storefront, admin
    ├── admin--bulk-import.md
    ├── ledger--multi-currency.md
    ├── ledger--refund-sync.md         Scopes: ledger, storefront
    ├── auth--token-refresh.md
    ├── auth--sso-okta.md
    └── observability--trace-sampling.md
```

`ls docs/` is the index. Nothing in this tree exists before a finding needs
it (BLUEPRINT.md:82).

## 5. Document shape (three parts, unchanged; one skeleton)

```
# <scope> — <display name / one-line purpose>

## Body
### Purpose & framing
### Architecture                 (subsections per subsystem — the pre-split form of a topic file)
### Integration points           (products: how this scope uses other scopes, by id)  |  ### Consumers (systems)
### Operating                    (run / test / deploy facts, each cited)
### Terms

## Changes                       (append-only; CHANGELOG.md:4 format one heading level down)

## Open findings                 (the intake tray; struck with a note, never deleted)
```

Headings are recommended, not mandated — the bar, not the headings, protects
quality (BLUEPRINT.md:139). Kinds map to sections: architecture → Body ›
Architecture (after a split, `docs/<scope>/<subsystem>.md`); runbooks about
the product → Body › Operating; agent procedure → a skill when it repeats;
glossary → Body › Terms per scope (a definition is a claim and carries a
citation); findings → the root's Open findings only; Changes → the root only.

## 6. Features

**Before**: `[<feature>]`-tagged findings in the lead scope's tray; once worth
discussing, an unsigned `docs/plans/<scope>--<feature>.md`. The first spelling
of the feature id wins. A feature needing no child-repo write has no plan.

**During**: `Signed:` present. New findings keep flowing to the tray of the
scope they are about, tagged. The log is `…-<lead>--<feature>.md`.

**After**: append `Shipped: <date> — <repo>@<sha>…`; a Changes entry in the
lead scope and a pointer entry in every other `Scopes:` scope; re-verify the
feature's claims at the shipped sha and promote them into Body › Architecture
under the **subsystem's** heading (`### Checkout`, never `### Checkout v2`),
striking each promoted finding with `→ promoted to Body › <section> <date>`.
Abandoned: `Abandoned: <date> — <reason>`.

**Spanning scopes**: one lead; `Scopes:` lists the rest; interaction findings
are filed once, under the lead, citing every involved repo from one `cite`
run. A feature that outlives its ship date as a nameable system across
products is promoted to a scope by a human; the plan stays where it was filed.

## 7. Cross-cutting concerns, filing rule, discoverability

Provider owns the contract (Body › Architecture) and Body › Consumers (one
interaction claim per consumer, citing both repos from one `cite` line).
Consumer owns its own usage (Body › Integration points, referring to the
provider by id). Filing rule, in order: (1) the scope the task named; (2) the
home scope of the cited repo; (3) an interaction neither side named → the
scope whose repo exposes the called interface. Never file a claim twice; no
pointers in Open findings. Producer-side discovery is free: `grep -rln
'<repo>@' docs` lists every document that says anything about that repo.

One-hop commands, shell-independent *(verified under zsh; no bare globs —
zsh aborts `ls a b/*` when a pattern is empty, which is every unsplit scope)*:

```
ls docs | grep -v -E '^(README|BLUEPRINT)\.md$|^plans$'      # the scope ids
cat docs/Y.md; [ -d docs/Y ] && awk 'FNR==1' docs/Y/*.md      # the scope document + topic map if split
ls docs/plans | grep -- '^Y--'                                 # Y's plans;  … | grep -- '--X'  → the plan for X wherever it leads
grep -l '^Scopes:.*Y' docs/plans/*.md                          # plans led elsewhere that touch Y
grep -n '\[X\]' docs/Y.md                                      # X's findings
grep -rln '<repo>@' docs                                       # everything that cites a repo
ls .agents/memory/sessions | grep -- '-Y--' | tail -3          # Y's last three sessions
awk '/^- id:/{if(id!="")print id" -> "(s==""?id:s); id=$3; s=""} /^[[:space:]]+scope:/{s=$2} END{if(id!="")print id" -> "(s==""?id:s)}' catalog/repos.yaml   # repo → scope
grep -L '^Signed:' docs/plans/*.md                             # unsigned plans (the gate audit)
```

## 8. Split, rename, move

**Split (file → sibling folder).** Trigger, bite-twice: two sessions in a row
record in their logs that they needed one Body section and paid for the whole
document (~500 lines is a hint, not the trigger). Mechanics, inside the
closeout commit: create `docs/<scope>/<topic>.md` with the section text moved
**verbatim**; leave `→ see <scope>/<topic>.md` under the vacated heading;
record the move in the root's Changes; largest topic first, one at a time. The
root never moves; Changes and Open findings never leave it; depth stops at one
level. Citations name repositories, never document paths, so no move breaks
evidence.

**Scope rename.** Display name: edit the H1. Id change (merger/split of
products): create the successor(s); append `Superseded by scope <new> — <date>`
under the old H1; re-file open findings by appending to the successor and
striking in the old; the human updates `scope:` keys; the old file stays as
the tombstone. **Repo moves under a stable scope**: only `scope:` changes;
repo ids never change (`restore` resolves ids through the manifest,
workspace.sh:101-103). **Feature rename**: avoided; if unavoidable, a new plan
with `Supersedes: plan <scope>--<old>` and `Abandoned: … renamed to <new>` on
the old.

## 9. Exact minimal rule edits (human-applied, one commit, CHANGELOG entry)

- **docs/README.md:6-10** — tree becomes `<scope>.md` (one document per scope:
  a product or system a human names), `<scope>/<topic>.md` (growth only:
  examined Body topics moved out; the root stays), `plans/<scope>--<feature>.md`.
- **docs/README.md:12** — insert before "has three parts": the scope
  definition of §2 (what a scope is; id grammar; reserved ids; `scope:` hint
  defaulting to the repo id; who creates one; references name ids, never paths).
- **docs/README.md:16-17** — Body = "purpose & framing, current architecture,
  and other examined facts about the system (integration points, how it is run
  and tested, its terms)".
- **docs/README.md:18** — Changes format "one heading level down".
- **docs/README.md:19-24** — append the `[<feature>]` tag rule and the filing
  rule of §7.
- **docs/README.md:41-46** — "Superseded, refuted or promoted findings are
  struck"; replace the split sentence with the §8 split rule (root never moves).
- **docs/README.md:48-54** — append the plan location `docs/plans/<scope>--<feature>.md`,
  the `Scope:`/`Scopes:` lines, and the appended lifecycle lines `Shipped:`/`Abandoned:`.
- **AGENTS.md:16-17** — also read the newest 3 logs of the task's scope
  (`ls .agents/memory/sessions | grep -- '-<scope>--' | tail -3`).
- **AGENTS.md:18** — "If the task names a scope (`ls docs/`; a repo's scope is
  its `scope:`, default the repo id), read `docs/<scope>.md` and, if
  `docs/<scope>/` exists, the topic files the task needs; for a feature also
  `docs/plans/<scope>--<feature>.md`."
- **AGENTS.md:22** — session-log name `YYYY-MM-DD-{agent}-{scope}--{task}.md`.
- **AGENTS.md:26-28** — "Record findings in the owning scope's `docs/<scope>.md`
  (filing and tag rules in `docs/README.md`; never coin a product or system id —
  propose it in the log's TODO)".
- **.agents/memory/sessions/TEMPLATE.md:3-4** — same filename change; `{scope}`
  = the lead scope id (existing or created this session) or `workspace`;
  `{task}` = the feature id when the task is one.
- **docs/BLUEPRINT.md:77** — manifest line: "optional `scope:` per repo names
  its home scope document (default: the repo id)".
- **docs/BLUEPRINT.md:82-83** — tree lines for `docs/<scope>.md` (never
  moves), `docs/<scope>/<topic>.md` (growth only), `docs/plans/<scope>--<feature>.md`.
- **docs/BLUEPRINT.md:113** — catalog knowledge "keyed by the same scope ids as
  `docs/`; the glossary trigger is the same term defined differently in two
  scopes' Terms sections".
- **docs/BLUEPRINT.md:115** — the split row becomes the §8 rule.
- **docs/BLUEPRINT.md §4** — three new rows: aliases line / scope table at
  ~25 scopes; `docs/<scope>/archive.md` when a tray is dominated by struck
  entries twice; a ~10-line `check` extension (warn on unbound `scope:`, fail
  on a filename token outside the id grammar) when it bites twice.
- **docs/BLUEPRINT.md:139** — Why cell: "after a growth split only examined
  Body topics become files — the intake and Changes stay in the root".
- **catalog/repos.yaml:15** — add the commented `scope:` example line.
- **workspace.sh:137** — `(path|remote|default_branch|access|scope):` so the
  key that ships is validated *(verified: `scope: admin console` then fails
  `check`; clean values pass)*.
- **CHANGELOG.md** — `## [Scope grammar for docs/] — <date>` / Changed.

## 10. Relation to the document layer

The human-supplied-sources layer (plan `workspace--document-layer`) keys on
the same scope ids and lives at top-level `sources/<scope>/`, outside
`docs/` — `docs/` stays agent-written. The name `sources` is reserved at every
level of `docs/` so nothing collides.

## 11. Growth triggers (bite twice) and accepted tradeoffs

| Pain (twice) | Add |
|---|---|
| Size of one scope document got in a session's way | `docs/<scope>/<topic>.md`, root stays |
| A product word failed to resolve / `ls docs/` past one screen | `Aliases:` line; scope table at ~25 scopes |
| Tray dominated by struck findings | `docs/<scope>/archive.md`, verbatim roll |
| Unbound `scope:` or unregistered filename token | `check` extension |
| Same relationship re-derived (BLUEPRINT.md:113) | `catalog/systems.yaml` etc., keyed by scope ids |

Accepted: cross-product features file under one lead (others see a `Scopes:`
grep and a shipped Changes pointer); feature-centric questions are a plan + a
tag grep + a log grep, never one folder; a wrong early scope boundary costs a
tombstone and re-filing; provider/consumer filing is a prose rule until it
bites; `Shipped:`/`Abandoned:` ship ahead of a bite because `docs/plans/` is
unreadable at ten files without them and the cost is one line.

## 12. Rejected in the synthesis (so they are not re-proposed)

Multi-valued `scopes: a,b` plus `Repos:/Related:/Aliases:` headers (the same
binding in three places); `docs/plans/<scope>/` folders (changes the red-line
directory and breaks `grep -L '^Signed:' docs/plans/*.md`);
`docs/plans/workspace/` as an ungated plan class (this plan is instead an
ordinary unsigned plan); `docs/fleet.md` as a catch-all; ADR/runbook kinds,
finding ids, `proposed` scopes, product hubs, YAML frontmatter (day-one
structure with no bite); a line-count split trigger and `git mv` of the root;
pointer stubs in a consumer's Open findings.

## 13. Questions for the human (they change the layout)

1. Do several child repositories together form one product? If yes, add
   `scope: <product>` on those entries on day one; if every repo is its own
   product, no `scope:` keys are needed.
2. Is there a cross-cutting system (auth, observability, data platform) to
   document as its own scope from the start — with a home repo in the fleet,
   or as a convention spread across product repos? Either is legal; the answer
   decides whether `docs/auth.md`-style documents are created by the first
   session or only when a task names them.

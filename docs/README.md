# docs/ — the knowledge system and the write gate

`BLUEPRINT.md`, beside this file, is the design rationale for the whole
repository — read it first. Everything else here is agent-written:

```
docs/
├── <scope>.md                   ← one document per product/area
└── plans/<scope>-<feature>.md   ← discussion → 🚦 signature → execution
```

## Scope documents — intake and examined body

`docs/<scope>.md` has three parts:

1. **Body** — purpose & framing and current architecture: only claims that
   passed the examination bar. Factual claims carry `<repo>@<sha>` citations.
2. **Changes** — append-only (entry format per the header of `../CHANGELOG.md`).
3. **Open findings** — the intake tray, appended as work happens: each finding
   with full evidence (`<repo>@<sha>` + file + symbol, evidence type,
   confidence, unresolved questions). Findings never enter the body directly.

## The examination bar (promotion from Open findings into the body)

A claim is promoted only after being carefully and analytically examined:

1. **Re-verified against source** in `projects/` at the moment of promotion;
   the promoted claim keeps (or updates) its `<repo>@<sha>` citation.
2. **Direct or corroborated evidence at high confidence** — inferred,
   unverified, or low-confidence findings stay in Open findings with their
   unresolved questions.
3. **Re-examined when reality moves** — if a cited repo's current HEAD differs
   from a claim's cited sha, re-verify the claim before trusting or extending
   the document.

Superseded or refuted findings are struck with an appended note — never
deleted. (Scope of the bar: it governs scope documents. `BLUEPRINT.md` and
this README are the governance texts themselves; plans are gated by the
signature below, though a plan's factual premises should meet the bar. When a
scope document outgrows one file, split it into a `docs/<scope>/` folder —
a growth trigger, not a day-one structure.)

## The signature gate

A plan authorizes child-repo work only after a human adds, inside the file:

    Signed: <name> — <YYYY-MM-DD>

⛔ No write of any kind to a child repository before that line exists.

## Writing rules

- Append or update; **never delete history**. Corrections are appended notes,
  not overwrites.
- Session logs (`.agents/memory/sessions/`) hold the *journey* only; every
  finding and all documentation live here, in the docs system.

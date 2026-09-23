# 2026-09-23 | claude | rea | data-creator-node-refactor

## Task
Owner, in three turns: the stack ruling was missed — Node.js, smallest architecture, no tests; record
the owner's TODOs as a plan, in Chinese; then three documents (定義、資料採集規則、產出規則) — ingest
them, write the rule kinds they define, verify the tool on the real exports.

## Done
- `@9b89624`: Python → five JavaScript files, same 71 bodies. `@e4eba57` `@dc509aa` `@369fbfc`
  `@d407653` `@c0ef280`: the owner's rules for 12 kinds on two shared collectors; 5 275 bodies,
  validate clean, 2 s; README terms verbatim. Sources ingested, then re-ingested in place when the
  owner re-issued two of them (group 1–4; 202's employmentType 01).
- Setup plan: Amended twice (stack; rules), Shipped twice. Acceptance plan (Chinese): verification,
  remote, four rulings. Repository doc rewritten; declare-verify: SaveWork validates against
  `workflow` alone, nothing reports that collection's dates.

## Decisions & pitfalls
- 101–104: the rules said 001–004, the export has 01–04; asked, the owner re-issued them as 1–4 and
  ruled "strip the leading zeros" — a string match after stripping, not a numeric one.
- 202: written only once the owner ruled employmentType 01; the value is a choice (專任 or not).
- 205/206 on 所有項目 as written: the generators never read `mainSetting` and compile 專任 for every
  醫令. The owner: record it, do not handle it.
- The start date is the host's answer, not the build's: `Payment/Detail/Get` reports `rule`'s dates,
  0001-01-01 when none; a Save overwrites or closes an existing version.
- Commits by source table, not one per rule kind: the reviewable unit is the shared collector.
- `Amended:` on the signed setup plan covers the rules; the acceptance plan stays draft and holds
  only what waits on a ruling. Its language is Chinese on the owner's word — do not "fix" it back.
- declare-verify sits at 299/300; the 205/206 fact went to the repository doc. Split Part 3 out
  before the next module fact.

## TODO
- Owner: the acceptance plan, steps 1–7; its `Signed:` before 303–307 / 401 are written.
- Earlier open items stand (REANC, architect, shell team, Keycloak). Push `rea` (owner's shell).

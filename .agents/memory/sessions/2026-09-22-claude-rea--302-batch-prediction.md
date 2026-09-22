# 2026-09-22 | claude | rea | 302-batch-prediction

## Task
Owner: given a batch of `POST Rule/Save` bodies, predict what REA_PROTO_BE's validation would
make of them — or say it cannot be done.

## Done
- First batch offered was 71 rows of NHIA's `MHCT_PAYLIMIT` (one per `TREAT_CODE`, filtered to rows
  with an `LMT_AGE_*` range). Grep: the prototype never reads that table; `TREAT_CODE` appears only
  as the key of `MHCT_PAYMENT` / `MHCT_PAYITEMS`. Translated the age columns to 302 configs by hand.
- Second batch was the real thing: 71 `Rule/Save` bodies, one 302 rule each, matching the table
  row for row (38 Y, 32 M, 1 D). Every `referenceDate` is null. Traced Save → SaveWork → job.
- declare-verify › What will surprise you: a rejected condition vanishes and the rule kind compiles
  to an empty `Or`; the job, not the save, fails on it (library behaviour marked inferred).
  `OperatorMin` / `OperatorMax` added to the stored-but-never-read list.

## Decisions & pitfalls
- Outcome is predictable only because it is degenerate: with no `referenceDate` no age check is
  ever compiled. With it, per-declaration results need Oracle rows — not predictable from here.
- RulesEngine 6.0.0 is not in the local nuget cache; its validator rule (operator ⇒ non-empty
  `Rules`) is cited from memory of the library source and labelled so in the module.
- `ruleEndDate` in the bodies binds to `Form.RuleEndDate` but is overwritten with MaxValue on
  insert; `updatedAt` and `expr` are UI strings the back end stores and ignores.
- The source table has its own oddities the batch inherits: `88` is 0–72 months where its
  siblings are 0–71; `57120B` (0–6 m) and `57121B` (6–23 m) overlap at month 6.

## TODO
- Owner: which `referenceDate` key(s) the 71 rules should carry (`applyDate`, `executionDate`,
  `admissionDate`; several are OR-ed). Then a `SaveWork` batch can be written to scratch.
- Earlier open items stand (REANC, architect, shell team, Keycloak). Push `rea`.

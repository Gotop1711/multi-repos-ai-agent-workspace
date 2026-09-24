# 2026-09-24 | claude | rea | 307-payload-fields

## Task
Owner, about to write the 307 rule (`MHCT_PAYLTYPE` type 16, group 001) in the data creator: which of
the five `rangeGroups` inputs can be filled from the 資料表檔, what the rest take, and which the back
end really checks. A question; the plan's step 7 carries the answer, nothing in the child changes.

## Done
- Read `IcdCodeRuleGenerator.cs` and `RangeGroup` (`REA_PROTO_BE@ba161ff`), the prototype's block 307
  (`REA_PROTO@3fdf47c tests/mock/api/rulesSpecificSetting.json`, `orderCodeDetail.json`), and profiled
  the type-16 rows of the export (`REA_PROTO_DATA_CREATOR@949e7c4 data/in`, gitignored).
- Acceptance plan step 7: the 307 facts and the five rulings the owner must give before it is written.

## Decisions & pitfalls
- The owner's screenshot slice misled: in the whole export `CNAME` ≠ `ENAME` on most rows — they are
  the range's start and end codes; `CNAME_1` / `ENAME_1` are the age columns the 欄位說明 names for
  type 16. So four of the five inputs come from the table; only `prefixRange` is derived.
- Validation is only `filterFields.Count > 0 && rangeGroups.Count > 0`; inside a group nothing is
  required, so a hollow group still compiles a rule that passes on any non-empty diagnosis — the
  collector must refuse an empty `CNAME` itself (`validate` does not look inside).
- `prefixRange` decides the comparison: integer → first-N-chars compare of both sides, else whole-
  string compare, where `"E1300" <= "E13"` is false and the end code's own children drop out. It must
  be the code length. Four rows have start and end of different lengths; the longer works.
- An empty `inputEnd` compiles only the lower bound — a single-code row written that way matches
  every code above it. `ENAME` empty must become `inputEnd` = `CNAME` if the owner reads it as one code.
- Repository doc at 99/100 and declare-verify at 299/300: the plan's step 7 took the facts.
- Month unit and the declaration's ICD format (dotted or not) are inferred, not seen; flagged.

## TODO
- Owner: the five 307 rulings in step 7; `Signed:` on the acceptance plan; then r307.js.
- [workspace] the repository doc and declare-verify are both one line under cap: split before the
  next fact lands.
- Earlier open items stand (REANC, architect, shell team, Keycloak). Push `rea` (owner's shell).

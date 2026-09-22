# 2026-09-22 | claude | rea | rea-proto-data-creator-shipped

## Task
Owner: the plan is signed — stdlib yes, exports out of git yes, 302 `referenceDate` = `executionDate`;
the schema xlsx of `MHCT_PAYLIMIT` and `MHCT_PAYLTYPE` given (the csv too big for chat). Ship it.

## Done
- `REA_PROTO_DATA_CREATOR@321dc12`: four commits as the plan's steps — scaffold, schema + validator,
  r302, build; 60 tests. On the real export: 71 bodies (38 Y, 32 M, 1 D) = the hand-made batch of the
  302-batch-prediction log, `validate` clean. `Shipped:` on the plan; repository doc
  rea-proto-data-creator; declare-verify: the one-code `ruleExpr` path and dangling placeholders.
- The xlsx are inline-string sheets (no sharedStrings): parsed with stdlib `zipfile` + `ElementTree`;
  committed as `schemas/*.csv` so rule docstrings can cite a column by number.

## Decisions & pitfalls
- The row in force has `LMT_E_DATE` = `2910-12-31`, not 9999: the first profile looked for 9999 and
  found nothing. The owner's `MHCT_PAYLIMIT_Data_302.json` (71 raw rows) confirmed the selection.
- The owner's "verbatim definitions" for the README were lost with the previous context; the README
  says so and uses the plan's wording — the owner may correct it.
- A rejected row is an error, not a skip: a 採集規則 never guesses (none in this export).
- `LMT_SEX` → 301 and `MHCT_PAYLTYPE`'s 19 `LMT_TYPE_CODE` values are the obvious next rules; they wait
  for the owner's mapping (plan step 5) and were not written.
- Group names follow the prototype UI (`群組1`, `constants.js:20`), not the mapper doc's example.
- The two exports were copied into the child's gitignored `data/in/` so the owner can run the build.
- No push: the child has no remote; `rea` is pushed from the owner's shell.

## TODO
- Owner: post one body to `Rule/Save` and `Rule/SaveWork` on the Azure host, run a `ValidationJob`,
  then `Verified:` on the plan.
- Owner: a remote for the child (catalog `remote:`); the `LMT_SEX` → 301 and `LMT_TYPE_CODE` → rule
  kind mappings, one commit each.
- Earlier open items stand (REANC, architect, shell team, Keycloak). Push `rea` (owner's shell).

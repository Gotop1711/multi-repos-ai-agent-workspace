# 2026-09-23 | claude | rea | acceptance-answers

## Task
The owner answered the acceptance plan point by point: what "host" means, both Save calls returned
`success: true` (screenshots), the validation job is not theirs to run, 5 and 8 are not urgent,
6 and 7 were not understood. Fold that back into the documents.

## Done
- Plan rea-proto-data-creator-acceptance rewritten (`draft` still): 「伺服器」 defined once, "host"
  gone; a 已成立 section for the two calls; step 3 restated as *not the owner's*; old 6/7 became
  5/6, each a concrete question with its data in front of it; 5 and 8 moved to 暫緩.
- 301's ask is two yes/no questions: `LMT_SEX` 1 → 限男性 / 2 → 限女性, and whether a filled cell
  is itself the trigger. `SexRuleGenerator.cs:17-37` takes only `mainSetting` `"1"`/`"2"`; the
  export has 19 醫令 in force — 2 are `1` (12081C, 27052C), 17 are `2` (mostly P3911C–P3924C).
- `MHCT_PAYLTYPE`'s 19 limit types listed in the plan — rows/醫令 counts, `LMT_ITEM` samples,
  `CNT`/`RATE` — so the owner answers type by type, not from a bare column name.
- Repository doc: the acceptance run as a fact. declare-verify Part 3 step 4: a code with no
  declaration row is never touched, so an empty batch ends `Completed` having checked nothing.

## Decisions & pitfalls
- `SaveWork` answering `true` proves both start-date checks passed (`RuleService.cs:261-274`,
  `:424-437`, `:55-64`) — what old step 1 was for, so `Payment/Detail/Get` was never needed.
  It proves nothing about the compiled workflow: a hollow unit answers `true` too.
- The job builds an engine only per order code present in the Oracle result
  (`ValidationJobService.cs:336`, `:354-387`), so a job on a 醫令 with no declarations comes back
  `Completed` meaning nothing. Acceptance has to start from a batch that loads, not from 01023C —
  which is why step 3 cannot be finished by the owner alone.
- declare-verify sat at 299/300, so the new fact had to fit inside step 4's two lines; the plan
  landed on exactly 80. `check` folds at 100 *bytes*: a Chinese line of ~34 characters counts twice.
- No `Verified:` written: the setup plan's Done-when includes the job, and the job has not run.

## TODO
- Owner: the two mappings (plan steps 5, 6); `Signed:` before either is written; ask the back end
  side for a declaration batch that loads (step 3).
- declare-verify is full at 300 lines: the next fact needs the Part 3 split first.
- Earlier open items stand (REANC, architect, shell team, Keycloak). Push `rea` (owner's shell).

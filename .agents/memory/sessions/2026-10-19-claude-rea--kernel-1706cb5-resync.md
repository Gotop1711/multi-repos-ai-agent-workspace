# 2026-10-19 | claude | rea | kernel-1706cb5-resync

## Task
Owner's "do it now": bring the modules to `REA_kernel@1706cb5` — ten commits since `692bdc0`
(`82dda92` CI demo, `667734c` 檢核範圍 fields + twelve condition translators, `1b0ecaf` VisibleWhen in
the validator, `f71e54d` 204 translator, `4b889a8` three date fields dropped, `5c6cd2c`/`0b325e0` CI).

## Done
- New module translator (`doc add`): reach (201/203/204; twelve conditions, `Robotic` the one out),
  204's `MHAT_PRSN_DEGREE` rule, the ETL side, history — moved out of rea-kernel, which was 17 lines
  over its cap with the new facts; rea-kernel keeps one pointer line each.
- rea-kernel: `Disabled` now one condition per code (`Robotic`) and 91 options (基準日 06–08, 類別 04
  群組, 203/204 dates, 204 遠距); `FieldRuleValidator` skips hidden fields; `demo` branch build;
  first-level line numbers at `1706cb5`; the stale `docs/codes/205.md` bullet dropped (`_205.cs` moved).
- scope-conditions: re-cited at `1706cb5`/`3ad7356`; `PrefixLen` served in 02 開頭 (ui's `prefixLen`
  renders now, `prefixRange` still not); 22 ICD 比對欄位; new § 7 on what translates.
- field-map (orphans six; header cite), rule-editor (Disabled section), rule-schema-api (counts,
  `VisibleWhen` kernel reader), ruleset-api (`1706cb5` delta, validator line shift +7).
- Plan ui-scope-option-flags (draft): scope `el-option`s bind no `disabled` → 類別 04 群組 saves an
  untranslatable row; mock and tests still the 2026-09-17 shape.

## Decisions & pitfalls
- `4b889a8` removed `RelDate`/`TherSDate`/`AssayDate` because the test DB lacks the columns — the
  options stay served, flagged; not a schema version bump.
- Translator exceptions are swallowed since `a63ad16`, so an ignored option flag costs a dead rule,
  not a 400 — the plan's motivation.
- No live capture after 2026-10-08: whether the host runs `1706cb5` is unknown; nothing claims it.
- ui-map-orphans (another task's plan) still says `prefixLen` is an orphan — reported, not edited.

## TODO
- Owner: sign ui-scope-option-flags, or say the dropdown flags can wait.
- Owner: capture `RuleSchema` from the host once it is rebuilt (ingest) — the 91/1 counts are from
  source only. ui-map-orphans: drop `prefixLen` from its gap 3 when next touched.

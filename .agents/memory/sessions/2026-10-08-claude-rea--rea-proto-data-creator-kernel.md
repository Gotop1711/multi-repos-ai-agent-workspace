# 2026-10-08 | claude | rea | rea-proto-data-creator-kernel

## Task
Owner recorded the real `POST /api/v1/RuleSet` payloads the running ui sends, one per rule kind
(`ui_misc/api-records`, outside the workspace), set the precedence kernel spec > recorded payloads >
prototype data, answered the plan's open questions in the panel and said: sign and ship.

## Done
- Ingested the eighteen records and today's live `RuleSchema` as kernel sources, each cited by name.
  Against the draft mapping: shape matches; the ui sends every served `Reference` key at its
  `Default`; `AgeReference` is `Birthday`/`ChildBirthday` since `REA_kernel@692bdc0` (2026-10-07, the
  remote tip; clone now at it) — validators, `RuleSetParameter` and translator reach unchanged.
- Rulings (panel): 307 blanks → `RangeEnd1 = RangeStart1`, months `0`–`9999` (the values the owner
  typed in record 307); 202 `DoctorRole "FullTime"`; `RuleStartDate` `2026-01-01`. Plan rewritten,
  signed, shipped `f4c48c8` `e7a620e` `79c4566` `b059b56`: `schemas/RuleSchema_1.0.json`,
  `src/kernel.js` (mapping, assembler, OtherNote, four-stage validator), `--target kernel`,
  `--batch-size`, `fixtures/kernel/`, README.
- Tests: fixtures validate clean; nine broken bodies each caught at the kernel's stage; the build
  writes all 15 kinds (12 763 items, 25 files at 1000); proto output byte-identical to before.
- Docs: ruleset-api › Save (the ui's shape, store at seven rows); field-map (AgeReference); rea-kernel
  › Live deployment; rea-proto-data-creator rewritten for two targets; index.

## Decisions & pitfalls
- 202's `DoctorTypes` still comes from `ENAME` (a column supplies it); every other reference key takes
  the kernel default, the prototype's `referenceDate` and 205/206's `doctorTypes` dropped.
- The validator stops at the first failing stage as the kernel does: a 301 leaf with 302 keys reports
  undeclared keys only, never the option error behind them — by design, not an omission.
- The records all target `33116B` on one start date: only the last save (202) is in the store.
- A `<code>` pattern is not a citation: `check` warned until all eighteen were named in full.

## TODO
- Owner: post `data/out/kernel/r203.json` to the dev kernel (plan › Done when); then `Verified:`.
- Owner: 306-main-setting, rea-proto-data-creator-setup, payment-snapshot, reference-groups await
  `Verified:`; push `rea`; the child still has no remote.

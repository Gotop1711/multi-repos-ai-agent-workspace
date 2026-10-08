# 2026-10-08 | claude | rea | rea-proto-data-creator-kernel

## Task
Owner recorded the real `POST /api/v1/RuleSet` payloads the running ui sends, one per rule kind
(`ui_misc/api-records/POST_RuleSet_payload_by-rules`, outside the workspace), and asks whether they
complete the data-creator kernel plan; ingest if useful.

## Done
- Ingested the eighteen records and today's live `RuleSchema` as kernel sources. Compared each record
  to the draft plan's mapping: the shape matches; two things differ — the ui sends every served
  `ReferenceFields` key at its `Default`, and `AgeReference` values are `Birthday`/`ChildBirthday`.
- Traced the rename to `REA_kernel@692bdc0` (2026-10-07, `origin/develop` tip; clone at `8b852f3`);
  diffed `6540a4c..692bdc0`: validators, `RuleSetParameter` and the translator's reach unchanged;
  `RuleSetSL` only changed how `TranslatedRules` is serialized.
- The 307 record answers plan question 1 in practice: the owner typed `RangeEnd1 = RangeStart1` and
  months `0`–`9999`. Re-ran the scratch mapper with those fills and every reference default against
  today's schema: all 12 763 bodies pass (was 61 refused). 202's record shows the radio emitting
  `Executor`/`FullTime`, consistent with the proposed `FullTime` for `employmentType "01"`.
- Rewritten: the plan (mapping, step 5 now "confirm two readings"); ruleset-api › Save (the ui's
  shape, the store's seven rows); field-map (AgeReference); rea-kernel › Live deployment;
  rea-proto-data-creator › the kernel contract; the index line.

## Decisions & pitfalls
- Kept `DoctorTypes` from the prototype's `doctorTypes` (`["02"]` / `["01"]`) rather than the ui's
  default all-three: the 產出規則 says which doctor; the owner can overrule.
- The 2026-10-02 schema capture stays cited (field-map's table was read from it); the 10-08 one
  carries only the rename. No capture of the store: read live, seven rows, listed in ruleset-api.
- The records all target `33116B` with the same start date, so each save overwrote the last; the
  store proves only the final one (202) was accepted — the others' acceptance is inferred.

## TODO
- Owner: confirm the two readings in plan step 5, then `Writes:` + `Signed:`; I then ship steps 1–4.
- Owner: 306-main-setting, rea-proto-data-creator-setup, payment-snapshot, reference-groups await
  `Verified:`; push `rea`.

# 2026-10-08 | claude | rea | rea-proto-data-creator-kernel

## Task
Owner recorded the real `POST /api/v1/RuleSet` payloads the running ui sends, one per rule kind
(`ui_misc/api-records/POST_RuleSet_payload_by-rules`, outside the workspace), and asks whether
they
complete the data-creator kernel plan; ingest if useful.

## Done
- Ingested the eighteen records and today's live `RuleSchema` as kernel sources. Compared each
  record to the draft plan's mapping: the shape matches; two things differ — the ui sends every
  served `ReferenceFields` key at its `Default`, and `AgeReference` values are
  `Birthday`/`ChildBirthday`.
- Traced the rename to `REA_kernel@692bdc0` (2026-10-07, the remote tip; clone now at it); from
  `6540a4c` the validators, `RuleSetParameter` and the translator's reach are unchanged.
- The 307 record answers plan question 1 in practice: the owner typed `RangeEnd1 = RangeStart1`
  and months `0`–`9999`. Re-ran the scratch mapper with those fills and every reference default
  against today's schema: all 12 763 bodies pass (was 61 refused). 202's record shows the radio
  emitting `Executor`/`FullTime`, consistent with the proposed `FullTime` for `employmentType
  "01"`.
- Rewritten: the plan (mapping, step 5 now "confirm two readings"); ruleset-api › Save (the ui's
  shape, the store's seven rows); field-map (AgeReference); rea-kernel › Live deployment;
  rea-proto-data-creator › the kernel contract; the index line.

- Owner, mid-session: precedence is kernel spec > recorded ui payloads > the prototype's data
  (reference only). Plan mapping rewritten: every reference key at the kernel `Default`
  (ReferenceDates included); only 202's `DoctorTypes` comes from a column. Re-checked in scratch:
  all bodies pass.

## Decisions & pitfalls
- `check` warned on the eighteen records cited by a `<code>` pattern — each is now named in full
  in ruleset-api; a pattern is not a citation.
- The records all target `33116B` on one start date: only the last save (202) is in the store.

## TODO
- Owner: confirm the two readings in plan step 5, then `Writes:` + `Signed:`; I then ship steps
  1–4.
- Owner: 306-main-setting, rea-proto-data-creator-setup, payment-snapshot, reference-groups await
  `Verified:`; push `rea`.

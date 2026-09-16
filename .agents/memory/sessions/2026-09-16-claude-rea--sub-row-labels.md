# 2026-09-16 | claude | rea | sub-row-labels

## Task
Review the two draft plans, take the owner's decisions in session (labels → B, category order → A), execute `sub-row-labels` in `REA_UI`, close `305-category-order` into the Body.

## Done
- `REA_kernel` is read-only → kernel-side options rewritten as requests; Q1 answered from the prototype template.
- `REA_UI` `debug-ui` pushed `f9837a2..bdba317`: object-form sub-group overrides (`SubGroupInput`), `'303'`/`'305'` entries, two tests; 47 files / 1082 tests, lint clean.
- 303/305 Body text and Terms (類別 vocabulary) updated; F20/F22 promoted.

## Decisions & pitfalls
- The Body's F12 table was the *proposed* schema, not the served one — the live-schema derivative and `_303.cs` are the truth for "what the kernel serves".
- Per-mode sentences for 303 came free from the same four lines; `IntervalValue`'s served prefix `且間隔` is blanked because the prototype puts it in `max`'s suffix.
- `textAdd` renders no label in `MainSetting.vue`, so the codes sub-row uses `prefixText` `代碼輸入`.
- My comment hit `max-len` 101/100 — lint run at HEAD with the change stashed proved it was mine.
- `applyUIMapToBlock` is not exported; tests go through `normalizeSchemaRuleCode` with inline served-shaped fields.

## TODO
- Owner: eyeball 303 modes 06/09 and 305 開頭範圍/代碼/群組 in `:5173`, then `Verified:`; the `debug-ui` → `develop` merge request.

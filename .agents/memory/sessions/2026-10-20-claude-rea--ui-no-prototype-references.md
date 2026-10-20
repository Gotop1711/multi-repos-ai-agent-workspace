# 2026-10-20 | claude | rea | ui-no-prototype-references

## Task
Owner asked who "proto" in `ruleUIConfig.ts` comments is (answer: `REA_PROTO`, the retired
prototype UI), then ruled that `REA_PROTO` is legacy and must not be referred to anywhere in
`REA_UI`'s codebase: examine the whole repo and modify every mention.

## Done
- Swept every tracked file of `REA_UI@4909dc7` (`develop` = `origin/develop`; the owner pushed it this
  session) for proto / prototype / 原型 / 舊版 / legacy / sub-block / blockId / blocks[: 17 lines,
  comments and test names only (11 `ruleUIConfig.ts`, 4 `ruleSchemaUtils.test.js`, 2 add-on).
- Plan ui-no-prototype-references drafted with each replacement; the ruling is in rea-ui ›
  Integration; rea-ui › Branches corrected (develop pushed).
- No write to the child: the plan is unsigned.

## Decisions & pitfalls
- Kernel 304 also skips `09` (`REA_kernel@2704043 _304.cs:18-27`), so "proto 跳過 09" becomes
  "kernel 沒有 09" without losing meaning.
- The add-on's "prototype" means the local-only board, not the legacy project; reworded anyway as
  ambiguous. `legacy` / `舊版` in add-on and `api/request.js` are storage / envelope versions, kept.
- Two open items for the owner at signing, default out: `frontend.conf:8` / `.env.development:5`
  name `NhiDeclareVerify` / `REA_payment-snapshot` (live Payment upstream, not `REA_PROTO`); and
  `ruleSchemaUtils.js:178,194` read `blockId`, the prototype's key, which the kernel never serves.
- `plan new` pushed the index to 101 lines (fold counts bytes; CJK and em dashes cost 3). Joined
  two manually wrapped plan entries (no words changed) and kept the new entry to one line.
- Pushed commit messages that say "prototype" stay; history is not rewritten.

## TODO
- Owner: rule the two open items, sign; then ship one commit (two if `blockId` is in).
- Index line for ui-202-employment-type still says "draft"; that plan is shipped (another task's
  line, not changed here).

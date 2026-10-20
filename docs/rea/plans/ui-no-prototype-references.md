# rea — ui-no-prototype-references: REA_UI's code and tests stop naming the legacy prototype

Status: draft

## Goal
Owner's ruling, 2026-10-20: `REA_PROTO` is a legacy project and is never referred to in `REA_UI`'s
codebase, by name or as "proto" / "prototype" (rea-ui › Integration). A fact a comment took from it is
stated as the kernel's or the ui's own. At `REA_UI@4909dc7` (`develop` = `origin/develop`), a sweep of
every tracked file for `proto`, `prototype`, `原型`, `舊版`, `legacy`, `sub-block`, `blockId` and
`blocks[` finds 17 such lines, all in comments and test names; Steps rewrite them and change no code token,
so behaviour is unchanged. One code path is prototype-shaped too (Open). The remaining hits are not the prototype: `Object.prototype` / `getPrototypeOf` /
`Storage.prototype` (JavaScript), npm packages in `package-lock.json` (`proto-list`, `get-proto`,
`dunder-proto`), add-on `legacy` / `舊版` (the `rea:addOn:v1` storage format) and `api/request.js`
`舊版` (an unwrapped response envelope). Rule 304's missing `09` is the kernel's too
(`REA_kernel@2704043 …/Codes/V1.0/_304.cs:18-27`), so the 09 comments keep their meaning.

## Writes
`REA_UI (develop)`. One commit.

## Steps
1. `src/utils/rule/ruleUIConfig.ts`:
   - `:65` → `// 開頭／開頭範圍共用的「前 [ ] 碼，」欄位（305 的 bodyPartPrefixLen / orderPrefixLen、306 的 diagnosisPrefixLen）`
   - `:174` → `// 限制申報頻率：一個頻率類型下拉，九種模式連動五組子欄位（01–05 共用 countLimit）`
   - `:192` `（proto 各 sub-block 的 prefix / suffix）` → `（各子群組的 prefixText / suffixText）`
   - `:231` → `// （kernel 的選項沒有 09）`
   - `:277` → `//（八個子群組，部位與醫令兩側同形）`
   - `:306` → `// bodyPartGroup / orderGroup 同時是群組名與其唯一欄位名`
   - `:307`, `:353` `句子照 proto（…）` → `句子在此定義（…）`, the parenthesis kept
   - `:336` → `//（代碼 / 開頭 / 開頭範圍三個子群組）`
   - `:343-344` → one line: `// ⛔ key 是 kernel 服務端的值（01 代碼 / 02 開頭 / 03 開頭範圍）；連動照值對應，不照子群組的排列順序`
2. `tests/unit/utils/rule/ruleSchemaUtils.test.js`:
   - `:193` test name `（proto 跳過 09）` → `（kernel 沒有 09）`
   - `:234` `proto 沒有 09` → `kernel 的選項沒有 09`
   - `:422-423` → `// ⛔ 連動是按「服務端的值」對應：kernel 的 01/02/03 ＝ 代碼／開頭／開頭範圍；以 label 斷言即在鎖這件事。`
   - `:440` test name `306 子群組句子照 proto，…` → `306 子群組句子由 UIMap 定義，…`
3. Add-on, where "prototype" means the local-only board but reads as the legacy project:
   - `src/utils/addOn/catalog.js:1` `前端 prototype 的固定主檔` → `前端內建的固定主檔`
   - `tests/unit/views/addOn/AddOnBoard.test.js:190` `'AddOnBoard.vue local prototype'` →
     `'AddOnBoard.vue'`, its name before `b8e2cbe`
4. `npx vitest run`, `npm run lint`; one commit, `chore: comments and test names stop naming the
   legacy prototype`.

## Open — the owner rules at signing
- `frontend.conf:8` (`原 Azure 的 NhiDeclareVerify 主機`) and `.env.development:5` name the
  prototype's back end and `REA_payment-snapshot`, today's live Payment upstream. They are not
  `REA_PROTO`, and the URLs must stay. Default: out of scope. If in, only the `:8` comment's
  `NhiDeclareVerify` clause goes.
- `src/utils/rule/ruleSchemaUtils.js:178`, `:194` read `blockId || value` for a condition's and a
  code's id. The kernel serves only `value` (no `blockId` anywhere in `REA_kernel@2704043`, nor in
  `mock/rulesData.js`); `blockId` is the prototype's key (`REA_PROTO@3fdf47c
  tests/mock/api/rulesSpecificSetting.json`). It dates from the scaffold `f7a2f0f`; that it was
  copied from the prototype is inferred. Default: out. If in, a second commit drops both
  `blockId ||` and the fixture's `blockId: 'main1'` (`tests/unit/views/rules/RuleEditorDialog.test.js:610`).
  The neighbouring `title || label` and `inputs`-before-`fields` stay: they are also the keys of the
  normalized form itself.

## Out of scope
- Pushed commit messages (`98fe3b4`, `32b1fea`, `904bcfe`, `f4d9e38`, `411c809`, …) say
  "prototype"; history is not rewritten.
- Identifiers that came from it (`bodyPartGroup`, `orderGroup`, `code.blocks`) are the ui's names now.
- Other branches pick the change up when rebased on `develop`.

## Done when
On `develop`, this finds only the JavaScript lines named in Goal:
`git grep -n -i -E "proto|原型" -- . ':!package-lock.json'`. The diff touches comments and test
names only, plus the `blockId` commit if the owner took it in. Every test passes and lint is
clean.

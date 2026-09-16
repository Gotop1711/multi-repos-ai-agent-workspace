# rea — sub-row-labels: the sub-row fields of 303 and 305 read as the prototype's one sentence

Writes: REA_UI (debug-ui)
Status: shipped
Signed: gotop1711 — 2026-09-16 — option B
Shipped: 2026-09-16 — REA_UI@bdba317 on `debug-ui` (d6bdb0a object-form sub-group overrides in `applyUIMapToBlock` + `SubGroupInput`; bdba317 `'303'`/`'305'` entries in object form, two tests; pushed f9837a2..bdba317; `npx vitest run` 47 files / 1082 tests, lint clean; merge request to `develop` not opened)

## Goal
The kernel serves every sub-row field of 303 and 305 with a non-empty `Label`, and the editor prints it before the field's `PrefixText`, so a 305 sub-row read `部位前幾碼 前 [ ] 碼` where the prototype writes `前 [ ] 碼，`. After this plan each sub-row reads as the prototype's sentence, and 303's shared `max` / `period` / `periodUnit` carry each mode's own prefix and suffix.

Premises at `REA_UI@f9837a2 REA_PROTO@3fdf47c REA_kernel@2ff26b0`: the kernel declares the labels (`_303.cs:33-36`, `_305.cs:39-40`; F12's `Label: ""` request was not taken); `MainSetting.vue:60-65` prints `input.label`, `:75-79` `prefixText`; the prototype carries the sentence as `prefixText` with `label: ""`; `REA_kernel` is read-only, so a kernel-side fix is a request, not work this workspace can do.

## Options — signed B
| | Option | Writes | Effect |
|---|---|---|---|
| A | Kernel serves `Label: ""` on sub-row fields | none here — a request to the kernel's owners | Right place, no ui mechanism; depends on owners who did not take the same request before. |
| **B** | Per-sub-group overrides in the UI map | `REA_UI (debug-ui)` | Prototype sentences now; served labels stay correct for other consumers; a second, richer form of `subGroups.inputs`. |
| C | Leave as is | — | The wordier rendering becomes the recorded design. |

## Steps (done)
1. `applyUIMapToBlock`: an object override is merged over the served field; the string form stays type-only. `SubGroup.inputs: Record<string, UIInputType | SubGroupInput>`.
2. `'303'` and `'305'` sub-groups in object form — labels hidden, each mode's prefix/suffix; a shared `PREFIX_LEN` for 305's 前 [ ] 碼，.
3. Tests in `ruleSchemaUtils.test.js`: the 303 `max` sentence per group and validations preserved; the 305 shared prefix-length field in both groups, `群組選擇`, `代碼輸入`.

## Done when
In `:5173`, 303 modes 06 and 09 and 305 開頭範圍 / 代碼 / 群組 read as the sentences in rule-codes; then the owner writes `Verified: <name>`. 304 is unchanged by design.

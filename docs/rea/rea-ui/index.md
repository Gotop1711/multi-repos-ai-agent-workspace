# rea / rea-ui

Repository `REA_UI` (`projects/ui`, access `write`) — Vue 3 schema-driven rule editor for 三代健保 REA: rule dialogs render from `GET /api/v1/RuleSchema`, the edited rule becomes a `RuleNode`. Cited at `REA_UI@442ef39` (`develop`; layout facts below at `04016d3` where marked); deployment lines at `@2d2c40e` on `feature-nhi-deployment`.

- **Branches.** `develop` = `origin/develop` = `442ef39` (2026-10-19, pushed by the owner outside the
  workflow): on `bdd28ec` (plan ui-right-drawer's two commits, then hospital-data-upload's six),
  `ae5a379` squashes binghan60's `origin/feature-ValidationResult@7264c61` (the 檢核結果 tab,
  validation-result), five reverts (`0448e05`…`4c70cb7`) take out the global drawer and the aside
  wiring, and `442ef39` re-opens the upload panel from an inline drawer. `origin/debug-ui`,
  `origin/debug-cicd`, `origin/debug-api` are `bdd28ec`; a second remote `gotop1711` (gitlab.com)
  holds `develop@bdd28ec`. Local, unpushed `feature-nhi-deployment@2d2c40e` (plan nhia-vm-ui-routing)
  still sits on `bdd28ec`, so the VM image lacks the tab and the inline drawer until the owner rebases
  it. Colleagues' branches: `origin/dev/julian`, `origin/dev/lynn`, `origin/feature-title-changes`,
  `origin/feature-ValidationResult`. Older rewritten-branch history is in the 2026-10-01 deployment
  session and `git log`.
- **Layout.** `src/layouts/DefaultLayout.vue` is a page, not a layout: the route component of `/` (`src/router/index.js:4-8`), with no `<router-view>`, embedding `Payment.vue`, `AddOn.vue` and `ValidationResult.vue` in three of five `el-tab-pane`s (`DefaultLayout.vue:17,38-41,48`; the fifth, 檢核結果, since `ae5a379` — validation-result); the 加成 dirty guard is the tabs' `:before-leave` (`:8`). `/payment` renders `Payment.vue` bare, outside the frame (`index.js:9-13`), and nothing in `src/` navigates to it. `src/router/subSystemRouter.js` is a second, unused route table. All three are the scaffold (`f7a2f0f`); the shape the regulation's shell expects is nhia-frontend-standard › Architecture; the fix is plan ui-layout-routing. The right aside holds an `Upload` button and the layout's own `<el-drawer>` (title 申報資料上傳, `rtl`, 40%, `destroy-on-close`, toggled by a local `isRightDrawerVisible` ref) around `src/components/HospitalDataUploadPanel.vue` (`DefaultLayout.vue:53-69,84`, `@442ef39`). Ruling, the owner's by revert (2026-10-16/19, plan ui-right-drawer abandoned): no app-wide drawer — the module-scoped composable `useRightDrawer.js` and host `RightDrawer.vue` shipped at `7d13a95`/`b7e7073` are gone since `4c70cb7`/`a33fcbf`; a drawer belongs to the page that owns its state, as `ValidationResult.vue:379-380` also does. The panel (`@180231a`; host-agnostic, it only emits `close`; the owner's style `@69266f1`): a 院所資料 CSV parsed by `src/utils/hospitalData/csv.js` into `ClaimBatchKey` rows, posted through `src/api/modules/validationJob/` (validation-job-api).
- **Deployment.** Plan nhia-vm-ui-routing's image is for the closed NHIA VM: compose publishes
  `8082:80`, and the image proxies every `/api/*`, including Payment, to
  `nhi-claimvalidator:8080` (`REA_UI@2d2c40e frontend.conf:7-15`). The backend has not implemented
  Payment yet, so those calls remain unavailable until it does. Image, routes, pipeline and handoff:
  ui-deployment.
- **Run / test.** `npm run dev` (`:5173`; `VITE_USE_MOCK=true` serves `mock/rulesData.js`; otherwise every `/api` path goes to `VITE_DEV_PROXY_TARGET`, `.env.development:4-6`, `vite.config.js:55-63`); `npx vitest run`; `npm run lint` (`eslint ./src`, `max-len` 100).
- **Entry points.** `src/views/rules/RuleEditorDialog.vue` (save), `src/views/rules/MainSetting.vue` (the form and its dynamic rows), `src/utils/rule/ruleUIConfig.ts` (the UI map, `SubGroupInput`), `src/utils/rule/ruleSchemaUtils.js` (schema → form, `collectMainPayloadFields`), `src/utils/rule/ruleNodeUtils.js` (`RuleNode`), `src/api/modules/rules/index.ts` (API client, field-id lowering), `src/api/modules/validationJob/index.ts` (jobs), `src/views/rules/RuleShows.vue` (read view), `src/views/ValidationResult.vue` (the 檢核結果 tab on demo rows) with `src/utils/validationResult/claimResult.js` (its pure filters, counts and labels).
- **Folders.** The regulation defines `helpers/` and `utils/` identically (nhia-frontend-standard › Project
  layout); the repo's own split is dependency direction: `src/helpers/` holds domain-free leaf modules
  (`date.js`, `validation.js`, the generic `csv.js` since `@652f853`, and `file.js` — JSON download,
  clipboard — since `@ae5a379`) imported by views and by
  `src/utils/*` (`rule/inputTypeConfig.js:1`, `rule/ruleNodeUtils.js:4`, `hospitalData/csv.js:9`), never the reverse; `src/utils/` is domain code by feature (`rule/`, `payment/`,
  `addOn/`, `hospitalData/`, `validationResult/`) plus `common.js` (`toArray`, `generateUniqueId`); a drawer panel is an ordinary component, placed by the owner (`components/` root, 2026-10-07); a view's own sub-components, theme and demo data sit beside it in `src/views/<view>/` (`views/validationResult/`, binghan60's placement at `@ae5a379`, as `views/payment/` before it). `src/api/caseTransform.js` is the axios
  boundary's PascalCase↔camelCase pass, imported only by `api/request.js:2`, `api/interceptors.js:5`,
  `api/modules/rules/index.ts:3` and `mock/index.js:6`; its request pass covers only the kernel paths named in
  `api/interceptors.js:14` (RuleSchema, RuleSet, options, ValidationJob since `@7827302`); under the BFF rule that
  reshaping leaves the ui (bff › what a BFF would own), so it stays in `api/`. (`REA_UI@442ef39`)
- **Integration.** Consumes the kernel's schema (rea-kernel) and follows the prototype's layouts (rea-proto); see rule-editor and rule-codes.

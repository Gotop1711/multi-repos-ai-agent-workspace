# rea / rea-ui

Repository `REA_UI` (`projects/ui`, access `write`) — Vue 3 schema-driven rule editor for 三代健保 REA: rule dialogs render from `GET /api/v1/RuleSchema`, the edited rule becomes a `RuleNode`. Cited at `REA_UI@bdd28ec` (`develop`; layout facts below at `04016d3` where marked); deployment lines at `@2d2c40e` on `feature-nhi-deployment`.

- **Branches.** `develop`, `origin/develop` and `debug-ui` are `bdd28ec` (plan ui-right-drawer's
  two commits, then hospital-data-upload's six, the last two the owner's) on `04016d3`; owner rebased
  local, unpushed `feature-nhi-deployment` onto it on 2026-10-07, yielding `2d2c40e` for signed plan
  nhia-vm-ui-routing. `origin/debug-ui` remains `04016d3`; `debug-cicd` and `debug-api` stay at
  `b0ecc15`. Older rewritten-branch history and aliases are in the 2026-10-01 deployment session and
  `git log`.
- **Layout.** `src/layouts/DefaultLayout.vue` is a page, not a layout: the route component of `/` (`src/router/index.js:4-8`), with no `<router-view>`, embedding `Payment.vue` and `AddOn.vue` in two of four `el-tab-pane`s (`DefaultLayout.vue:17,36-39`); the 加成 dirty guard is the tabs' `:before-leave` (`:8`). `/payment` renders `Payment.vue` bare, outside the frame (`index.js:9-13`), and nothing in `src/` navigates to it. `src/router/subSystemRouter.js` is a second, unused route table. All three are the scaffold (`f7a2f0f`); the shape the regulation's shell expects is nhia-frontend-standard › Architecture; the fix is plan ui-layout-routing. The right aside holds the app's one global drawer (`REA_UI@7d13a95`, `@b7e7073`): `src/composables/useRightDrawer.js` keeps `visible`/`component`/`props`/`title`/`size` at module scope, `open(Panel, options)` returns a Promise that `close(payload)` resolves, `reset()` clears on `@closed`, usage in its header; `src/components/common/RightDrawer.vue` is the single `<el-drawer>` rendering `<component :is>`; the layout contributes the trigger button and `<RightDrawer />` (`DefaultLayout.vue:45-55`). The first panel is `src/components/HospitalDataUploadPanel.vue` (`@180231a`; host-agnostic, it only emits `close`; the owner's style `@69266f1`): a 院所資料 CSV parsed by `src/utils/hospitalData/csv.js` into `ClaimBatchKey` rows, posted through `src/api/modules/validationJob/` (validation-job-api); the button opens it at 50%.
- **Deployment.** Plan nhia-vm-ui-routing's image is for the closed NHIA VM: compose publishes
  `8082:80`, and the image proxies every `/api/*`, including Payment, to
  `nhi-claimvalidator:8080` (`REA_UI@2d2c40e frontend.conf:7-15`). The backend has not implemented
  Payment yet, so those calls remain unavailable until it does. Image, routes, pipeline and handoff:
  ui-deployment.
- **Run / test.** `npm run dev` (`:5173`; `VITE_USE_MOCK=true` serves `mock/rulesData.js`; otherwise every `/api` path goes to `VITE_DEV_PROXY_TARGET`, `.env.development:4-6`, `vite.config.js:55-63`); `npx vitest run`; `npm run lint` (`eslint ./src`, `max-len` 100).
- **Entry points.** `src/views/rules/RuleEditorDialog.vue` (save), `src/views/rules/MainSetting.vue` (the form and its dynamic rows), `src/utils/rule/ruleUIConfig.ts` (the UI map, `SubGroupInput`), `src/utils/rule/ruleSchemaUtils.js` (schema → form, `collectMainPayloadFields`), `src/utils/rule/ruleNodeUtils.js` (`RuleNode`), `src/api/modules/rules/index.ts` (API client, field-id lowering), `src/api/modules/validationJob/index.ts` (jobs), `src/views/rules/RuleShows.vue` (read view).
- **Folders.** The regulation defines `helpers/` and `utils/` identically (nhia-frontend-standard › Project
  layout); the repo's own split is dependency direction: `src/helpers/` holds domain-free leaf modules
  (`date.js`, `validation.js`, and the generic `csv.js` since `@652f853`) imported by views and by
  `src/utils/*` (`rule/inputTypeConfig.js:1`, `rule/ruleNodeUtils.js:4`, `hospitalData/csv.js:9`), never the reverse; `src/utils/` is domain code by feature (`rule/`, `payment/`,
  `addOn/`, `hospitalData/`) plus `common.js` (`toArray`, `generateUniqueId`); a drawer panel is an ordinary component, placed by the owner (`components/` root, 2026-10-07). `src/api/caseTransform.js` is the axios
  boundary's PascalCase↔camelCase pass, imported only by `api/request.js:2`, `api/interceptors.js:5`,
  `api/modules/rules/index.ts:3` and `mock/index.js:6`; its request pass covers only the kernel paths named in
  `api/interceptors.js:14` (RuleSchema, RuleSet, options, ValidationJob since `@7827302`); under the BFF rule that
  reshaping leaves the ui (bff › what a BFF would own), so it stays in `api/`. (`REA_UI@bdd28ec`)
- **Integration.** Consumes the kernel's schema (rea-kernel) and follows the prototype's layouts (rea-proto); see rule-editor and rule-codes.

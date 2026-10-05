# rea / rea-ui

Repository `REA_UI` (`projects/ui`, access `write`) — Vue 3 schema-driven rule editor for 三代健保 REA: rule dialogs render from `GET /api/v1/RuleSchema`, the edited rule becomes a `RuleNode`. Cited at `REA_UI@2a7a7c9`.

- **Branches.** `develop`, `origin/develop`, `debug-ui`, `debug-cicd` and `debug-api` point to `b0ecc15`; signed plan nhia-vm-ui-routing adds `2a7a7c9` on local, unpushed `feature-nhi-deployment`. Older rewritten-branch history and aliases are in the 2026-10-01 deployment session and `git log`.
- **Deployment.** Plan nhia-vm-ui-routing's image is for the closed NHIA VM: compose publishes `8082:80`, and the image proxies every `/api/*`, including Payment, to `nhi-claimvalidator:8080` (`frontend.conf:7-14`). The backend has not implemented Payment yet, so those calls remain unavailable until it does. Image, routes, pipeline and handoff: ui-deployment.
- **Run / test.** `npm run dev` (`:5173`; `VITE_USE_MOCK=true` serves `mock/rulesData.js`; otherwise every `/api` path goes to `VITE_DEV_PROXY_TARGET`, `.env.development:4-6`, `vite.config.js:55-63`); `npx vitest run`; `npm run lint` (`eslint ./src`, `max-len` 100).
- **Entry points.** `src/views/rules/RuleEditorDialog.vue` (save), `src/views/rules/MainSetting.vue` (the form and its dynamic rows), `src/utils/rule/ruleUIConfig.ts` (the UI map, `SubGroupInput`), `src/utils/rule/ruleSchemaUtils.js` (schema → form, `collectMainPayloadFields`), `src/utils/rule/ruleNodeUtils.js` (`RuleNode`), `src/api/modules/rules/index.ts` (API client, field-id lowering), `src/views/rules/RuleShows.vue` (read view).
- **Integration.** Consumes the kernel's schema (rea-kernel) and follows the prototype's layouts (rea-proto); see rule-editor and rule-codes.

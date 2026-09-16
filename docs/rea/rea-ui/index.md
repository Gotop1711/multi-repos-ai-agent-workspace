# rea / rea-ui

Repository `REA_UI` (`projects/ui`, access `write`) — Vue 3 schema-driven rule editor for 三代健保 REA: rule dialogs render from `GET /api/v1/RuleSchema`, the edited rule becomes a `RuleNode`. Cited at `REA_UI@bdba317`.

- **Branches.** The owner works on `debug-ui`, where 303/304/305, the `Main` payload fix (`f69d5d9`), the sub-row sentences (`bdba317`) and 306 (`8281dbb`) landed; `develop` (`572edc1`) has 303 and 304 merged. The merge request `debug-ui` → `develop` is the owner's action in GitLab (`glab` holds no credentials for `gitlab.transportdata.tw`). Read `git log origin/debug-ui..debug-ui` before pushing: the owner's own commits sit there unpushed at times.
- **Run / test.** `npm run dev` (`:5173`; `VITE_USE_MOCK=true` serves `mock/rulesData.js`); `npx vitest run`; `npm run lint` (`eslint ./src`, `max-len` 100).
- **Entry points.** `src/views/rules/RuleEditorDialog.vue` (save), `src/views/rules/MainSetting.vue` (the form and its dynamic rows), `src/utils/rule/ruleUIConfig.ts` (the UI map, `SubGroupInput`), `src/utils/rule/ruleSchemaUtils.js` (schema → form, `collectMainPayloadFields`), `src/utils/rule/ruleNodeUtils.js` (`RuleNode`), `src/api/modules/rules/index.ts` (API client, field-id lowering), `src/views/rules/RuleShows.vue` (read view).
- **Integration.** Consumes the kernel's schema (rea-kernel) and follows the prototype's layouts (rea-proto); see rule-editor and rule-codes.

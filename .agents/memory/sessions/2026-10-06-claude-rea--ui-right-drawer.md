# 2026-10-06 | claude | rea | ui-right-drawer

## Task
Owner is adding a right `<el-drawer>` to `REA_UI`'s `DefaultLayout.vue` (uncommitted: `Upload`
button + inline drawer on a local `ref`) and wants it global: any button opens it, content replaced
per scenario, the layout changed as little as possible ahead of plan ui-layout-routing.

## Done
- Read the working copy (`REA_UI@04016d3` + owner's diff), router, `App.vue`, `main.js` (Pinia
  installed), `stores/payment.js`, `AdvancedSearchDialog.vue`, `DefaultLayout.test.js`.
- Designed: Pinia store `rightDrawer` (`visible`, `shallowRef` component, `props`, `title`, `size`;
  `open`/`close`/`reset`) + host `components/common/RightDrawer.vue` holding the single
  `<el-drawer>` and `<component :is>`; layout keeps two tags (button, `<RightDrawer />`).
- Wrote the files, the two edits (`edits.patch`) and three test files to gitignored
  `.agents/scratch/ui-right-drawer/`; ran them in a scratch overlay (symlinked child
  `node_modules`, own `vitest.config.js`): 9 tests green, eslint clean with the child's config.
- Plan ui-right-drawer (draft) carries the design and self-contained steps. No child write.

## Decisions & pitfalls
- Store over provide/inject or `Teleport`: callable from any depth or plain JS; `el-drawer`'s body
  is lazy / `destroy-on-close`, so a `Teleport` target would often not exist.
- Adding a store to `DefaultLayout.vue` breaks its existing test (`useRightDrawerStore()` needs an
  active pinia): the plan adds `createTestingPinia` and stubs `RightDrawer` there.
- The child's `eslint ./src` ignores files outside its base path; lint scratch files by copying
  `eslint.config.js` + `.eslint-auto-import.js` next to them, not with `-c` from the child.
- Owner asked composable vs store, then for sourced research. Vue's state-management guide allows
  a module-scoped reactive store and reserves Pinia for devtools/HMR/SSR/team conventions; Pinia's own
  intro lists testing utilities and devtools as its edge; Nuxt UI `useOverlay` and Quasar's Dialog
  plugin both use a shared singleton + `component`/`props` + the panel emitting `close`, the shape
  the plan already has. Decision still the owner's; the plan is unchanged until then.
- `echo =====` fails in zsh (`=` triggers filename expansion); quote such separators.

## TODO
- Owner: sign the plan (`Writes: REA_UI (develop)`), then apply from scratch or by the steps; the
  scratch copy is disposable — the plan's steps are the record.
- A real drawer scenario (進階查詢代碼 as a drawer body) is a later plan.

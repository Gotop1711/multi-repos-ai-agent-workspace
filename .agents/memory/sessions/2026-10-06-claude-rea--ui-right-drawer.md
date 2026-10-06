# 2026-10-06 | claude | rea | ui-right-drawer

## Task
Owner wants `REA_UI`'s right `<el-drawer>` global: any button opens it, content replaced per
scenario, the layout changed as little as possible ahead of plan ui-layout-routing.

## Done
- Designed, first as a Pinia store, then — on the owner's choice after the research below — as
  `src/composables/useRightDrawer.js` with module-scoped state (`visible`, `shallowRef` component,
  `props`, `title`, `size`; `open` returns a Promise that `close(payload)` resolves; `reset`) + host
  `components/common/RightDrawer.vue` holding the single `<el-drawer>` and `<component :is>`;
  layout keeps two tags (button, `<RightDrawer />`). Files built and tested in gitignored
  `.agents/scratch/ui-right-drawer/` (overlay on the child's `node_modules`) before signing.
- Owner signed; first ship (`df5c227`, one commit with a placeholder panel) was reviewed and
  withdrawn: workspace reset to `5c5dabc`, child to `04016d3`. Reshipped per review as two commits,
  no placeholder, usage in comments. `Writes:`/`Signed:` lines carried over on the owner's word.
- Plan revised to match; rea-ui › Layout and Branches record the drawer and the new head.

## Decisions & pitfalls
- Composable vs store, researched at the owner's ask: Vue's guide allows a module-scoped store and
  reserves Pinia for devtools/HMR/SSR; Nuxt UI `useOverlay` and Quasar's Dialog plugin use a shared
  singleton + `component`/`props` + the panel emitting `close`. Owner chose the composable.
- Rejected provide/inject (tree position) and `Teleport` (drawer body is lazy / destroy-on-close).
- Refs inside a nested object do not unwrap in templates: the host destructures the composable at
  top level. Module state outlives a test: `reset()` in every `beforeEach`.
- The child's `eslint ./src` ignores files outside its base path; lint scratch files by copying the
  config trio (`eslint.config.js`, `.eslint-auto-import.js`, `.eslintrc-auto-import.json`) beside them.
- `check` derives `Status:` — a `Shipped:` line with `Status: signed` fails the closeout commit.

## TODO
- Owner: Done-when in the browser (`npm run dev`, aside button → empty drawer → ×), push `develop`,
  then `Verified:`; `plan done` follows.
- A real panel (進階查詢代碼 as a drawer body) is a later plan.

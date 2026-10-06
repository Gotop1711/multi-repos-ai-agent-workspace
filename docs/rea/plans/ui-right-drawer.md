# rea — ui-right-drawer: one global right drawer, its content chosen per scenario

Status: shipped
Writes: REA_UI (develop)
Signed: gotop1711 — 2026-10-06
Shipped: 2026-10-06 — REA_UI@7d13a95, REA_UI@b7e7073 (develop, unpushed)

## Goal
The frame's right aside is empty at `REA_UI@04016d3 src/layouts/DefaultLayout.vue:45`; the owner's
first try (2026-10-06, since reverted) put an `Upload` button and an inline `<el-drawer>` there,
toggled by a local `ref`, so only that one button in that one file could open it. Wanted: one
`<el-drawer>` for the whole app, opened by any button anywhere, its body swapped per scenario, and
the layout touched as little as possible because plan ui-layout-routing will rewrite it. Design,
chosen by the owner after a sourced comparison (session log): a composable with module-scoped state,
`src/composables/useRightDrawer.js` — `visible`, `component` (a `shallowRef`, `markRaw`ed), `props`,
`title`, `size` live at module level, so every caller shares one drawer; `open(component, { props,
title, size })` shows it and returns a Promise, `close(payload)` hides it and resolves that Promise
with the payload, `reset()` clears content. A host `components/common/RightDrawer.vue` is the single
`<el-drawer>` (`destroy-on-close`, `@closed` → `reset`) rendering `<component :is>` and wiring the
panel's `close` emit to `close`. A button anywhere does `useRightDrawer().open(SomePanel, { title })`.
This is the shape of Nuxt UI's `useOverlay` and Quasar's Dialog plugin; the Vue guide sanctions a
module-scoped store for shared state and reserves Pinia for devtools, HMR and SSR, none of which this
toggle needs. The repo's other composable (`usePaymentState.js`) is per-call, so the file's header
says it is a singleton and shows the call. No panel ships with this plan: the layout's button opens
an empty drawer and a comment shows the real call. The layout's share is two tags, which move with
any rewrite.

## Writes
`REA_UI (develop)`, two commits. New: `src/composables/useRightDrawer.js`,
`src/components/common/RightDrawer.vue`, `tests/unit/composables/useRightDrawer.test.js`,
`tests/unit/components/common/RightDrawer.test.js`. Edited: `src/layouts/DefaultLayout.vue`
(aside-right only) and `tests/unit/layouts/DefaultLayout.test.js`. No router, view, store or shell
change. Ready-made files sit in gitignored `.agents/scratch/ui-right-drawer/`; the steps below are
complete without them.

## Steps
1. Commit 1 — composable and host, mounted nowhere yet. `useRightDrawer.js`: the five refs and a
   `resolveClose` slot at module scope; `open` settles any earlier waiter, sets the refs (`markRaw`
   the component, defaults `''` / `{}` / `'30%'`; no component → empty drawer), shows, returns
   `new Promise`; `close(payload)` hides and resolves; `reset` clears the refs and resolves a
   still-pending Promise with `undefined` (the user closed by mask or ×). The header comment is the
   usage guide: import, `const { open } = useRightDrawer()`, `await open(SomePanel, { props, title,
   size })`, panel `emit('close', payload)`. `RightDrawer.vue`: destructure the composable at top
   level (refs in a nested object do not unwrap in templates), then `<el-drawer v-model="visible"
   :title :size direction="rtl" destroy-on-close @closed="reset">` around `<component :is="component"
   v-if="component" v-bind="panelProps" @close="close" />`. Tests: composable (two calls share
   state; open sets state; second open replaces and restores defaults; `open()` alone opens empty;
   the Promise resolves with `close`'s payload; `reset` resolves `undefined` and clears); host
   (empty until `open`, renders panel with props/title/size, panel `close` hides and resolves,
   `closed` clears) with `ElDrawer` stubbed. Module state outlives a test: `useRightDrawer().reset()`
   in every `beforeEach`.
2. Commit 2 — the layout. In `DefaultLayout.vue` aside-right: a template comment naming
   `<RightDrawer />` as the app's one drawer and showing `openRightDrawer(SomePanel, { props, title,
   size })`; an `Upload` `el-button` whose click is `openRightDrawer()` (empty drawer, no content);
   `<RightDrawer />`; `const { open: openRightDrawer } = useRightDrawer()`. `DefaultLayout.test.js`
   adds a `RightDrawer` stub. `npx vitest run`, `npm run lint`, `npm run build` green before each.
3. Not here: a real panel. The first candidate is 進階查詢代碼 (`src/views/AddOn.vue:107`,
   `src/views/Payment.vue:104`), today an `el-dialog` (`src/views/payment/AdvancedSearchDialog.vue`);
   as a panel under `src/components/drawers/` it would hand the chosen codes back through
   `close(payload)`. Its own plan, own write set. A drawer opened from inside the drawer needs
   `append-to-body` (Element Plus nested rule).

## Done when
Clicking the aside button opens the one drawer, empty, and × closes it; `DefaultLayout.vue` holds no
drawer state of its own and no panel; a view can open the drawer with a component and get the
panel's `close` payload back from `open()`; suite, lint and build pass at both commits; rea-ui ›
Layout cites the shipped commits.

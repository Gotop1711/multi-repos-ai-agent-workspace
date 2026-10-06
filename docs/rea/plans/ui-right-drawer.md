# rea — ui-right-drawer: one global right drawer, its content chosen per scenario

Status: draft

## Goal
The frame's right aside is empty at `REA_UI@04016d3 src/layouts/DefaultLayout.vue:45`; the owner's
uncommitted working copy (2026-10-06) puts an `Upload` button and an inline `<el-drawer>` there,
toggled by a local `ref`, so only that one button in that one file can open it. Wanted: one
`<el-drawer>` for the whole app, opened by any button anywhere, its body swapped per scenario, and
the layout touched as little as possible because plan ui-layout-routing will rewrite it. Design: a
Pinia store `rightDrawer` holds `visible`, `component` (a `shallowRef`, `markRaw`ed), `props`,
`title`, `size`, with `open(component, { props, title, size })`, `close()`, `reset()`; a host
`components/common/RightDrawer.vue` is the single `<el-drawer>` (`destroy-on-close`, `@closed` →
`reset`) rendering `<component :is>` and turning the panel's `close` emit into `close()`. A button
anywhere does `useRightDrawerStore().open(SomePanel, { title })`. A store rather than
provide/inject or `Teleport`: it works from any depth and from plain JS, needs no slot target
inside the lazily rendered drawer body, and Pinia is already installed (`src/main.js:21`) with
`src/stores/payment.js` as the convention. The layout's share is two tags: the button and
`<RightDrawer />`; when the layout is rewritten they move with it.

## Writes
`REA_UI (develop)`. New: `src/stores/rightDrawer.js`, `src/components/common/RightDrawer.vue`,
`src/components/drawers/RightDrawerPlaceholder.vue`, `tests/unit/stores/rightDrawer.test.js`,
`tests/unit/components/common/RightDrawer.test.js`. Edited: `src/layouts/DefaultLayout.vue`
(aside-right only) and `tests/unit/layouts/DefaultLayout.test.js`. No router, view or shell change.
Ready-made files and `edits.patch` sit in gitignored `.agents/scratch/ui-right-drawer/`; the steps
below are complete without them.

## Steps
1. `src/stores/rightDrawer.js`: `defineStore('rightDrawer', () => …)` with the five state refs
   above; `open` sets them (`markRaw` the component, defaults `''` / `{}` / `'30%'`) and shows;
   `close` hides only; `reset` clears content so the next `open` never flashes the previous panel.
2. `src/components/common/RightDrawer.vue`: `<el-drawer v-model="drawer.visible" :title :size
   direction="rtl" destroy-on-close @closed="drawer.reset">` around `<component :is="drawer.component"
   v-if="drawer.component" v-bind="drawer.props" @close="drawer.close" />`.
3. `src/components/drawers/RightDrawerPlaceholder.vue`: the owner's placeholder text as a `message`
   prop and a 關閉 button that emits `close` — the model every scenario panel follows (one file per
   scenario under `src/components/drawers/`). In `DefaultLayout.vue` the aside-right button becomes
   `@click="rightDrawer.open(RightDrawerPlaceholder, { title: '右側面板' })"`, the inline drawer
   becomes `<RightDrawer />`, `isRightDrawerVisible` becomes `const rightDrawer = useRightDrawerStore()`.
4. Tests: store (open sets state, second open replaces, close keeps content, reset clears); host
   (empty until `open`, renders panel with props/title/size, panel `close` hides, `closed` clears)
   with `ElDrawer` stubbed; `DefaultLayout.test.js` gains `createTestingPinia({ createSpy: vi.fn })`
   in `global.plugins` and stubs `RightDrawer`, else `useRightDrawerStore()` throws without a pinia.
   The three files ran green (9 tests) and lint-clean against the child's `node_modules` and
   `eslint.config.js` in a scratch overlay on 2026-10-06; run `npx vitest run`, `npm run lint`,
   `npm run build` in the child after applying.
5. Not here: moving a real feature in. The first candidate is 進階查詢代碼 (`src/views/AddOn.vue:107`,
   `src/views/Payment.vue:104`), today an `el-dialog` (`src/views/payment/AdvancedSearchDialog.vue`);
   giving it a drawer body is its own plan with its own write set.

## Done when
Clicking the aside button opens the one drawer with the placeholder and its 關閉 closes it; a second
`open` with another component shows that component without a flash of the first; `DefaultLayout.vue`
holds no drawer state of its own; suite, lint and build pass; rea-ui › Layout cites the shipped commit.

# rea — ui-layout-routing: the tab frame becomes a layout, the tabs become routes

Status: draft

## Goal
`src/layouts/DefaultLayout.vue` is not a layout. It has no `<router-view>` or `<slot>`; it is the
route component of `/`; and it imports `Payment.vue` and `AddOn.vue` into two of its four
`el-tab-pane`s (`REA_UI@04016d3 src/layouts/DefaultLayout.vue:17,36-39`, `src/router/index.js:4-8`).
The second route, `/payment`, renders `Payment.vue` bare, outside the frame (`src/router/index.js:9-13`),
and nothing in `src/` navigates to it. Both files are the 2026-06-18 scaffold (`f7a2f0f`). The
convention the folder name promises — Nuxt's `layouts/`, and the regulation's own shell router
(nhia-frontend-standard › Architecture, `R.p54`) — is that a layout wraps pages and is never itself a
page: it draws the frame around a `<slot>` / `<router-view>`, and each page is a route beneath it.
Make REA follow it without a new package: the tab strip and the asides stay in the layout, each tab
is a child route, `/payment` is the default child, and the 加成 dirty guard becomes a route guard.
Stand-alone behaviour is unchanged; plan federation-remote then exposes the same child routes.

## Writes
`REA_UI (develop)`: `src/layouts/DefaultLayout.vue`, `src/router/index.js`,
`src/router/subSystemRouter.js`, `src/views/AddOn.vue`, two placeholder views,
`tests/unit/layouts/DefaultLayout.test.js`, `tests/unit/views/addOn/AddOn.test.js`. Nothing in the
shell; nothing in `frontend.conf` (`try_files … /index.html`, `frontend.conf:43`, already serves any path).

## Steps
1. Routes (`src/router/index.js`): one parent `{ path: '/', component: DefaultLayout, redirect:
   '/payment', children: [...] }` with four children — `payment` (`Payment.vue`, `meta.tab: 'pay'`),
   `materials` (`'mats'`), `drugs` (`'drug'`), `add-on` (`AddOn.vue`, `'addOn'`) — the shape the shell's
   router has (`R.p54`). Components stay lazy `import()` (R L874–889). `src/views/Materials.vue` and
   `src/views/Drugs.vue` hold the placeholder text the empty panes show today.
2. Layout (`DefaultLayout.vue`): keep `el-container`, both asides and `el-tabs`; remove the four embedded
   components; the panes are empty and one `<router-view>` sits under the tab strip. `activeTab` is
   computed from `route.meta.tab`; `@tab-change` calls `router.push({ name })`. `:before-leave`,
   `addOnRef` and `addOnDirty` go. The file keeps its name: it is the name the regulation's shell uses.
3. Guard: `AddOn.vue` registers `onBeforeRouteLeave` with the same `ElMessageBox.confirm`, the same
   `discardBoardChanges()` on confirm and `return false` on cancel. That also covers browser back and a
   typed URL, which the tab hook never did. `dirty-change` and `defineExpose` are then unused: remove.
4. State across tabs: today Payment and AddOn stay mounted while another tab shows; as routes they
   unmount. Payment's page state is component-local (`src/views/Payment.vue:465-487`,
   `src/composables/usePaymentState.js`), so wrap the layout's `<router-view>` in `<KeepAlive>`
   (`v-slot="{ Component }"` + `<component :is="Component">`) and an edit in progress survives a tab
   switch. The owner may instead rule that a tab switch resets the page; then no `KeepAlive`.
5. `src/router/subSystemRouter.js`: export the same four children under `path: ''` + `App.vue`
   (`R.p52`), importing one shared route table from `index.js` rather than keeping a second copy.
6. Tests: the three dirty-guard cases move from `DefaultLayout.test.js` to `AddOn.test.js` against
   `onBeforeRouteLeave`; a router test asserts `/` redirects to `/payment` inside the layout and each
   `meta.tab` names exactly one route. `npx vitest run`, `npm run lint`, `npm run build`.

## Done when
`DefaultLayout.vue` imports no view; every view is reached only through a child route of `/`;
`/`, `/payment` and `/add-on` all render inside the frame; leaving 加成 with unsaved changes asks
the same question by route guard; suite, lint and build pass; rea-ui › Layout cites the shipped commit.

# 2026-10-06 | claude | rea | ui-layout-routing

## Task
Owner asks whether `src/layouts/DefaultLayout.vue` in `REA_UI` is used the way a layout should be,
with Nuxt's conventions as the yardstick, and for a refactor if one is needed.

## Done
- Read `REA_UI@04016d3` (`develop`): `DefaultLayout.vue` is the route component of `/`, has no
  `<router-view>`, embeds `Payment.vue` and `AddOn.vue` in tab panes; `/payment` renders `Payment.vue`
  bare and nothing navigates to it; `subSystemRouter.js` is an unused second route table. All from the
  scaffold `f7a2f0f`. Recorded in rea-ui › Layout; `develop` moved to `04016d3` by the owner's own
  four layout commits, Branches line updated.
- Nuxt (nuxt.com, 4.x `layouts/`, `pages/`, `NuxtLayout`): a layout wraps pages through `<slot/>`,
  `app.vue` holds `NuxtLayout` around `NuxtPage`, a page picks its layout by `definePageMeta`;
  a layout is never a route target. Plain Vue Router's equivalent is a parent route whose component
  renders `<router-view>` over `children`.
- The regulation's own shell router (`R.p54`) uses exactly that: `component: DefaultLayout` with
  `children`. Added to nhia-frontend-standard › Architecture.
- Created draft plan ui-layout-routing: tabs become child routes of `/` under the layout, `/` redirects
  to `/payment`, the 加成 dirty guard becomes `onBeforeRouteLeave`, `KeepAlive` keeps an edit across
  tabs, `subSystemRouter.js` shares the one route table. No child write.

## Decisions & pitfalls
- The premise "the folder imitates Nuxt" is half right: `layouts/` is the regulation's prescribed
  tree (R L639, L651) and the shell template's `DefaultLayout`; the scaffold copied the name and not
  the pattern. The fix needs no package (vite-plugin-vue-layouts would breach the whitelist rule).
- Routes unmount pages; the tabs keep both mounted today. Payment's state is component-local, so
  the plan uses `KeepAlive` unless the owner rules a tab switch may reset the page (step 4).
- `nuxt.com/docs/guide/directory-structure/layouts` is 404; the 4.x paths are
  `/docs/4.x/guide/directory-structure/app/{layouts,pages}` and `/docs/4.x/api/components/nuxt-layout`.
- `develop` (`04016d3`) still has the special Payment proxy that plan nhia-vm-ui-routing removed on
  `feature-nhi-deployment` only; not this task's — reported, not changed.

## TODO
- Owner: rule on step 4 (`KeepAlive` or reset), then sign the plan with `Writes: REA_UI (develop)`.

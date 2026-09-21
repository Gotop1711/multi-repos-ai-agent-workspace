# rea — federation-remote: the ui becomes a Module Federation remote

Status: draft

## Goal
`REA_UI` is loaded by the 醫療資訊系統 shell as a Module Federation remote and drops its own frame, as
the owner ruled on 2026-09-21 (nhia-frontend-standard › Rulings). Today it is a stand-alone SPA: its
own `DefaultLayout.vue` and router, its own nginx, the federation plugin a dependency
`vite.config.js` never loads, and `src/router/subSystemRouter.js` — the file the regulation has a
subsystem expose — present since the first commit, listing only the Payment view, imported nowhere
(`REA_UI@5721638`). When this ships, the shell owns login, header, menu and breadcrumb (附件二 items
4–8, nhia-ui-design), and REA renders inside the 子系統工作區.

## Writes
`REA_UI (develop)`. Nothing in the shell, which is another team's; what REA must hand over is a
`remoteEntry.js` and a route array.

## Steps
1. Owner obtains from the shell's team: the host's federation name and the remotes it expects, the
   route path REA is mounted at and deployed under (the template serves a Vue app under `/<route
   path>/`, so `base: '/'` must change: nhia-frontend-standard › Architecture), which dependencies are shared as singletons, whether the shell serves
   REA's assets or REA is deployed separately, and how the shell passes the user token (this overlaps
   bff › Token and Keycloak: deferred).
2. `vite.config.js` loads `@originjs/vite-plugin-federation` (already a dependency, `package.json:33`)
   with `name`, `filename: remoteEntry.js`, `exposes` pointing at `./src/router/subSystemRouter.js`,
   and `shared` listing `vue`, `vue-router`, `pinia` as singletons — the shape the regulation's own
   screens show (nhia-frontend-standard › Architecture).
3. `subSystemRouter.js` is rewritten to the real routes: the rule list, the rule editor and Payment,
   not the placeholder Payment-only array it carries now.
4. The frame goes: `DefaultLayout.vue` and whatever of the header, menu and breadcrumb it draws, and
   the routes in `src/router/index.js` that exist only to host them. `src/main.js` keeps a stand-alone
   entry for `npm run dev` with the mock, or the repo documents how to run it against the shell.
5. Styles are namespaced so nothing leaks into the shell: `scoped` in every SFC, no global override of
   Element Plus (R L665–666, L741–744).
6. Tests: the existing `vitest` suite keeps passing, plus a test that the exposed route array matches
   the views it names.

## Done when
The shell loads REA at its route and the editor works inside the shell's frame; REA's own header and
menu are gone; `npx vitest run` and `npm run lint` pass; nhia-frontend-standard › Architecture records
what the ui exposes, cited at the shipped commit.

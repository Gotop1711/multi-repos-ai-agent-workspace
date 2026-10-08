# rea — payment-local: the ui answers the two Payment lookups itself, in every build

Status: draft

## Goal
`POST /api/v1/Payment/Item/Get` and `/Detail/Get` never leave the browser: the ui resolves both from
a frozen data set compiled into the app, always `result: true`, in `npm run dev` and in the
production image alike. Why: nothing answers those paths — the dev proxy and the image send every
`/api/*` to `nhi-claimvalidator:8080`, which has no Payment yet (`REA_UI@2d2c40e frontend.conf:7-15`,
rea-ui › Deployment), so no order code can be chosen and the editor is unusable (owner, 2026-10-08).
The dev-server mock plugin cannot do this: it runs under `serve` only (`vite.config.js:27`). The data is
known: `REA_PROTO_PAYMENT_SNAPSHOT@e22769a data/paymentData.json` (8,686 rows, 4.4 MB) with
`src/handlers.js` reproduces the stopped host's answers byte for byte
(`docs/rea/rea-proto-be/sources/2026-09-30-post-payment-item-get-response.json.md@82b9f9adcd5c`,
`…-detail-get-request-payload.json.md@8ab75bf25fb2`, `…-detail-get-response.json.md@ad02e1bca5e4`;
rea-proto-payment-snapshot › Integration). The one known difference stays: `ruleStartDate`
`0001-01-01`, `ruleEndDate` `9999-12-31`, `ruleDateHistory` `[]` on every row; `Payment.vue`
overwrites the start date from the `RuleSet` it loads (`src/views/Payment.vue:768-784`). Two things
change for the user: no global loading overlay while `Detail/Get` resolves (it was axios-tracked,
`src/api/interceptors.js:52-140`; the four views keep their own `loading`), and one 4.4 MB hashed
chunk fetched on the first lookup — the start-up preload (`src/stores/payment.js:48-80`) — then
browser-cached like every other asset (`frontend.conf:25-28`).

## Writes
`REA_UI (develop)` only. Nothing in `REA_PROTO_PAYMENT_SNAPSHOT` (its data and handler are copied,
not moved) and nothing in `REA_kernel`. Assumed: `feature-nhi-deployment` takes the result by the
owner's rebase, as on 2026-10-07 — the two commits touch no file of `2d2c40e` except `.gitlab-ci.yml`,
one unrelated hunk.

## Steps
1. One commit, the resolver. `src/utils/payment/local/paymentData.json` — the snapshot's file as is,
   the commit message naming `REA_PROTO_PAYMENT_SNAPSHOT@e22769a` and `REA_PROTO_BE@ba161ff
   SeedData/` as provenance. `src/utils/payment/local/handlers.js` — the snapshot's `src/handlers.js`
   minus its route matcher and path constants (`:142-157`), under `utils/payment/` because it is
   domain code (rea-ui › Folders). `src/utils/payment/local/index.js` — `loadRows()`: one cached
   `import('./paymentData.json')` so Vite emits the data as its own chunk in build and serves it in
   dev; `getOrderCodeItemLocal(params)` / `getOrderCodeListLocal(params)` return
   `{ result: true, data, message: '' }`.
2. Same commit, the switch. `src/api/modules/payment/index.ts:16-33`: when
   `import.meta.env.VITE_PAYMENT_LOCAL !== 'false'` each function returns the local answer, else
   `request.Post` as today. `.env.development:7` and `.env.production:4` gain
   `VITE_PAYMENT_LOCAL=true` with a comment naming the missing backend — the value is baked in at
   build, so the production image carries it; when the kernel provides Payment the owner flips one
   line per file. Nothing else in `src/` changes: the store and the four views already read the
   envelope (`src/stores/payment.js:22-34`, `Payment.vue:793-798`, `AddOn.vue:601-606`,
   `payment/AdvancedSearchDialog.vue:438-450`, `payment/CopyRuleDialog.vue:444-456`).
3. Same commit, tests. `tests/unit/utils/payment/localHandlers.test.js` — the snapshot's
   `test/handlers.test.mjs` cases ported to vitest on its five-row fixture (keyword filter, the
   `null`-versus-`[]` rule, paging, the four label maps, the dates). `tests/unit/api/modules/
   payment.test.js` rewritten: flag on (default) — `request.Post` never called, `""` yields 8,686
   items, `01116B` with the captured payload equals the captured row, inlined; flag off
   (`vi.stubEnv`) — today's URL, params and `showGlobalLoading` cases. `npm run lint`, `npx vitest
   run`, `npm run build` green; the chunk sizes noted in the commit body.
4. Second commit, CI. `.gitlab-ci.yml:136-144`: the smoke test no longer requires the backend's
   `Payment/Item/Get` at 200 — the ui does not call it, and the kernel's 404 would fail every push to
   `develop`. The `RuleSchema` probe stays. Owner may strike this step at signing.
5. After shipping, the docs: rea-ui (Run / test, Entry points, Deployment), ui-deployment (the
   pipeline), bff (the external Payment host is now inside the ui). Plan nhia-vm-ui-routing's last
   Done-when clause is overtaken — reported in the log, not edited.

## Done when
`npm run dev` with `VITE_USE_MOCK=false` and an unreachable `VITE_DEV_PROXY_TARGET`: the network
panel shows no `Payment/` request, the code list holds 8,686 entries, two typed characters filter it,
picking a code unlocks 查詢 and the row shows chapter, points and labels, 進階查詢 pages, the 加成
tab searches. `npm run build && npm run preview` (production mode, `app-env` production) does the
same. The image built from the commit, run with no backend (ui-deployment › Checking the image by
hand, step 2), does the same in a browser while `/api/v1/RuleSchema` still answers 502. Lint, tests
and build pass. Checked here before `Shipped:`: `getOrderCodeItemLocal({ keyword: '' }).data` equals
the capture `@82b9f9adcd5c` and `getOrderCodeListLocal` for the payload `@8ab75bf25fb2` equals
`@ad02e1bca5e4` as JSON.

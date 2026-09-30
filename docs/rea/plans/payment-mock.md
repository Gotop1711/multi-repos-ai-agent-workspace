# rea — payment-mock: the dev server answers the two Payment lookups from the mock plugin

Status: draft

## Goal
`npm run dev` serves `POST /api/v1/Payment/Item/Get` and `/Detail/Get` from `mock/`, while every
other `/api` request still goes through the proxy to the kernel. Why: the Azure host both proxies
point at has been stopped since 2026-09-30, so no order code can be chosen and the editor is
unreachable (rea-ui › Deployment). Owner's ruling, 2026-09-30: only the Payment paths move, and the
mock serves what that host served. No capture of its answers exists — `REA_PROTO@3fdf47c
tests/mock/api/orderCodeItem.json` and `orderCodeList.json` are hand-written samples of three rows —
so "what it served" is rebuilt the only way it can be: the host runs `REA_PROTO_BE`'s code
(rea-proto-be › Integration), whose `Development` mode answers both lookups from
`SeedData/seed_data_mhct_payment.csv` (9,411 rows) and `seed_data_mhct_payitems.csv` (29,146 rows;
`REA_PROTO_BE@ba161ff Program.cs:19-29,92-102`) through `Services/PaymentService.cs:29-66,72-183`.
The mock replays those queries on that seed. Inferred, not known: that the host ran in `Development`
on this seed rather than on Oracle; the seed is real reference data, the same tables.

## Writes
`REA_UI (develop)` only. Nothing in `REA_PROTO_BE` (read-only): its two CSVs are read once by a
generator and the result is committed to the ui. `frontend.conf` does not change — the deployed
site keeps its dead route until the host returns or plan bff lands.

## Steps
1. `mock/build-payment-data.mjs` (`node mock/build-payment-data.mjs <dir-with-the-two-csv>`), writing
   `mock/paymentData.json`: one object per `TREAT_CODE` — the `MHCT_PAYITEMS` row with the newest
   `PAY_S_DATE` (`PaymentService.cs:31-37,92-97`; dates are `dd-MMM-yy`, `CsvDataSeeder.cs:224-225`)
   joined to its `MHCT_PAYMENT` row (`:99-107`) — holding the seed's raw fields the two lookups read:
   `treatCode`, `paySDate`, `payEDate` (as `yyyy-MM-dd`), `cureCname`, `cureEname`, `cureMemo`,
   `payPrice`, `payPriceOld`, `no`, `annType`, `treatChapCode`, `treatType`, `cureFeeType`, `cntType`,
   `excldInspPart`. 8,686 rows, about 3.3 MB (measured in session). Committed with the file; the
   generator is not run by the dev server.
2. `mock/payment.js` — two handlers that reproduce the service, and nothing more:
   - `Item/Get`: `keyword` trimmed; empty → every row; else rows whose `treatCode` or `cureCname`
     contains it (ordinal); ordered by `treatCode`; `[{ itemCode, nameZh }]` (`:46-64`).
   - `Detail/Get`: `itemCodes` null and the four strings blank → an empty page (`:74-88`; the ui
     sends `[]`, which is not null, so a blank 進階查詢 pages through everything — as the service
     does); non-blank `itemCodes` filter by code; `keyword` over `cureCname`, `cureEname`,
     `cureMemo`, `treatCode`; `nameZh`, `nameEn`, `note` each over its field (`:109-142`); ordered by
     `treatCode`; paged `pageNumber` (default 1) / `pageSize` (default 10), `id` = offset + 1,
     `totalPages` = ceiling (`Extensions/QueryableExtensions.cs:55-73`); each row mapped as
     `:211-235` with the four label maps copied from `:350-419`; `isCheckFeeExcluded` = `Y`.
   - The known difference: `ruleStartDate` `0001-01-01`, `ruleEndDate` `9999-12-31`,
     `ruleDateHistory` `[]` for every row — the service reads them from the prototype's MongoDB
     `rule` collection (`:243-268`), which nothing here holds; the ui overwrites the start date from
     the `RuleSet` it loads (`src/views/Payment.vue:645-647`).
3. Wiring. `mock/index.js` takes `{ rules, payment }`; `vite.config.js:27` installs the plugin under
   `serve` when either is on: `rules` = `VITE_USE_MOCK !== 'false'` as today, `payment` =
   `VITE_MOCK_PAYMENT === 'true'`. `.env.development` gains `VITE_MOCK_PAYMENT=true` with a comment
   naming the stopped host as the reason. The two proxy entries stay: a plugin middleware runs before
   the proxy, which is why today's `RuleSet` mock coexists with the `/api` proxy (`vite.config.js:27`,
   `:64-68`), so `VITE_MOCK_PAYMENT=false` sends Payment back to the Azure host without another edit.
4. `tests/unit/mock/payment.test.js` on a five-row inline fixture: empty keyword returns all; the
   keyword filter; the null-versus-`[]` rule; paging (`id`, `totalPages`); every label map; the date
   strings. `npx vitest run` and `npm run lint` green (`lint` covers `src/` only).
5. Rebuild `paymentData.json` only when the seed changes; the commit says which `REA_PROTO_BE` sha.

## Done when
With `VITE_USE_MOCK=false` and `VITE_MOCK_PAYMENT=true`, the network panel shows `Item/Get` 200 from
`:5173` with 8,686 rows and `RuleSchema` still answered by the kernel; two typed characters filter the
list; picking a code unlocks 查詢 and `Detail/Get` shows that code's seed row with its chapter,
points and labels; 進階查詢 pages; the 加成 tab searches; `VITE_MOCK_PAYMENT=false` restores the
proxy (and its 403 while the host is down); `git grep` finds no new host name; tests and lint pass.

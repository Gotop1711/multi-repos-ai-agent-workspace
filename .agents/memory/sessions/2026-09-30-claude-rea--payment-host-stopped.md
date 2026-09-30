# 2026-09-30 | claude | rea | payment-host-stopped

## Task
Owner reports `POST /api/v1/Payment/Item/Get` answering `403 Site Disabled` from the dev server,
so 診療項目代碼 cannot be chosen and everything after the search is blocked; asks whether
`REA_kernel` now implements the Payment APIs.

## Done
- Confirmed by `curl` (not captured): the Azure host answers 403 at its root and at the endpoint;
  `:8081` (the deployed ui) relays the same 403; `:8080` (the kernel) answers 404.
- Kernel at `6540a4c`: four controllers, no Payment route, the word absent from `src/`, absent
  from the 2026-09-30 swagger, no commit mentions it. Answer: no.
- Traced the blockage in the ui: store → `OrderCodes` → locked 查詢; `Detail/Get` callers (four)
  dead too; `mock/index.js` serves no Payment path. Only `REA_PROTO_BE` implements the two paths.
- Written: rea-ui › Deployment (the stopped host, the blocked chain, the kernel's silence),
  bff › What the ui does today (the cost of the hard-wired route), rea-proto-be › Integration
  (the stand-in and what each lookup needs in `Development`).

- Owner chose a mock for the Payment paths alone, serving what the Azure host served: plan
  payment-mock drafted — a generator over `REA_PROTO_BE`'s two seed CSVs, two handlers replaying
  `PaymentService.cs`, a `VITE_MOCK_PAYMENT` flag beside `VITE_USE_MOCK`; awaits `Signed:`.

## Decisions & pitfalls
- Three ways out were offered: restart the Azure app (no write), a local `REA_PROTO_BE` behind
  the dev proxy (needs MongoDB for `Detail/Get`), or the mock. Plan bff, step 3, is the lasting fix.
- "Exact data" has no capture to rest on: `REA_PROTO`'s fixtures are three hand-written rows. The
  seed replayed through the service's own queries is the closest thing; whether the host ran on
  the seed or on Oracle is inferred. The prototype's MongoDB rule dates cannot be reproduced.
- Sizes measured in session: 8,686 codes; `Item/Get` for all ≈ 0.47 MB; the joined table ≈ 3.3 MB.
- Not run: `REA_PROTO_BE` (no .NET SDK here, and the rule is read source). Its Development path
  is inferred from `Program.cs` and `PaymentService.cs`.
- `grep --include=*.cs` in zsh needs quotes: the first kernel grep silently never ran.
- rea-proto-be sits at its 100-line cap: two lines were all it could take.

## TODO
- Owner: pick the fix; if it touches `REA_UI`, say so and a plan follows. The data-creator
  acceptance plan posts to the same host and is blocked until it runs again.
- Earlier items stand: push `develop` and `rea`; `Verified:` on three shipped plans.

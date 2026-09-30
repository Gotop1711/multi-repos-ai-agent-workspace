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

## Decisions & pitfalls
- No plan filed: the fix is the owner's choice — restart the Azure app (outside the fleet, no
  write), or point `VITE_DEV_PAYMENT_PROXY_TARGET` at a local `REA_PROTO_BE` run (a `REA_UI`
  write; `Detail/Get` needs MongoDB there), or add Payment routes to `mock/index.js` (a `REA_UI`
  write; `VITE_USE_MOCK=true` then also replaces the kernel). Plan bff, step 3, is the lasting fix.
- Not run: `REA_PROTO_BE` (no .NET SDK here, and the rule is read source). Its Development path
  is inferred from `Program.cs` and `PaymentService.cs`.
- `grep --include=*.cs` in zsh needs quotes: the first kernel grep silently never ran.
- rea-proto-be sits at its 100-line cap: two lines were all it could take.

## TODO
- Owner: pick the fix; if it touches `REA_UI`, say so and a plan follows. The data-creator
  acceptance plan posts to the same host and is blocked until it runs again.
- Earlier items stand: push `develop` and `rea`; `Verified:` on three shipped plans.

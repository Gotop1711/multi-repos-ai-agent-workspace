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
- Traced the blockage: store → `OrderCodes` → locked 查詢; four `Detail/Get` callers dead too;
  `mock/index.js` serves no Payment path. Only `REA_PROTO_BE` implements the two paths.
- Written: rea-ui › Deployment (the stopped host, the blocked chain, the kernel's silence),
  bff › What the ui does today (the cost of the hard-wired route), rea-proto-be › Integration.
- Owner chose a mock for the Payment paths alone, serving what the Azure host served: plan
  payment-mock drafted — a generator over `REA_PROTO_BE`'s two seed CSVs, two handlers replaying
  `PaymentService.cs`, a `VITE_MOCK_PAYMENT` flag beside `VITE_USE_MOCK`; awaits `Signed:`.
- Owner then produced the host's last answers (three files, ingested as rea-proto-be sources): the
  seed replay equals them once `\n` in a field is `\r\n` — the host ran on this seed, established.
- Signed; shipped on `develop`: `58271d8` (generator, 4.4 MB `paymentData.json`), `8c52af5`
  (handlers, plugin option, 17 tests), `316318e` (flag, env). 1114 tests and lint green; both mock
  answers equal the captures as JSON; an in-process Vite run answered the POSTs and passed a GET
  through to the proxy (403). rea-ui, ui-deployment, bff updated. Not pushed.

## Decisions & pitfalls
- Offered: restart the Azure app, a local `REA_PROTO_BE` behind the dev proxy (needs MongoDB for
  `Detail/Get`), or the mock. Plan bff, step 3, is the lasting fix.
- `REA_PROTO`'s fixtures are three hand-written rows, not captures. First replay "differed" in 12
  names: Python's csv without `newline=''` folds `\r\n`; and this seed copy is LF-normalised
  (`i/lf`, no CR byte) while the host's data has CRLF — the generator must write CRLF back.
  The prototype's MongoDB rule dates are the one thing not reproducible (all "no rule" values).
- Not run: `REA_PROTO_BE` (no .NET SDK here; read source). `grep --include=*.cs` in zsh needs
  quotes: the first kernel grep silently never ran. rea-proto-be sits at its 100-line cap.

## TODO
- Owner: push `develop`; `npm run dev`, pick a code, search, 進階查詢, 加成; then `Verified:` on
  payment-mock. The data-creator acceptance plan posts to the stopped host: still blocked.
- Earlier items stand: push `develop` and `rea`; `Verified:` on three shipped plans.

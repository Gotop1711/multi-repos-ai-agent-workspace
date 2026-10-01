# 2026-09-30 | claude | rea | payment-host-stopped

## Task
Owner reports `POST /api/v1/Payment/Item/Get` answering `403 Site Disabled` from the dev server,
so 診療項目代碼 cannot be chosen and everything after the search is blocked; asks whether
`REA_kernel` now implements the Payment APIs; then, over 2026-10-01, how to fix the deployment too.

## Done
- `curl` (not captured): the Azure host 403 at root and endpoint; `:8081` relays it; `:8080` 404.
- Kernel at `6540a4c`: four controllers, no Payment route, the word absent from `src/` and the
  2026-09-30 swagger. Answer: no. Only `REA_PROTO_BE` implements the two paths.
- Written: rea-ui › Deployment, bff › What the ui does today, rea-proto-be › Integration,
  rea-kernel › Live deployment (its pipeline: same runner, same network, two containers, env-file).
- Plan payment-mock, signed and shipped: `58271d8` (generator, 4.4 MB `paymentData.json`), `8c52af5`
  (handlers, plugin option, 17 tests), `316318e` (`VITE_MOCK_PAYMENT`). Owner's captures of the
  host's last answers (three files, ingested as rea-proto-be sources) equal the seed replay once
  `\n` in a field is `\r\n`: the host ran on this seed. 1114 tests, lint, in-process Vite run green.
- Deployment, assessed over several rounds (a dev-mode build cannot help: the plugin is serve-only,
  `1283821`/`56446f6` tried it in August; ui-repo stand-in, own repo, `REA_PROTO_BE` re-hosted with
  MongoDB, in-cluster or external). Owner chose: own repo, Node + JSON, on App Platform; created
  `REA_PROTO_PAYMENT_SNAPSHOT`, signed. Shipped: `REA_PROTO_PAYMENT_SNAPSHOT@e22769a` (pushed on
  the owner's word; 21 `node --test` cases; Docker not built, no daemon), owner deployed it on App
  Platform, both lookups there equal the captures; `REA_UI@3aea51f` (upstream, dev proxy, smoke-test
  POST), `@69fe8b7` (dev mock removed); 1097 tests, lint, dev-proxy run green.

## Decisions & pitfalls
- `REA_PROTO`'s fixtures are three hand-written rows, not captures. Python's csv without
  `newline=''` folds `\r\n`; this seed copy is LF-normalised (`i/lf`) while the host's data has
  CRLF — the generator writes CRLF back. The prototype's MongoDB rule dates are not reproducible.
- First `clone` failed on access (this shell was `Jarvis-bookai`; the owner fixed SSH, now
  `Gotop1711`); the second on `git clone --branch main` of an empty upstream. Child initialised by
  hand (`git init -b main` + `origin`), no commit, as `clone` would for `remote: none`.
- Not run: `REA_PROTO_BE` (no .NET SDK; read source). Quote `--include=*.cs` in zsh.

## TODO
- Owner: push `develop`; the pipeline's smoke-test proves the deployed route; then `Verified:`.
- [workspace] `clone` fails for a `write` child whose upstream exists but is empty: `git clone
  --branch <default_branch>` needs the branch; fall back to `git init -b` + `remote add`.
- Owner: push `develop` and `rea`; `Verified:` on payment-mock and the three earlier shipped
  plans. The data-creator acceptance plan's host stays stopped; the snapshot does not unblock it.

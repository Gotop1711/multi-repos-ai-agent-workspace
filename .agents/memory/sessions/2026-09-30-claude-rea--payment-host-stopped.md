# 2026-09-30 | claude | rea | payment-host-stopped

## Task
Owner reports `POST /api/v1/Payment/Item/Get` answering `403 Site Disabled` from the dev server,
so 診療項目代碼 cannot be chosen and everything after the search is blocked; asks whether
`REA_kernel` now implements the Payment APIs; then, over 2026-10-01, how to fix the deployment too.

## Done
- `curl`: the Azure host 403 at root and endpoint; `:8081` relays it; `:8080` 404. Kernel at
  `6540a4c`: no Payment route anywhere. Answer: no. Only `REA_PROTO_BE` implements the two paths.
- Written: rea-ui, bff, rea-proto-be, rea-kernel › Live deployment (its pipeline, the pattern).
- Plan payment-mock, signed and shipped: `58271d8` (generator, 4.4 MB `paymentData.json`), `8c52af5`
  (handlers, plugin option, 17 tests), `316318e` (`VITE_MOCK_PAYMENT`). Owner's captures of the
  host's last answers (three files, ingested as rea-proto-be sources) equal the seed replay once
  `\n` in a field is `\r\n`: the host ran on this seed. 1114 tests, lint, in-process Vite run green.
- Deployment, assessed over several rounds (a dev-mode build cannot help: the plugin is serve-only,
  `1283821`/`56446f6` tried it in August; ui-repo stand-in, own repo, `REA_PROTO_BE` re-hosted with
  MongoDB, in-cluster or external). Owner chose: own repo, Node + JSON, on App Platform; created
  `REA_PROTO_PAYMENT_SNAPSHOT`, signed. Shipped: `REA_PROTO_PAYMENT_SNAPSHOT@e22769a` (pushed on
  the owner's word; 21 `node --test` cases; Docker not built, no daemon), owner deployed it on App
  Platform, both lookups there equal the captures; `REA_UI@3aea51f` + `@69fe8b7`, then on the
  owner's word `develop` rewritten onto `7bfff25` as one commit `cffdc0f` (the mock never in history;
  payment-mock abandoned) and force-pushed; 1097 tests, lint, dev-proxy run green.

## Decisions & pitfalls
- `REA_PROTO`'s fixtures are hand-written, not captures. This seed copy is LF-normalised while
  the host's data has CRLF — the generator writes CRLF back. Mongo rule dates not reproducible.
- First `clone` failed on access (this shell was `Jarvis-bookai`; the owner fixed SSH, now
  `Gotop1711`); the second on `git clone --branch main` of an empty upstream. Child initialised by
  hand (`git init -b main` + `origin`), no commit, as `clone` would for `remote: none`.
- Not run: `REA_PROTO_BE` (no .NET SDK; read source). Quote `--include=*.cs` in zsh.

## TODO
- Owner: watch the pipeline's smoke-test on `cffdc0f`, try `:8081`, then `Verified:` on
  payment-snapshot; `plan done` payment-mock when you agree it is abandoned.
- [workspace] `clone` fails for a `write` child whose upstream exists but is empty: `git clone
  --branch <default_branch>` needs the branch; fall back to `git init -b` + `remote add`.
- Owner: push `develop` and `rea`; `Verified:` on payment-mock and the three earlier shipped
  plans. The data-creator acceptance plan's host stays stopped; the snapshot does not unblock it.

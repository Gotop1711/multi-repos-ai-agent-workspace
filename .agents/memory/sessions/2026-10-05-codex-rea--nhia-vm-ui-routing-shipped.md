# 2026-10-05 | codex | rea | nhia-vm-ui-routing-shipped

## Task
Owner signs plan nhia-vm-ui-routing as gotop1711, changing the write branch to
`feature-nhi-deployment`; implement and produce the replacement image tar.

## Done
- `REA_UI@2a7a7c9`: removed the production and dev special Payment upstream; all `/api` paths now
  reach `nhi-claimvalidator`; retained Docker DNS re-resolution, index no-cache and CSP. Updated the
  CI probe's description. Branch is unpushed.
- Host Node 10 could not parse current ESLint. In pinned Node 22: lint, 47 files / 1,100 tests and
  production build pass; existing Vue warnings and the >500 kB chunk warning remain.
- Built `rea-ui:2a7a7c9` for `linux/amd64`, image ID
  `sha256:6bbac700fe65adeec547a8fc590caa7857e617c650d04916f98b1cc60f4e8d9a`.
- At `8082:80`, nginx config, production meta, CSP/no-cache, `/`, SPA fallback, RuleSchema GET and
  Payment POST passed; both API paths reached the same fake backend unstripped. Temporary Docker
  containers and network removed.
- Exported and reload-checked `/Users/jarivschen/Web/Case_資拓_健保署/署內vm/rea-ui-2a7a7c9-linux-amd64.tar`
  (22 MB), SHA-256 `6b2629a4da9d960f3b9f1beebbb447ae4b89010c1f40eee98c3fb24fd124db0e`.
- Marked the plan shipped; reconciled ui-deployment, rea-ui and bff.

## Decisions & pitfalls
- 8082 is host mapping only; the image correctly continues to listen/expose 80.
- The Payment proxy path is proven, not the real endpoint: kernel Payment is still future work, so
  its CI probe and deployed UI workflow will fail until the backend ships it.

## TODO
- Owner/backend: load the tar, add `rea-ui` with `8082:80`, deploy Payment, smoke-test the real VM,
  then add `Verified: gotop1711 — 2026-10-05`. Push/merge the feature branch only on owner's word.

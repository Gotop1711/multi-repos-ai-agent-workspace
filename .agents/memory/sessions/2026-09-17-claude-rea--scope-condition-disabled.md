# 2026-09-17 | claude | rea | scope-condition-disabled

## Task
Owner: the RuleSchema response now carries `Disabled` on some 檢核範圍 conditions (capture attached);
the ui should reflect it. Later in the session: drop the abandoned group-name ui fix from the docs.

## Done
- Ingested the capture as `rea-kernel/sources/2026-09-17-ruleschema-live.json.md` (`ecc4c965567f`).
- Plan disabled-conditions: drafted, moved to `debug-ui` on the owner's word, signed, shipped
  `REA_UI@392230e` (vitest 1091, 6 new; lint clean), verified by the owner (`fac6e9b`), `plan done`.
  What it delivered lives in rule-editor › Disabled conditions; the kernel side in rea-kernel › Save
  translates.
- The abandoned group-name fix no longer appears in the docs (`dae27b0`); the ruling — `GroupName`
  is the kernel's to add, the ui needs no change — is in rule-editor › The leaf envelope.

## Decisions & pitfalls
- A child-repo request becomes a plan first; no `REA_UI` write before `Signed:`.
- The branch was drafted as a guess and was wrong; ask for it. Re-cite after a branch change: the
  same code sat 4–11 lines apart between two branches.
- `ingest` refused the capture (extracted text over 1 MB). `jq --indent 1` halved it, checked equal
  to the original with `jq -S -c` + `cmp`.
- Blocking save on a stored disabled condition looked like UX taste until the translator showed it
  500s. A form rule flags the row only after 儲存; `el-form-item`'s `error` prop flags it on open.
- The mock spelled `AssociatedItems`: its UI map never applied offline. Fixed within the write set.
- `plan done` removes every `*-<product>--<feature>.md` log, the current session's included — name
  the closeout log differently.
- The `Signed:` line was committed reading `<name>`: a placeholder in my instructions was copied
  literally. Give the owner a line with nothing left to substitute.

## TODO
- Push: workspace `rea`; `REA_UI` `debug-ui` `392230e` (one ahead of origin).
- Noted, not filed: 101's `CaseTypeOptions` has a `VisibleWhen` no other code has; the add-on board
  reads 101's list.

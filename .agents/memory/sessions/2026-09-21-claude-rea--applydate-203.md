# 2026-09-21 | claude | rea | applydate-203

## Task
Owner: the backend colleague reports 203 fails to save with 「不允許的選項 'ApplyDate'」 and says the
ui must not hard-code options. Where is `ApplyDate` used in REA_UI and REA_kernel, and how do they relate?

## Done
- rule-editor › RuleSet → editor: the ui carries a stored option value verbatim; the kernel
  validates every `Params` value against `Options`; `REA_kernel@db59964` renamed 203's 就醫日期 to
  `FuncDate`, so a 203 rule saved before 2026-09-18 fails its next save. `ui` src has no date literal.

## Decisions & pitfalls
- No plan filed: whether the fix is a data migration, a kernel alias, or the ui dropping or mapping
  values not in `Options` on load is the owner's and backend's call.
- The kernel commit message says 14 other codes keep `ApplyDate`; the grep finds 16.
- Not verified against the deployment or its stored rows; no request was made.

## TODO
- Owner: confirm the failing 203 rule predates 2026-09-18; choose the fix, then `plan new` if the ui changes.
- Push `rea` (owner's shell).

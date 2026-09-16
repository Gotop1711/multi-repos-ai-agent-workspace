# 2026-09-16 | claude | rea | v2-migration

## Task
Owner: migrate the organization branch to the v2 rules from `main` (218c26b): `docs/rea.md` and its findings into `docs/rea/` modules and repository docs; plans, sources and logs per README.md › Upgrading from v1. Pre-migration tip kept as branch `rea-v1` (b1d99b9).

## Done
- `rea` reset onto `main`; one migration commit. Manifest `scope:` → `product:`.
- `docs/rea/index.md` + modules rule-editor, rule-codes, terms; repository docs rea-ui, rea-kernel, rea-proto.
- Plans: sub-row-labels carried (trimmed, shipped, awaiting `Verified:`); 303-ui-map, 304-ui-map, 305-ui-map, main-payload-subgroups (verified) and 305-category-order (abandoned) not carried — their results are in the modules. Findings: F1–F4 → plan 205-main-fields, F6 → plan field-locking, F5/F11/F12 → rea-kernel facts (the kernel serves all twenty codes at 2ff26b0, so F11/F12 are resolved), F18/F23 → rule-codes, F7–F10 dropped (about the findings themselves).
- Sources: the live schema moved to `rea-kernel/sources/` (same blob, citations intact); the sixteen 305 frames not carried — pruned as orphans. Logs: the three newest carried, cut to the cap.

## Decisions & pitfalls
- Reset, not rebase: 39 old commits replayed onto a `main` that deleted the files they touched would conflict at almost every step; `rea-v1` keeps the history readable.
- The 205 findings are cited at an old kernel sha and were not re-verified during migration — the stub says so and makes re-verification its first step.

## TODO
- Owner: push `main` and `v1`; `Verified:` on sub-row-labels after the eyeball; the `debug-ui` → `develop` merge request; re-save rules saved before `f69d5d9`.

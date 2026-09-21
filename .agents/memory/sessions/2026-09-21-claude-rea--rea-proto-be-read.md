# 2026-09-21 | claude | rea | rea-proto-be-read

## Task
Owner: read the whole `REA_PROTO_BE` repository, work out what it does and how, and write an
easy-to-read document.

## Done
- Read every `.cs` file, the project, settings (keys only), Dockerfile and seed headers at
  `REA_PROTO_BE@ba161ff`. Source only — nothing was built or run.
- `doc add rea rea-proto-be` → repository doc: run, what each mode needs, entry points, storage,
  who calls it. `doc add rea declare-verify` → module: authoring, compiling, checking, the fifteen
  rule kinds, the ten scope conditions, the result record, what surprises. Both linked in the index.
- Linked it to `REA_PROTO` with file-level evidence (eight identical paths), which closes the TODO
  of the import session.

## Decisions & pitfalls
- Two documents, not one: the repository doc caps at 100 lines and the explanation needs ~280. The
  repository doc keeps run/integration; the module holds how it works.
- The module separates "observed in the code" from "inferred, not run": the out-of-scope-fails
  reading and the shared `Reference…` scratch fields come from the tree's shape, not an execution.
- First grep for unused DTO fields silently returned nothing: zsh expanded the unquoted
  `--include=*.cs`. Quoted it and re-ran before writing "never read".
- Seed sizes: `wc -l` over-counts rows (memo fields span lines), so the doc gives bytes, not rows.
- `REA_UI` calls `Payment/Item/Get` and `Payment/Detail/Get`, the same paths as this service's
  controller, through its nginx to a separate host. Recorded in rea-proto-be as inferred. bff.md is
  another task's module and was left alone.

## TODO
- Owner to confirm: is the ui's external Payment host a deployment of this service? If yes, bff ›
  "Payment service" can name it, and plan bff gains a known contract (`PaymentController`).
- Not compared: each generator here against the kernel's same-numbered code (101–401). Worth a
  session if the prototype's checking logic is meant as a reference, as its forms are.
- Earlier open items stand. Push `rea`.

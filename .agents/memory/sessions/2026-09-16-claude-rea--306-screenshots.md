# 2026-09-16 | claude | rea | 306-screenshots

## Task
Ingest the owner's 306 dialog screenshots — `images/test_debug/rules-dialogs/306` and `…/306_new` — as the prototype's reference and the current UI's rendering.

## Done
- `ingest` with `REPO=`: the three `306/` shots (the three 主診斷代碼類別 options) under rea-proto, the one `306_new/` shot under rea-ui.
- rule-codes › Not yet mapped: the 306 bullet now carries both sides — the six flat rows the editor renders today against the prototype's one select + one sub-row — each cited to its derivative.
- `plan new rea 306-main-setting`; signed by the owner the same session; shipped `REA_UI@8281dbb` (debug-ui, unpushed): the `'306'` entry and three tests. 1085 tests pass, lint clean. rule-codes now carries 306 as a mapped code; awaits the owner's `Verified:`.

## Decisions & pitfalls
- Which folder is which had to be read off the images, not the names: `<code>/` is the prototype, `<code>_new/` the current editor — the convention the sibling `303|304|305(_new)` folders follow.
- Vision OCR reads the dialog as loose fragments; the layout in the docs came from viewing the images, not the OCR's line order.
- The 類別 order here (`1–開頭範圍 / 2–代碼 / 3–開頭`) is the prototype's presentation order already ruled on in terms — not restated in rule-codes.
- The 306 defects are one cause: with no map key the block takes `getSchemaFieldType`'s defaults, and `String`→`text` ignores served `Options`. The schema never makes a dropdown; the map does.
- ⛔ The kernel's `01/02/03` and the prototype's are the same three modes in different orders; `linkedOptions` keys the served value (plan › Pitfalls).
- Owner's ruling, generalising that case: where kernel and prototype define the same thing differently, the kernel's is primary — a terms bullet; the index's "match the prototype" now reads as form. Taken to settle conflicts, not absences, so the 205-main-fields and field-locking requests stand.
- `:6574` for the prototype's 306 block was wrong in rea-proto/index and rule-codes — the convention is the `blockId` line, `:6505`. Corrected; terms' `:6574` cites the option label and stands.

## TODO
- The uncited `docs/rea/sources/2026-09-16-post-rule-save-201s.json.md` was removed outside this session.
- Writing inside `projects/` through a `python3` heredoc was refused by the sandbox classifier even with the plan signed; `Edit` on the same file went through. Use the file tools for child-repo writes.
- 306 awaits the owner's check in the running editor, then `Verified:` and `plan done`; `debug-ui` is unpushed as ever.

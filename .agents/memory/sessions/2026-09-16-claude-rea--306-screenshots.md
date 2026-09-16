# 2026-09-16 | claude | rea | 306-screenshots

## Task
Ingest the owner's 306 dialog screenshots — `images/test_debug/rules-dialogs/306` and `…/306_new` — as the prototype's reference and the current UI's rendering.

## Done
- `REPO=REA_PROTO ingest rea` — the three `306/` shots (the three 主診斷代碼類別 options) → `docs/rea/rea-proto/sources/2026-09-16-306-main-settings-00{1,2,3}.jpg.md`, originals under `docs/assets/rea/rea-proto/`.
- `REPO=REA_UI ingest rea` — the one `306_new/` shot → `docs/rea/rea-ui/sources/2026-09-16-306-main-settings.jpg.md`.
- rule-codes › Not yet mapped: the 306 bullet now carries both sides — the six flat rows the editor renders today against the prototype's one select + one sub-row — each cited to its derivative.
- `plan new rea 306-main-setting` (draft): the five defects traced to code, the entry modelled on 305, a test per mode, and the value-meaning pitfall. Owner's signature pending — no write to `REA_UI`.

## Decisions & pitfalls
- Which folder is which had to be read off the images, not the names: `<code>/` is the prototype, `<code>_new/` the current editor — the convention the sibling `303|304|305(_new)` folders follow.
- Vision OCR reads the dialog as loose fragments (buttons before labels, `E…` for a truncated placeholder); the layout in the docs came from viewing the images, not the OCR's line order.
- The 類別 order here (`1–開頭範圍 / 2–代碼 / 3–開頭`) is the prototype's presentation order already ruled on in terms — not restated in rule-codes.
- `NAME=` per file: `NAME=` takes exactly one file per call.
- The 306 defects are one cause: with no map key the block takes `getSchemaFieldType`'s defaults, and `String`→`text` ignores served `Options`. The schema never makes a dropdown; the map does.
- ⛔ The kernel's `01/02/03` and the prototype's are the same three modes in different orders; `linkedOptions` keys the served value (plan › Pitfalls).
- Owner's ruling, generalising that case: where kernel and prototype define the same thing differently, the kernel's is primary — a terms bullet; the index's "match the prototype" now reads as form. Taken to settle conflicts, not absences, so the 205-main-fields and field-locking requests stand.
- `:6574` for the prototype's 306 block was wrong in rea-proto/index and rule-codes — the convention is the `blockId` line, `:6505`. Corrected; terms' `:6574` cites the option label and stands.

## TODO
- The uncited `docs/rea/sources/2026-09-16-post-rule-save-201s.json.md` was removed outside this session; the folder is gone and `check` is clean.
- 306 has no UI-map entry: a plan when the owner wants the editor to match these shots.

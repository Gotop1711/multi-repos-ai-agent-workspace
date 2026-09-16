# 2026-09-16 | claude | rea | 306-screenshots

## Task
Ingest the owner's 306 dialog screenshots — `images/test_debug/rules-dialogs/306` and `…/306_new` — as the prototype's reference and the current UI's rendering.

## Done
- `REPO=REA_PROTO ingest rea` — the three `306/` shots (the three 主診斷代碼類別 options) → `docs/rea/rea-proto/sources/2026-09-16-306-main-settings-00{1,2,3}.jpg.md`, originals under `docs/assets/rea/rea-proto/`.
- `REPO=REA_UI ingest rea` — the one `306_new/` shot → `docs/rea/rea-ui/sources/2026-09-16-306-main-settings.jpg.md`.
- rule-codes › Not yet mapped: the 306 bullet now carries both sides — the six flat rows the editor renders today against the prototype's one select + one sub-row — each cited to its derivative.

## Decisions & pitfalls
- Which folder is which had to be read off the images, not the names: `<code>/` is the prototype, `<code>_new/` the current editor — the convention the sibling `303|304|305(_new)` folders follow.
- Vision OCR reads the dialog as loose fragments (buttons before labels, `E…` for a truncated placeholder); the sub-row order and the `⊕⊖` on 代碼輸入 came from viewing the images, so the doc states the layout, not the OCR's line order.
- The 類別 order here (`1–開頭範圍 / 2–代碼 / 3–開頭`) is the prototype's presentation order already ruled on in terms — not restated in rule-codes.
- `NAME=` per file: three sources would otherwise slug to near-identical names, and `NAME=` takes exactly one file per call.

## TODO
- `docs/rea/sources/2026-09-16-post-rule-save-201s.json.md` is still uncited and untracked from an earlier session — `prune --apply` removes it; left for the owner's word.
- 306 has no UI-map entry: a plan when the owner wants the editor to match these shots.

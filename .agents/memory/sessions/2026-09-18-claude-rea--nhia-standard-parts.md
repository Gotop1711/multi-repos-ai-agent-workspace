# 2026-09-18 | claude | rea | nhia-standard-parts

## Task
Owner: from the full 開發規範 V2.0 (367 pages), ingest the parts a `REA_UI` review needs (肆 is in).

## Done
- Located every part by heading in the full text (read in scratch, not ingested); split and ingested 8
  parts as `2026-09-18-nhia-his3-dev-standard-v2-<part>-p<a>-<b>.pdf`, PDF page ranges in the names.
  44 pictures (5.3 MB): every embedded-image page of the parts that guide the ui; automatic ones only
  for 玖.
- nhia-frontend-standard › The whole regulation: each part cited with its lines.
- Found: 肆 is pages 30–58, so the owner's excerpt was complete; the 程式庫白名單 is referenced three
  times and not in the document; the 命名原則 is 伍 五, C#-oriented, one front-end rule; 附件一 holds
  the VS Code extension list 肆 九 leaves empty — added to the parts.

## Decisions & pitfalls
- `ingest` refused 陸 二 for a login fixture (`sa` + password) on pages 219 and 222; not waived — the
  owner judges whether it is real. Ingested without those two pages; the value is in no file.
- A citation counts for `prune` only by the full file name; `…`-shortened names left sources unkept.
- The JavaScript chapter's examples are code screenshots with no text layer: the pictures carry them.

## TODO
- Owner: the 程式庫白名單; whether the fixture password is real (else re-ingest 陸 二 whole).
- Push `rea`. Next: the `REA_UI` review against these parts.

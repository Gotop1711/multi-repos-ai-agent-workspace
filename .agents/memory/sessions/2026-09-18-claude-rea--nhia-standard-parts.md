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

- Owner: the fixture credentials are samples; 陸 二 re-ingested whole with `SECRET_OK` (`93f137f4ed5c`),
  the partial file pruned. Owner supplied the whitelist (`2026-09-18-nhia-his3-library-whitelist.md`,
  `e97c76a4c25f`, dated 2026-06); the module names its sections and the rows the review checks first.
  It admits `jquery`, which 肆 bans, and Vite up to 7.1.12 where 肆 names 6.0.0.

## Decisions & pitfalls
- `ingest` refused 陸 二 for a login fixture (`sa` + password) on pages 219 and 222; not waived — the
  owner judges whether it is real. Ingested without those two pages; the value is in no file.
- A citation counts for `prune` only by the full file name; `…`-shortened names left sources unkept.
- The JavaScript chapter's examples are code screenshots with no text layer: the pictures carry them.

## TODO
- Push `rea`. Next: the `REA_UI` review against these parts.
- [workspace] The pre-commit hook read a renamed picture as `{a => b}` and refused it; fixed on `main`
  (`--no-renames`). This commit used `git -c diff.renames=false`.

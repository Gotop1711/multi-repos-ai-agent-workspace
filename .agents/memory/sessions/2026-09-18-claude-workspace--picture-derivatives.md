# 2026-09-18 | claude | workspace | picture-derivatives

## Task
Owner: a picture that guides implementation (a prototype form, a mock-up page) was visible only on the
machine that ingested it — originals gitignored, the derivative OCR text. Keep such pictures in git.

## Done
- `extract` writes `sources/<name>.p<N>.jpg` for an image original (whole) and for a PDF page that is a
  picture (under 200 text-layer characters) or that `IMAGES=<file>:<pages>` names; ≤ 200 KiB and
  1600 px (`IMG_BYTES`, `IMG_PX`), shrunk by `sips` until it fits. The header lists them (`pictures:`),
  the page marker names its own (`<!-- page N · picture: … -->`), so a line citation still lands on text.
- The hook admits that one path pattern under 200 KiB and refuses every other binary; `check` ties each
  picture to its text and cap; `prune` and `plan done` remove pictures with their text.
- AGENTS.md (red line, layout), README, CHANGELOG.

## Decisions & pitfalls
- JPEG derivatives in git over Git LFS: zero dependencies is the boilerplate's promise; 100 pictures
  cost about 20 MB of history.
- The picture rule measures the PDF's text layer before OCR replaces it — measured after, an OCR'd page
  never looks like a picture.
- bash 3.2 rejects `case` inside a double-quoted `$(…)`; a helper function instead. `while read` drops
  a last item without a newline: `printf '%s\n'`.
- Tested in a scratch copy of the repository (`git archive` gives the committed tree, not the working
  copy — copy the patched files in): extract, check, the hook's admit and refuse, prune removal.

## TODO
- The organization branch re-extracts its stored originals to gain pictures (`IMAGES=` for mock-up
  pages that also carry text); originals are on the ingesting machine only.

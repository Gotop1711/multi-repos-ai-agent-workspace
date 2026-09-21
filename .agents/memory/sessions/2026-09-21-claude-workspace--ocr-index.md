# 2026-09-21 | claude | workspace | ocr-index

## Task
Owner: improve `extract` so that what a document says only in its pictures is not lost, without trading
away precision.

## Done
- A text PDF's pictured pages are OCR'd and the result appended after the text layer in a marked block;
  lines the text layer already holds are dropped (NFKC + whitespace-insensitive substring, then a 0.75
  similarity test); lines without CJK get full-width punctuation folded back to ASCII.
- Pictured pages are chosen by a thin text layer, by an embedded image of 40000 px or more (new; an
  image size on over half the pages of a 6+ page file is treated as a letterhead), or by `IMAGES=`.
- AGENTS.md › Evidence: a picture-only fact cites the picture; the OCR block is never evidence.
  README, CHANGELOG, help text.

## Decisions & pitfalls
- Measured before designing: OCR drops `_`, swaps quote kinds, scatters a flow chart's labels. So OCR
  is an index that tells a reader which picture to open, not a source.
- Appending, and keeping the header's line count, leaves every existing `L<n>` citation in place.
- The first letterhead guard ("over half the pages have an image") silenced an all-screenshot excerpt;
  repeated image *size* is the better signal.
- OCR runs before the credential scan, so OCR'd text is scanned too.
- Nested quoting broke a Python patch of a shell script holding Swift and Python heredocs: pass
  fragments as files.

## TODO
- Small inline 圖例 (under 40000 px, on text-rich pages) are still not detected: `IMAGES=` names them.

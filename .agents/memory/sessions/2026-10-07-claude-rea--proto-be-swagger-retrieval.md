# 2026-10-07 | claude | rea | proto-be-swagger-retrieval

## Task
The Azure host's Swagger page for `REA_PROTO_BE` (NhiDeclareVerify) is down; the owner needs the
OpenAPI document now. Nothing to write in the modules — the document was already held.

## Done
- Found the capture of 2026-09-22: original `docs/assets/rea/rea-proto-be/2026-09-22-nhideclareverify-swagger-live.json`
  (sha256 `b4b9ec7a…` matches the source header), its verbatim text
  `docs/rea/rea-proto-be/sources/2026-09-22-nhideclareverify-swagger-live.json.md@25ea24c3d433`.
- Checked it is whole: valid JSON, `openapi 3.0.4`, 17 paths, 27 schemas, five tags.
- Cross-checked against the child `REA_PROTO_BE@ba161ff Controllers/*.cs`: the same 17 routes; the
  source's only other route, `Rule/BatchSave`, is commented out (`RuleController.cs:51-58`), so the
  capture still equals the code. No child file touched.
- Owner found the raw JSON hard to read → a local Swagger UI page, spec inlined, "Try it out" off
  (host down), Swagger UI 5.29.1 from cdnjs. On the owner's word committed as
  `docs/rea/rea-proto-be/nhideclareverify-swagger-2026-09-22.html`, linked from rea-proto-be ›
  Integration; rebuild from the `.json` with the same inline script if the capture changes.

## Decisions & pitfalls
- Did not rebuild the document from source (`dotnet` build of `net10.0`): the rules say inspect, not
  execute, and the capture already matches the controllers.
- The `.md` under `sources/` is the committed copy on every clone; the `.json` original is gitignored
  and exists only on this disk — a fresh clone re-reads it with `git show 25ea24c3d433`.

- Swagger UI below 5.18 refuses `openapi: 3.0.4` ("does not specify a valid version field") — the
  first page pinned 5.17.14 and showed that; 3.0.4 support arrived in 5.18. Pin 5.18+ for Swashbuckle output.

## TODO
- [workspace] The layout has no slot for a committed rendering of a derivative (an HTML viewer beside a
  repository doc): `check` ignores non-`.md` files there while AGENTS.md says the folder holds
  `index.md` and `sources/` only — name a place for such a page, or refuse it, on `main`.
- If the host comes back with a changed contract, `ingest` a new capture rather than editing this one.

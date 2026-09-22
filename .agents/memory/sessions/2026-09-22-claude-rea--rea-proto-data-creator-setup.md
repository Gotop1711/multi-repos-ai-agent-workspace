# 2026-09-22 | claude | rea | rea-proto-data-creator-setup

## Task
Owner: fill the draft plan for `REA_PROTO_DATA_CREATOR`, the new project (declared `remote: none`,
`write`, created empty by `clone`) that turns Oracle SQL Developer `.csv` exports (資料表檔) into a JSON
array of `Rule/Save` bodies (RuleSave_batch_payload) the prototype back end can validate. The owner
gave the vocabulary (醫令, rule模組, 資料採集規則, rule模組欄位資料檔, RuleSave_Schema…) and the Swagger URL.

## Done
- Plan written: goal, write set, assumptions the owner overrides at signing (Python stdlib, exports
  gitignored with committed fixtures, one `rules/r<code>.py` per rule kind whose docstring is the
  採集規則), six steps starting with a validator and the 302 rule, done-when ending in a `Completed` job.
- Fetched the Azure host's `swagger.json`; ingested it as a REA_PROTO_BE source (`@25ea24c3d433`). Its
  17 paths and every DTO match `ba161ff` field for field; rea-proto-be › Integration now says so and
  names the host, which `REA_UI`'s `frontend.conf:14` and `.env.development:6` already proxy to.
- declare-verify › The fifteen rule kinds: each generator's acceptance check, in one paragraph.

## Decisions & pitfalls
- The 採集規則 live in the child as executable modules, not in a workspace module: they are the
  project's spec and the tool must run them; the workspace gets a repository doc once it runs.
- Stack is an assumption, not a fact: nothing on disk says what the owner wants; Python because the
  workspace already needs `python3` and the job is csv → json. Marked for the signing line.
- `tomllib` is read-only stdlib; YAML would need a package — so rules are Python, not YAML.
- The Swagger host's commit is unknowable; "same contract as `ba161ff`" is what the schema proves.
- No write to the child: `Signed:` is absent; `cite` shows `REA_PROTO_DATA_CREATOR@unborn`.

## TODO
- Owner: confirm or override the assumptions, answer the 302 `referenceDate` keys, then `Signed:`.
- Owner: the `MHCT_PAYLIMIT` export and any other 資料表檔 go to the child's `data/in/` after signing.
- Earlier open items stand (REANC, architect, shell team, Keycloak). Push `rea` (owner's shell).

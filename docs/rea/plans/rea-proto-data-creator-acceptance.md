# rea — rea-proto-data-creator-acceptance

Writes: REA_PROTO_DATA_CREATOR (main)
Status: draft

## Goal
The tool is shipped and reproduces the 71-body 302 batch from the real export
([rea-proto-data-creator-setup](rea-proto-data-creator-setup.md), `REA_PROTO_DATA_CREATOR@9b89624`),
but nothing has been posted to a server yet, and every further 採集規則 waits on a mapping only the
owner holds. This plan is that list, in order: the acceptance run that turns the payload into a
`Completed` validation job, then the four things that unblock the rest. Steps 1–4 end in the setup
plan's `Verified:` and need no signature; steps 5–8 are the work this plan's signature covers.

## Writes
`REA_PROTO_DATA_CREATOR (main)`: `rules/r301.js`, one rule module per `MHCT_PAYLTYPE` limit type the
owner maps, and the README's 名詞 table. Nothing is written before `Signed:` — and each of those
commits waits for its mapping in any case. The remote in `catalog/repos.yaml` and every document are
workspace work, outside the gate.

## Steps — acceptance, on the Azure host
Host `https://rea-api-dea9h4bbbvf9bpch.eastus2-01.azurewebsites.net`, Swagger at `/swagger`
(`REA_UI@a024004 .env.development:6`, `frontend.conf:14`). Run from
`projects/rea_proto_data_creator`.

1. **Build with a start date the host will accept.** `node src/cli.js build --in data/in --out
   data/out --start-date <YYYY-MM-DD> --split`. The back end refuses a start date earlier than that
   醫令's newest stored version — `Rule/Save` answers 500, `Rule/SaveWork` a quiet `success: false`
   (`REA_PROTO_BE@ba161ff Services/RuleService.cs:261-274`, `:55-64`) — so pick one at or after what
   the host already holds for it.
2. **Post one body, twice.** `data/out/items/01023C.json` is the simplest case, 0–2 years in unit
   `Y`: `POST /api/v1/Rule/Save`, then the same body to `POST /api/v1/Rule/SaveWork`. Both must
   answer `success: true`. Only `SaveWork` writes the `workflow` a check reads
   (`Controllers/RuleController.cs:26-44`).
3. **Run a validation job on that 醫令.** `POST /api/v1/ValidationJob/Batch` with a real declaration
   batch — `HospId`, `HospDataType`, `FeeYearMonth`, `ApplyType`, `ApplyDate`, and `OrderCode` = the
   醫令 — then poll `ValidationJob/Status` until it ends. It must end `Completed`: `Failed` is what
   a hollow rule unit looks like (declare-verify › What will surprise you). The job reads Oracle for
   the declarations, so a host with no Oracle connection also ends `Failed` — the job's message says
   which of the two it was.
4. **Write `Verified:` on the setup plan** once 1–3 hold. Only a human writes that line, and `check`
   lists the plan as waiting until it exists.

## Steps — unblocking the rest
5. **A remote for the child.** `catalog/repos.yaml` still reads `remote: none`, so this disk holds
   the only copy of the project. Give the URL; wiring `origin` up and pushing follows.
6. **The 301 mapping.** `MHCT_PAYLIMIT.LMT_SEX` holds `1` or `2` on 19 rows in force — the two
   values 301 適用性別 takes (`Services/Rules/SexRuleGenerator.cs:17-37`). Confirm that reading and
   `rules/r301.js` follows in one commit, its `description` written as 302's is.
7. **The `MHCT_PAYLTYPE` mapping.** Its 19 `LMT_TYPE_CODE` values name limit types; which rule kind
   each one is, and which `specificConfig` field `LMT_ITEM` fills, is nowhere on disk and is not
   guessable from the table. One commit per type the owner maps.
8. **The README's 名詞 wording.** It carries the setup plan's phrasing today, marked as such,
   because the owner's own definitions were lost with a session's context. Replace them.

Standing, not a step: `main` and `rea` are pushed from the owner's shell — the agent's cannot.

## Done when
The setup plan carries `Verified:`; the child has a remote and is pushed; `rules/r301.js` is in and
its bodies pass the same three acceptance calls; and `MHCT_PAYLTYPE` has either its first rule
module or the owner's ruling that no rule kind reads it, written into the repository doc.

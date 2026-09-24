# 2026-09-24 | claude | rea | payload-verification-answer

## Task
Owner asks how to verify the 13 RuleSave_batch_payload files, and how to know in advance whether
the back end's validation will succeed on them. A question; nothing to change.

## Done
- Answered from the documents and `REA_PROTO_BE@ba161ff`: verification is four layers, each proving
  something different — `validate` (static mirror of the generators' checks; done, 12 026 bodies
  clean), `Rule/Save` (only the start-date check can refuse), `Rule/SaveWork` (compiles; `true`
  even for a hollow unit; no endpoint reads `workflow`), `ValidationJob` (the only real proof; needs
  Oracle rows for the 醫令, and an empty batch ends `Completed` having checked nothing).
- Two ways to see the compiled tree without Oracle, both new work needing a plan: run the back end
  in Development with a local MongoDB and read `workflow`; or a harness calling the generators and
  `new RulesEngine.RulesEngine([workflow])`, whose constructor is what fails the job on a hollow unit.
- No document changed: every fact used was already in declare-verify, rea-proto-be and the
  data-creator repository doc; the acceptance plan already carries the on-host steps.

## Decisions & pitfalls
- `Enum.Parse<RuleCode>("303")` does not throw for an undefined integer value, so a code without a
  generator is dropped by the factory's null, as declare-verify says — confirmed, not changed.
- `data/out/RuleSave_batch_payload/latest_order_codes_of_rules.csv` (12 026 rows, 模組名稱/醫令代碼,
  dated today) is not the tool's output — the owner's own index, gitignored; left alone.
- Did not run the back end: the red line says inspect, not execute; the harness is offered as a plan.

## TODO
- Owner: which of the two offline checks, if either, to sign as a plan; the acceptance plan's
  `Signed:`; a declaration batch that loads (its step 3).
- Earlier open items stand (REANC, architect, shell team, Keycloak). Push `rea` (owner's shell).

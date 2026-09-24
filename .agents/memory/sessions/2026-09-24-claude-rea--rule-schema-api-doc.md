# 2026-09-24 | claude | rea | rule-schema-api-doc

## Task
Owner supplied two documents of the same API — the swagger response-schema screenshot of
`GET /api/v1/RuleSchema` and the example body that page prints — and asked for a cross-comparison
recorded as a readable standalone document. No child-repo work.

## Done
- Ingested both under `REPO=REA_kernel`, where the 2026-09-11 / 09-17 live captures already live.
- New module `docs/rea/rule-schema-api.md` (193 wrapped lines): the envelope, the seven objects,
  `RuleFieldDescriptor` key by key, how to read the generated example, what the kernel fills in
  (profiled over the 2026-09-17 capture), what the ui reads of each key. Linked from the product
  index next to ruleset-api and from rea-kernel › The schema.
- What the comparison turned up, all in the module: `Constraints` reaches the ui renamed
  `validations`; three of the seven constraint types have a ui validator, so the twelve served
  `Min` rules are enforced by the kernel alone and `maxLength` is implemented but never served;
  `Op` has three vocabularies that agree only on what is served today; `VisibleWhen` has 341
  instances and no reader anywhere in the ui; `RuleCode.Description` and `OptionDescriptor.Disabled`
  are never served.

## Decisions & pitfalls
- The screenshot's descriptions are the kernel's XML doc comments, so each was cited to source
  rather than to the picture — stronger evidence, and verifiable from a clone.
- Two places where the page misleads and the source does not: a bare `$ref` property shows the
  referenced *type's* description (`Type`, `VisibleWhen`), and `nullable: true` is printed on every
  reference-type property even where the C# is `required` and non-null.
- The example body is placeholders: `"SubFields": ["string"]` (recursion cut off) and
  `"Default": "string"` (an `object?`) contradict the schema on the same page. Said plainly in the
  module — code written against the example gets both wrong.
- Counts are of the 2026-09-17 capture, not a fresh GET: no authorization to poll the deployment,
  and 307/401 were re-issued after it, so the module calls the numbers a floor.

## TODO
- Owner: two ui-side gaps are findings, not yet plans — the ignored `Min` constraints (a form that
  passes, a save that 400s) and the unread `VisibleWhen`. Say the word and each becomes a plan.
- `[workspace]` `extract` caps a picture derivative at 200 KiB with no floor on legibility: a very
  tall single-page capture (1376×12498 here) lands as a 176×1600 thumbnail that OCRs to nothing, so
  it can neither be read nor cited. Slicing a tall page would beat storing an unreadable one.
- Earlier open items stand (REANC, architect, shell team, Keycloak; two plans await `Verified:`).
  Push `rea` (owner's shell).

# rea / rea-kernel

Repository `REA_kernel` (`projects/kernel`, access **read-only** — a change here is a request to its owners; a plan can carry the request's content but not execute it). NHI.ClaimValidator: .NET 10 Web API + Worker, MongoDB, RulesEngine 6 (README › 技術規格). Cited at `REA_kernel@2ff26b0`.

- **The schema.** `GET /api/v1/RuleSchema` is served from a static versioned registry: `src/Service/NHI.Service.DTO.ClaimValidator/Specification/V1/RuleSchemaRegistry.cs`, one file per code under `Specification/V1/Codes/V1.0/_<code>.cs` — twenty codes at this sha (101–106, 201–206, 301–307, 401), 105 and 303–306 included. Field model: `POCO/V1/Descriptor/RuleFieldDescriptor.cs` (types String / Number / StringArray / ObjectArray; no `Disabled`). A saved `Main` is validated by `FieldRuleValidator.cs:78-95` — a missing or `null` key fails only a `Required` field, an undeclared key is rejected.
- **Live deployment.** What it served on 2026-09-11: `sources/2026-09-11-ruleschema-live.json.md@548ac767c5d8` (305 at L17489-L17707).
- **Stale design doc** (observed at `62948dd`): `docs/codes/205.md` claims 205 has no ReferenceFields and carries `prefixLen` fields and category values `11/12/13` the code does not have; `_205.cs:41-58` matches the ui and the prototype. Do not "correct" the code toward the doc.
- **Not examined.** The translators (`Implementation/V1/Translator/` has no 205); production stores; how the registry is deployed.

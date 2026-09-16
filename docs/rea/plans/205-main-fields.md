# rea — 205-main-fields: the kernel's 205 MainFields match the prototype and the ui mock

Status: draft

## Goal
Code 205 (限專任醫師「處方」) as the kernel serves it diverges from both desired sources (prototype block 205; ui `mock/rulesData.js`) in four ways, observed at `REA_UI@00d98fb REA_PROTO@3fdf47c REA_kernel@62948dd` (`_205.cs`; re-verify at the current kernel HEAD before signing):
1. **`EmploymentType` (專任) missing** — both sources carry it as its own field (`01 專任` / `02 不限專任`, default `01`); the kernel folds it into `DoctorRole`'s `FullTime` option. An optional-field addition needs no SchemaVersion bump (kernel `docs/RuleSchema.md:103-109`).
2. **`DoctorRole` (醫師別) has the wrong option set and no default** — desired `01 執行醫師` / `02 處方醫師` / `03 遠距`, default `02`; served `Prescriber` / `FullTime`, no default, matching the kernel's own `docs/codes/205.md:36-44` (a deliberate divergence). Open: cardinality (mock single-select, prototype `multiSelect`), and whether an option change forces 1.0 → 1.1.
3. **`SpecialistCodes` (專科醫師別) is a design conflict** — sources want a required 2-option single-select (`1 無限制` / `2 除山地離島地區之外基層院所`, a facility-scope restriction); the kernel serves a `StringArray` multi-select over ~66 specialist codes (`OptionsApiRoutes.PxxtCode`). Possibly both fields should exist — a PM ruling.
4. **`GroupName` (群組名稱) exists only in the kernel** (required, default `群組1`, for a multi-group design neither source has). Keep = no change, renders as a text input; remove = a field deletion → SchemaVersion minor bump. Translator impact unspecified (kernel `docs/RuleSchema.md:298-306`; no 205 translator exists).

## Writes
`REA_kernel` is read-only here: this plan carries the request's exact content for the kernel's owners and any ui-map follow-up (`REA_UI (debug-ui)`). Sign only the ui part, if any; the kernel part ends as `Abandoned: — decided: requested …` with the request text.

## Steps
1. Re-verify the four points at the current kernel HEAD (`./workspace.sh cite`).
2. PM rulings on 3 and 4; the owner's word on 2's cardinality.
3. The request to the kernel's owners (fields in kernel PascalCase, POCO-supported properties only — `RuleFieldDescriptor.cs` has no `Disabled`).

## Done when
The served 205 schema carries the ruled fields and the editor renders them as the prototype does.

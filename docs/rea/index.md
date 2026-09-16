# rea

REA (三代健保 rule engine): a schema-driven rule editor (`REA_UI`) renders rule dialogs from the kernel's `GET /api/v1/RuleSchema` (`REA_kernel`, .NET, a static versioned registry of rule codes) and saves `RuleNode`s back; the retired prototype UI (`REA_PROTO`) is the reference the project manager wants the editor to match, code by code. Fleet: `catalog/repos.yaml`; cite with `./workspace.sh cite`.

## Modules
- [rule-editor](rule-editor.md) — how a served schema becomes a form (the UI map, sub-group overrides) and how the form becomes the saved `Main`
- [rule-codes](rule-codes.md) — the codes with a UI-map entry (303, 304, 305) against the prototype; what is not yet mapped (306, 105)
- [terms](terms.md) — vocabulary rulings: the prototype's blank-style labels, the 類別 option order

## Repositories
- [rea-ui](rea-ui/index.md) — `REA_UI`: run, test, entry points; the owner's `debug-ui` branch
- [rea-kernel](rea-kernel/index.md) — `REA_kernel` (read-only): where the schema and each code live
- [rea-proto](rea-proto/index.md) — `REA_PROTO` (read-only): the template that defines the desired forms

## Plans
- [sub-row-labels](plans/sub-row-labels.md) — shipped: 303/305 sub-rows read as the prototype's sentences; awaiting the owner's `Verified:`
- [205-main-fields](plans/205-main-fields.md) — draft: kernel 205 MainFields vs the prototype (four gaps; kernel is read-only, so a request)
- [field-locking](plans/field-locking.md) — draft: the prototype's locked fields have no carrier end to end

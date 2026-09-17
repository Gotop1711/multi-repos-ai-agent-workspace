# rea

REA (三代健保 rule engine): a schema-driven rule editor (`REA_UI`) renders rule dialogs from the kernel's `GET /api/v1/RuleSchema` (`REA_kernel`, .NET, a static versioned registry of rule codes) and saves `RuleNode`s back; the retired prototype UI (`REA_PROTO`) is the reference the project manager wants the editor to match, code by code — its forms, that is: where the two define the same thing differently the kernel's meaning is primary (terms). Fleet: `catalog/repos.yaml`; cite with `./workspace.sh cite`.

## Modules
- [rule-editor](rule-editor.md) — how a served schema becomes a form (the UI map, sub-group overrides) and how the form becomes the saved `Main`
- [rule-codes](rule-codes.md) — the codes with a UI-map entry (303, 304, 305, 306) against the prototype; what is not yet mapped (105)
- [terms](terms.md) — vocabulary rulings: the prototype's blank-style labels, the 類別 option order
- [field-map](field-map.md) — every dialog field enumerated, kernel name against ui name, and the names with no counterpart

## Repositories
- [rea-ui](rea-ui/index.md) — `REA_UI`: run, test, entry points; the owner's `debug-ui` branch
- [rea-kernel](rea-kernel/index.md) — `REA_kernel` (read-only): where the schema and each code live
- [rea-proto](rea-proto/index.md) — `REA_PROTO` (read-only): the template that defines the desired forms

## Plans
- [205-main-fields](plans/205-main-fields.md) — draft: kernel 205 MainFields vs the prototype (four gaps; kernel is read-only, so a request)
- [field-locking](plans/field-locking.md) — draft: the prototype's locked fields have no carrier end to end
- [306-main-setting](plans/306-main-setting.md) — shipped `REA_UI@8281dbb`: the 306 entry (five defects of an unmapped 主設定); awaits the owner's check
- [translated-rule-names](plans/translated-rule-names.md) — draft: a named leaf's engine rule names no longer match the kernel's own result parser (a request) 
- [ui-map-orphans](plans/ui-map-orphans.md) — draft: nine UI-map keys name no served field; four are untracked (201 參考日期, 307 widths, 檢核範圍's 前 N 碼)

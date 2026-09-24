# rea

REA (三代健保 rule engine): a schema-driven rule editor (`REA_UI`) renders rule dialogs from the kernel's `GET /api/v1/RuleSchema` (`REA_kernel`, .NET, a static versioned registry of rule codes) and saves `RuleNode`s back; the retired prototype UI (`REA_PROTO`) is the reference the project manager wants the editor to match, code by code — its forms, that is: where the two define the same thing differently the kernel's meaning is primary (terms). Fleet: `catalog/repos.yaml`; cite with `./workspace.sh cite`.

## Modules
- [rule-editor](rule-editor.md) — how a served schema becomes a form (the UI map, sub-group overrides) which stored `RuleSet` fields it reads, and how the form becomes the saved `Main`
- [rule-codes](rule-codes.md) — the codes with a UI-map entry (303, 304, 305, 306) against the prototype; what is not yet mapped (105)
- [terms](terms.md) — vocabulary rulings: the prototype's blank-style labels, the 類別 option order
- [field-map](field-map.md) — every dialog field enumerated, kernel name against ui name, and the names with no counterpart
- [ruleset-api](ruleset-api.md) — the `RuleSet` round trip: the row `GET` returns, what the ui reads of it and never reads, the dev store's provenance and quirks 
- [nhia-frontend-standard](nhia-frontend-standard.md) — the NHIA front-end rule the ui must meet: BFF-only API, Element Plus, Module Federation, the validate module, colours and layout
- [scope-conditions](scope-conditions.md) — 檢核範圍: each of the thirteen conditions as first level → helper menus → end level, and which layer is hard-coded, from `PXXT_CODE`, or typed
- [bff](bff.md) — the BFF the regulation requires and the ui lacks: the rules, today's direct nginx proxying to two backends, the target, open questions
- [nhia-ui-design](nhia-ui-design.md) — 附件二 介面設計規範, item by item: frame, colours, buttons, ROC date inputs, dialogs, paging
- [ui-deployment](ui-deployment.md) — the ui's Docker image, nginx routes, build modes and GitLab pipeline, and the manual image check 
- [nhia-regulation](nhia-regulation.md) — the NHIA regulation as a whole: the chapters that bind the ui and the BFF, figures that contradict the text, how the source and its pictures are held
- [declare-verify](declare-verify.md) — the prototype's back end, end to end: authoring endpoints, how a saved rule compiles to a RulesEngine tree (15 rule kinds, 10 scope conditions), the validation job, what surprises

## Repositories
- [rea-ui](rea-ui/index.md) — `REA_UI`: run, test, entry points; the owner's `debug-ui` branch
- [rea-kernel](rea-kernel/index.md) — `REA_kernel` (read-only): where the schema and each code live
- [rea-proto](rea-proto/index.md) — `REA_PROTO` (read-only): the template that defines the desired forms
- [rea-proto-be](rea-proto-be/index.md) — `REA_PROTO_BE` (read-only, no upstream): `NhiDeclareVerify` — run, what each mode needs, entry points, storage, who calls it
- [rea-proto-data-creator](rea-proto-data-creator/index.md) — `REA_PROTO_DATA_CREATOR` (write, no upstream): Node.js; the owner's 採集規則 for 15 rule kinds, one payload file each from the two 資料表檔; what still waits on the owner

## Plans
- [205-main-fields](plans/205-main-fields.md) — draft: kernel 205 MainFields vs the prototype (four gaps; kernel is read-only, so a request)
- [field-locking](plans/field-locking.md) — draft: the prototype's locked fields have no carrier end to end
- [306-main-setting](plans/306-main-setting.md) — shipped `REA_UI@8281dbb`: the 306 entry (five defects of an unmapped 主設定); awaits the owner's check
- [translated-rule-names](plans/translated-rule-names.md) — draft: a named leaf's engine rule names no longer match the kernel's own result parser (a request) 
- [ui-map-orphans](plans/ui-map-orphans.md) — draft: nine UI-map keys name no served field; four are untracked (201 參考日期, 307 widths, 檢核範圍's 前 N 碼)
- [ruleset-unread-fields](plans/ruleset-unread-fields.md) — draft: five top-level fields and the leaf `Name` go unread; leave, `$select`, or drop `TranslatedRules` (a kernel request) 
- [bff](plans/bff.md) — draft: a separate BFF project between the ui and its two backends; the owner names the repository and the stack first
- [ui-design-conformance](plans/ui-design-conformance.md) — draft: assess, then fix, the ui's screens against 附件二; after the BFF
- [federation-remote](plans/federation-remote.md) — draft: the ui becomes a Federation remote and drops its own frame; the shell's team must answer first
- [ui-docs-removal](plans/ui-docs-removal.md) — shipped `REA_UI@a024004`: `docs/` and the two lines that pointed to it removed; awaits the owner's check 
- [rea-proto-data-creator-setup](plans/rea-proto-data-creator-setup.md) — shipped `REA_PROTO_DATA_CREATOR@bb32f77`: the new project that turns Oracle table exports into `Rule/Save` bodies the prototype back end compiles and checks; awaits the owner's post and check
- [rea-proto-data-creator-acceptance](plans/rea-proto-data-creator-acceptance.md) — draft: the owner's list — the acceptance run on the Azure host that ends in the setup plan's `Verified:`, the remote, 205/206 on every 醫令 (recorded), and the six rule kinds without rules (303–307, 401)

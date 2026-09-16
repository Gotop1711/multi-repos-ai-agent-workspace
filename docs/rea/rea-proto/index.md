# rea / rea-proto

Repository `REA_PROTO` (`projects/rea_proto`, access read-only) — the retired prototype UI whose rule content the project manager treats as the desired reference. Cited at `REA_PROTO@3fdf47c`.

- **The template.** `tests/mock/api/rulesSpecificSetting.json` (byte-equal in shape to the recorded `UiTemplate/RulesSpecificSetting/Get` body) defines each code's form: a `dropdown option → linkedBlockId → sub-block inputs` pattern, the sentence carried as `prefixText` / `suffixText` with `label: ""`, `_` in titles where a number goes (terms). Blocks used so far: 303 `:5273`, 304 `:5614`, 305 `:6115`, 306 `:6574`.
- **Run.** `localhost:5174` (README › 安裝與運行). Its data is mock only — nothing is stored.
- **What the new editor does not reproduce.** Per-mode sentences for 304 (rule-codes), the two `visitType` option sets of 304's modes 08/10, `disabled` locks on 205/206 fields (plan field-locking).

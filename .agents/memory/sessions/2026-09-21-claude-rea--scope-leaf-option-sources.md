# 2026-09-21 | claude | rea | scope-leaf-option-sources

## Task
Owner: under each 檢核範圍 condition, is the end-level menu's data a database table or hard-coded in
the kernel?

## Done
- field-map › 末層選項的來源: every field of the thirteen conditions sorted into three sources — six
  `OptionsApi` fields from Oracle `PXXT_CODE`, the hard-coded `Options` literals, and free inputs with
  no lookup. The five `OptionsApi` paths are identical in all twenty code files.

## Decisions & pitfalls
- `{Category}` is filled from a hard-coded `Category`, so which `DATA_TYPE`s exist is hard-coded too;
  only the rows under each come from the table. Easy to miss when reading the route alone.
- No validator checks a saved value against any table (`IOptionSL` has one consumer, the controller).
- Not verified: whether the deployment reads Oracle or the mock. No request was made to it.

## TODO
- Push `rea` (owner's shell).

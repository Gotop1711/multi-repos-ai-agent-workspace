# rea — field-locking: the prototype's locked fields have a carrier end to end

Status: draft

## Goal
The prototype locks 205 `employmentType` to 專任 (`disabled: true`) and locks 206 `doctorTypes` to 執行醫師 and `employmentType`; the role is editable in 205 and locked in 206. Nothing carries a lock today, observed at `REA_UI@00d98fb REA_PROTO@3fdf47c REA_kernel@62948dd`: the kernel POCO has no `Disabled` property (`RuleFieldDescriptor.cs:15-75`); `applyUIMapToBlock` has no disabled override; `MainSetting.vue`'s radio branch has no `:disabled` binding (dropdown / multiSelect / sortOptions do; disabled inputs get their default force-set).

## Writes
Either a kernel `Disabled` property (schema-wide model change — a request, `REA_kernel` is read-only here), a ui-map `disabled` override (`REA_UI (debug-ui)`), or a PM ruling that an always-locked field is implicit in the rule code and dropped — which would also settle 205-main-fields point 1.

## Steps
1. PM ruling on the mechanism; whether 206 mirrors 205.
2. If ui-side: `SubGroupInput`-style override `disabled` on top-level inputs, the radio branch's `:disabled` binding, a test.

## Done when
205 and 206 render the prototype's locks in the running editor and a saved rule carries the locked value.

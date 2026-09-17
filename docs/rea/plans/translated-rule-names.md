# rea — translated-rule-names: the suffix the group name adds has no reader that accepts it

Status: draft

## Goal
The kernel's result attribution works on rules translated from a named leaf. Found while answering "does the kernel store the group name?" (session 2026-09-17-claude-rea--leaf-group-name), at `REA_kernel@458e663`: three facts that cannot all hold.
1. Every leaf **must** carry a non-blank `Name` (`Validation/StructureValidator.cs:70-73`).
2. So the translator **always** suffixes: root `Rule_<code>_<name>`, and `Rule_<code>_Skip_<name>` / `Rule_<code>_Main_<name>` plus recursively suffixed children (`Translator/V1.0/RuleSetTranslator.cs:58-115`).
3. `RuleResultAttributionParser.Parse` throws unless the root is exactly `Rule_<code>` ("預期結果節點為 …，實際為 …"), and looks for `Rule_<code>_Skip` / `_Main` / `_Guard` as direct children (`Translator/RuleResultAttributionParser.cs:22-27,34-47,54`). Neither the root nor the children will ever match again — and note the two schemes interleave the suffix differently (`Rule_201_Skip_群組1` vs. the parser's `Rule_201_群組1_Skip`), so no single naming convention satisfies both as written.

Nothing fails today: `src` never builds a `Workflow` or executes the engine (only `test/` does, `RuleSetTranslatorClaimDepartmentTests.cs:64-79`), `TranslatedRules` is written and never read (`Implementation/V1/RuleSetSL.cs:119-129`), and the translator tests pass `RuleNode`s with no `Name`, so the suffix path is never exercised. It breaks whenever validation execution is wired up.

## Writes
Nothing here. `REA_kernel` is read-only in this workspace — this is a **request to its owners**, and the choice is theirs: have `Parse` take the group name (or the suffix) as a parameter and build the expected names from it; or key attribution off `Properties["Name"]` and `SuccessEvent`, which the translator already stamps and nothing reads, instead of parsing rule-name strings; or drop the suffix and let `Properties["Name"]` alone carry the group. A translator test with a named leaf asserted through `Parse` would have caught it and should land with whichever is chosen.

## Steps
1. Put the three facts to the kernel's owners as one question: which name does attribution key off once every leaf is named?
2. Their answer is written into rea-kernel; if it changes what `REA_UI` sends, that is a new plan (this one writes nothing).

## Done when
The kernel's owners have ruled, the ruling is in rea-kernel, and — if they choose to fix it — a translator test covers a named leaf end to end through `Parse`. `Abandoned: — decided: <ruling>` if they intend to rewrite attribution before execution ships and the conflict never reaches a running system.

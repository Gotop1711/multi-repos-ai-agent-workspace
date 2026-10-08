# 2026-10-08 | claude | rea | payment-local

## Task
Owner: the two Payment lookups (`Item/Get`, `Detail/Get`) are unreachable in `REA_UI`; answer them
from fixed data, always successful, in dev and in the production build — in the app's code, not the
dev-only mock plugin. Fleet read-only; the deliverable is plan payment-local (draft, unsigned).

## Done
- Traced the paths: `src/api/modules/payment/index.ts` is the only caller of the URLs; the store and
  four views consume the `{ result, data, message }` envelope; Payment is outside the kernel
  pascalize pattern and outside the mock plugin (`REA_UI@2d2c40e`).
- Chose the data: `REA_PROTO_PAYMENT_SNAPSHOT@e22769a data/paymentData.json` + `src/handlers.js`,
  already proven equal to the 2026-09-30 captures — copied into `src/utils/payment/local/`, loaded by
  one dynamic `import()` so Vite ships it as its own chunk in both modes.
- Wrote `docs/rea/plans/payment-local.md` (exactly 80 wrapped lines): resolver + `VITE_PAYMENT_LOCAL`
  switch (default on in both `.env.*`), tests, the CI smoke probe, the docs to update after.

## Decisions & pitfalls
- A `VITE_` flag is still hardcoding: it is baked at build, so production carries it; it exists so
  the kernel can take Payment back with one line per env file instead of a revert.
- Dynamic import rather than static: a 4.4 MB JSON inlined into the main chunk would delay first
  paint; as its own chunk it loads with the start-up preload and is then browser-cached.
- The global loading overlay disappears for `Detail/Get` (it was axios-tracked); views have their own
  spinners — noted in the plan, not worked around.
- CI's Payment smoke probe would fail every `develop` push once the ui stops needing the backend —
  put in the plan as a strikeable step rather than decided alone.
- `Writes:` is `develop`; the owner's `feature-nhi-deployment` takes it by rebase (assumption in the
  plan). No child file touched; `plan new` + index hook + this log only.

## TODO
- Owner: sign (or strike step 4 / the flag), then the shipping session: two commits on `develop`,
  the Done-when checks, docs in step 5, rebase `feature-nhi-deployment`, rebuild the VM image.
- Plan nhia-vm-ui-routing's last Done-when clause (kernel answers Payment) is overtaken by this plan
  once it ships — not edited here.

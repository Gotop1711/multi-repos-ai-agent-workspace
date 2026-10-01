# rea / rea-proto-payment-snapshot

Repository `REA_PROTO_PAYMENT_SNAPSHOT` (`projects/rea_proto_payment_snapshot`, access write,
`git@github.com:Gotop1711/REA_payment-snapshot.git`, created empty by the owner on 2026-10-01).
Empty until plan [payment-snapshot](../plans/payment-snapshot.md) ships; this page is rewritten then.

## What it will be
A Node process and a JSON file: the 支付標準 the stopped Azure Payment host served, frozen —
`REA_PROTO_BE@ba161ff`'s seed replayed through the prototype's own queries, proven identical to the
host's last answers (plan payment-mock). It answers the two paths `REA_UI` calls,
`POST /api/v1/Payment/Item/Get` and `/Detail/Get`, nothing else; deployed on DigitalOcean App
Platform; the ui's nginx and dev proxy point at it (rea-ui › Deployment).

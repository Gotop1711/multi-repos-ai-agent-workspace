---
source: docs/assets/rea/rea-kernel/2026-10-02-api-post-ruleset-request-body-example.json
sha256: b7c06e270a06c0b2fe687dc5368066ac04b6193ff76f2cc1f21abb30834cae5d
bytes: 1356
extractor: verbatim
status: ok
received: 2026-10-02-api-post-ruleset-request-body-example.json
---
[
    {
        "OrderCode": "01116B",
        "SchemaVersion": "1.0",
        "RuleStartDate": "2026-10-02",
        "Logic": {
            "Code": "102",
            "GroupName": "群組1",
            "Main": {
                "ServiceCodes": [
                    "C"
                ]
            },
            "Reference": {
                "ReferenceDates": [
                    {
                        "Fields": [
                            "DispensingDate"
                        ],
                        "Condition": {
                            "Field": "CaseType",
                            "Params": {
                                "Operator": "In",
                                "Category": "101",
                                "CaseTypeOptions": [
                                    "0"
                                ]
                            }
                        }
                    },
                    {
                        "Fields": [
                            "ApplyDate",
                            "ExecutionStartDate"
                        ]
                    }
                ]
            },
            "Name": "服務項目代碼",
            "UpdatedAt": "2026-10-01T10:31:54.112Z"
        },
        "OtherNote": "{\"102\":\"群組1:\\n主設定: 服務項目代碼: C\"}"
    }
]

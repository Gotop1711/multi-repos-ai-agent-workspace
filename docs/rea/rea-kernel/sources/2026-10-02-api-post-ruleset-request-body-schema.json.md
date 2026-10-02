---
source: docs/assets/rea/rea-kernel/2026-10-02-api-post-ruleset-request-body-schema.json
sha256: 8c9aa5f4c560b3d8fb314433e4b2e7f4ed0e62a5860325d0879fc372da34f0e1
bytes: 2189
extractor: verbatim
status: ok
received: 2026-10-02-api-post-ruleset-request-body-schema.json
---
[
  {
    "OrderCode": "string",
    "SchemaVersion": "string",
    "RuleStartDate": "2026-09-30",
    "Logic": {
      "Op": "And",
      "Left": "string",
      "Right": "string",
      "Code": "string",
      "Name": "string",
      "GroupName": "string",
      "Condition": {
        "Op": "And",
        "Left": "string",
        "Right": "string",
        "Field": "string",
        "Params": {
          "additionalProp1": "string",
          "additionalProp2": "string",
          "additionalProp3": "string"
        }
      },
      "Main": {
        "additionalProp1": "string",
        "additionalProp2": "string",
        "additionalProp3": "string"
      },
      "Reference": {
        "additionalProp1": [
          {
            "Fields": [
              "string"
            ],
            "Condition": {
              "Op": "And",
              "Left": "string",
              "Right": "string",
              "Field": "string",
              "Params": {
                "additionalProp1": "string",
                "additionalProp2": "string",
                "additionalProp3": "string"
              }
            }
          }
        ],
        "additionalProp2": [
          {
            "Fields": [
              "string"
            ],
            "Condition": {
              "Op": "And",
              "Left": "string",
              "Right": "string",
              "Field": "string",
              "Params": {
                "additionalProp1": "string",
                "additionalProp2": "string",
                "additionalProp3": "string"
              }
            }
          }
        ],
        "additionalProp3": [
          {
            "Fields": [
              "string"
            ],
            "Condition": {
              "Op": "And",
              "Left": "string",
              "Right": "string",
              "Field": "string",
              "Params": {
                "additionalProp1": "string",
                "additionalProp2": "string",
                "additionalProp3": "string"
              }
            }
          }
        ]
      },
      "UpdatedAt": "2026-09-30T08:41:36.344Z"
    },
    "OtherNote": "string"
  }
]

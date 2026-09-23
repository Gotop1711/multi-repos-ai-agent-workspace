---
source: docs/assets/rea/rea-proto-data-creator/2026-09-23-post-rulesave-request-body-schema.json
sha256: d999291e81873653e56ceccee6fdf17e5fd9649103b84a8c318740f95dda34b3
bytes: 6869
extractor: verbatim
status: ok
received: POST_RuleSave_request-body_Schema.json
---
{
  "rules": [
    {
      "code": "string",
      "name": "string",
      "data": {
        "conditions": [
          {
            "scopeConditions": [
              {
                "id": "string",
                "type": "string",
                "property": "string",
                "value": {
                  "operator": "string",
                  "medicalTypeOptions": [
                    "string"
                  ],
                  "caseTypeOptions": [
                    "string"
                  ],
                  "levelOptions": [
                    "string"
                  ],
                  "hospCodeOptions": [
                    "string"
                  ],
                  "orderTypeOptions": [
                    "string"
                  ],
                  "relModeOptions": [
                    "string"
                  ],
                  "departmentOptions": [
                    "string"
                  ],
                  "roboticOption": "string",
                  "filterOptions": [
                    "string"
                  ],
                  "category": "string",
                  "max": 0,
                  "min": 0,
                  "operatorMax": "string",
                  "operatorMin": "string",
                  "referenceDate": [
                    "string"
                  ],
                  "unit": "string",
                  "inputCodes": [
                    "string"
                  ],
                  "inputPrefix": "string",
                  "prefixLen": 0,
                  "prefixRange": 0,
                  "rangeStart": "string",
                  "rangeEnd": "string",
                  "groupOptions": "string"
                },
                "logicalOperator": "string"
              }
            ],
            "specificConfig": {
              "mainSetting": [
                "string"
              ],
              "referenceDate": [
                "string"
              ],
              "doctorType": "string",
              "doctorTypes": [
                "string"
              ],
              "employmentType": "string",
              "unit": "string",
              "min": 0,
              "max": 0,
              "filterFields": [
                "string"
              ],
              "rangeGroups": [
                {
                  "inputEnd": "string",
                  "inputStart": "string",
                  "monthEnd": "string",
                  "monthStart": "string",
                  "prefixRange": "string"
                }
              ],
              "bodyPart": "string",
              "bodyPartCategory": "string",
              "bodyPartPrefixRange": "string",
              "bodyPartInputStart": "string",
              "bodyPartInputEnd": "string",
              "bodyPartInputPrefix": "string",
              "bodyPartInputCodes": [
                "string"
              ],
              "bodyPartGroupOption": "string",
              "orderCategory": "string",
              "orderPrefixRange": "string",
              "orderInputStart": "string",
              "orderInputEnd": "string",
              "orderInputPrefix": "string",
              "orderInputCodes": [
                "string"
              ],
              "orderGroupOption": "string",
              "category": "string",
              "prefixRange": "string",
              "inputStart": "string",
              "inputEnd": "string",
              "inputPrefix": "string",
              "inputCodes": [
                "string"
              ]
            },
            "scopeRuleExpr": "string",
            "groupName": "string",
            "referenceConditions": [
              {
                "id": "string",
                "defaultValues": [
                  "string"
                ],
                "groups": [
                  {
                    "id": "string",
                    "values": [
                      "string"
                    ],
                    "groupConditions": [
                      {
                        "id": "string",
                        "type": "string",
                        "property": "string",
                        "value": {
                          "operator": "string",
                          "medicalTypeOptions": [
                            "string"
                          ],
                          "caseTypeOptions": [
                            "string"
                          ],
                          "levelOptions": [
                            "string"
                          ],
                          "hospCodeOptions": [
                            "string"
                          ],
                          "orderTypeOptions": [
                            "string"
                          ],
                          "relModeOptions": [
                            "string"
                          ],
                          "departmentOptions": [
                            "string"
                          ],
                          "roboticOption": "string",
                          "filterOptions": [
                            "string"
                          ],
                          "category": "string",
                          "max": 0,
                          "min": 0,
                          "operatorMax": "string",
                          "operatorMin": "string",
                          "referenceDate": [
                            "string"
                          ],
                          "unit": "string",
                          "inputCodes": [
                            "string"
                          ],
                          "inputPrefix": "string",
                          "prefixLen": 0,
                          "prefixRange": 0,
                          "rangeStart": "string",
                          "rangeEnd": "string",
                          "groupOptions": "string"
                        },
                        "logicalOperator": "string"
                      }
                    ],
                    "groupRuleExpr": "string"
                  }
                ]
              }
            ],
            "referenceRuleExpr": "string"
          }
        ],
        "resultAction": "string",
        "expr": "string"
      },
      "updatedAt": "2026-09-23T09:19:22.423Z"
    }
  ],
  "ruleExpr": "string",
  "form": {
    "selectedItems": [
      "string"
    ],
    "hospCode": [
      "string"
    ],
    "caseTypeMap": [
      {
        "hospCodeGroup": "string",
        "caseType": [
          {
            "code": "string",
            "name": "string"
          }
        ]
      }
    ],
    "orderType": [
      "string"
    ],
    "ruleStartDate": "2026-09-23",
    "ruleEndDate": "2026-09-23"
  }
}

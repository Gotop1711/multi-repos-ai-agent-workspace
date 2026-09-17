---
source: docs/assets/rea/rea-kernel/2026-09-17-ruleschema-live.json
sha256: 5386a4098cc808b746ab7e8a376cd9c31df3523dadaff183a49bbe540c82c237
bytes: 466128
extractor: verbatim
status: ok
received: 2026-09-17-ruleschema-live.json
---
[
 {
  "Version": "1.0",
  "EffectiveDate": "2026-01-01",
  "Codes": [
   {
    "Value": "101",
    "Label": "計畫代碼或特定醫院資格",
    "MainFields": [
     {
      "Value": "PlanCodes",
      "Label": "計畫代碼",
      "Type": "StringArray",
      "OptionsApi": "/api/v1/Options/PxxtCode/MHA/116",
      "Constraints": [
       {
        "Type": "Required",
        "Message": "必填欄位"
       }
      ]
     }
    ],
    "ReferenceFields": [
     {
      "Value": "ReferenceDates",
      "Label": "參考日期",
      "Type": "StringArray",
      "Options": [
       {
        "Value": "ApplyDate",
        "Label": "就醫日期"
       },
       {
        "Value": "ExecutionStartDate",
        "Label": "醫令執行起日"
       },
       {
        "Value": "TreatmentEndDate",
        "Label": "治療結束日"
       },
       {
        "Value": "AdmissionDate",
        "Label": "住院日期"
       },
       {
        "Value": "DischargeDate",
        "Label": "出院日期"
       },
       {
        "Value": "DispensingDate",
        "Label": "調劑日期"
       },
       {
        "Value": "PhysicalTherapyStartDate",
        "Label": "物理治療起日"
       },
       {
        "Value": "ExaminationDate",
        "Label": "檢驗日期"
       }
      ],
      "Default": [
       "ApplyDate",
       "ExecutionStartDate"
      ]
     }
    ],
    "Conditions": [
     {
      "Value": "CaseType",
      "Label": "案件分類",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "案件分類類別",
        "Type": "String",
        "Options": [
         {
          "Value": "101",
          "Label": "門診西醫"
         },
         {
          "Value": "104",
          "Label": "住診"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "CaseTypeOptions",
        "Label": "案件分類選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/{Category}",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "{Category}"
        }
       }
      ]
     },
     {
      "Value": "Level",
      "Label": "層級別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "LevelOptions",
        "Label": "層級別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/QRD/003",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "HospCode",
      "Label": "醫事類別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "醫事類別類型",
        "Type": "String",
        "Options": [
         {
          "Value": "011",
          "Label": "門診"
         },
         {
          "Value": "012",
          "Label": "住診"
         },
         {
          "Value": "013",
          "Label": "其他"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "HospCodeOptions",
        "Label": "醫事類別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/{Category}",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "OrderType",
      "Label": "醫令類別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "OrderTypeOptions",
        "Label": "醫令類別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/132",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "RelMode",
      "Label": "處方調劑方式",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "RelModeOptions",
        "Label": "處方調劑方式選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/131",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "SubMainDiagnosisCode",
      "Label": "主次診斷代碼",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "FilterOptions",
        "Label": "比對欄位",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "ICD9CM_CODE",
          "Label": "主診斷代碼"
         },
         {
          "Value": "ICD9CM_CODE1",
          "Label": "次診斷代碼(一)"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "PartCode",
      "Label": "部分負擔代碼",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "TreatmentArea",
      "Label": "診療之部位",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         },
         {
          "Value": "04",
          "Label": "群組"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "GroupOption",
        "Label": "群組",
        "Type": "String",
        "Options": [
         {
          "Value": "TreatmentG01",
          "Label": "群組一"
         },
         {
          "Value": "TreatmentG02",
          "Label": "群組二"
         },
         {
          "Value": "TreatmentG03",
          "Label": "群組三"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "04"
        }
       }
      ]
     },
     {
      "Value": "Age",
      "Label": "年齡",
      "Fields": [
       {
        "Value": "ReferenceDates",
        "Label": "基準日（可排序）",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "01",
          "Label": "就醫日期"
         },
         {
          "Value": "02",
          "Label": "醫令執行起日"
         },
         {
          "Value": "03",
          "Label": "治療結束日"
         },
         {
          "Value": "04",
          "Label": "住院日期"
         },
         {
          "Value": "05",
          "Label": "出院日期"
         },
         {
          "Value": "06",
          "Label": "調劑日期"
         },
         {
          "Value": "07",
          "Label": "物理治療起日"
         },
         {
          "Value": "08",
          "Label": "檢驗日期"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "OperatorMin",
        "Label": "下限運算子",
        "Type": "String",
        "Options": [
         {
          "Value": ">",
          "Label": "大於"
         },
         {
          "Value": ">=",
          "Label": "大於等於"
         }
        ]
       },
       {
        "Value": "Min",
        "Label": "下限",
        "Type": "Number",
        "Placeholder": "不填表示無下限"
       },
       {
        "Value": "OperatorMax",
        "Label": "上限運算子",
        "Type": "String",
        "Options": [
         {
          "Value": "<",
          "Label": "小於"
         },
         {
          "Value": "<=",
          "Label": "小於等於"
         }
        ]
       },
       {
        "Value": "Max",
        "Label": "上限",
        "Type": "Number",
        "Placeholder": "不填表示無上限"
       },
       {
        "Value": "Unit",
        "Label": "單位",
        "Type": "String",
        "Options": [
         {
          "Value": "Y",
          "Label": "歲"
         },
         {
          "Value": "M",
          "Label": "月"
         },
         {
          "Value": "D",
          "Label": "日"
         }
        ],
        "Default": "Y",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "AssociatedItems",
      "Label": "清單下併報項目",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "項目代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "TreatmentItems",
      "Label": "核定治療項目",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "FilterOptions",
        "Label": "比對欄位",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "01",
          "Label": "特殊治療項目代號（一）"
         },
         {
          "Value": "02",
          "Label": "特殊治療項目代號（二）"
         },
         {
          "Value": "03",
          "Label": "特殊治療項目代號（三）"
         },
         {
          "Value": "04",
          "Label": "特殊治療項目代號（四）"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "Department",
      "Label": "就醫科別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "DepartmentOptions",
        "Label": "就醫科別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PXX/997",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "Robotic",
      "Label": "僅機械手臂輔助手術",
      "Fields": [
       {
        "Value": "RoboticOption",
        "Label": "是否限定",
        "Type": "String",
        "Options": [
         {
          "Value": "Y",
          "Label": "是"
         },
         {
          "Value": "N",
          "Label": "否"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     }
    ]
   },
   {
    "Value": "102",
    "Label": "服務項目代碼",
    "MainFields": [
     {
      "Value": "ServiceCodes",
      "Label": "服務項目代碼",
      "Type": "StringArray",
      "OptionsApi": "/api/v1/Options/PxxtCode/MHA/114",
      "Constraints": [
       {
        "Type": "Required",
        "Message": "必填欄位"
       }
      ]
     }
    ],
    "ReferenceFields": [
     {
      "Value": "ReferenceDates",
      "Label": "參考日期",
      "Type": "StringArray",
      "Options": [
       {
        "Value": "ApplyDate",
        "Label": "就醫日期"
       },
       {
        "Value": "ExecutionStartDate",
        "Label": "醫令執行起日"
       },
       {
        "Value": "TreatmentEndDate",
        "Label": "治療結束日"
       },
       {
        "Value": "AdmissionDate",
        "Label": "住院日期"
       },
       {
        "Value": "DischargeDate",
        "Label": "出院日期"
       },
       {
        "Value": "DispensingDate",
        "Label": "調劑日期"
       },
       {
        "Value": "PhysicalTherapyStartDate",
        "Label": "物理治療起日"
       },
       {
        "Value": "ExaminationDate",
        "Label": "檢驗日期"
       }
      ],
      "Default": [
       "ApplyDate",
       "ExecutionStartDate"
      ]
     }
    ],
    "Conditions": [
     {
      "Value": "CaseType",
      "Label": "案件分類",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "案件分類類別",
        "Type": "String",
        "Options": [
         {
          "Value": "101",
          "Label": "門診西醫"
         },
         {
          "Value": "104",
          "Label": "住診"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "CaseTypeOptions",
        "Label": "案件分類選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/{Category}",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "Level",
      "Label": "層級別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "LevelOptions",
        "Label": "層級別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/QRD/003",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "HospCode",
      "Label": "醫事類別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "醫事類別類型",
        "Type": "String",
        "Options": [
         {
          "Value": "011",
          "Label": "門診"
         },
         {
          "Value": "012",
          "Label": "住診"
         },
         {
          "Value": "013",
          "Label": "其他"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "HospCodeOptions",
        "Label": "醫事類別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/{Category}",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "OrderType",
      "Label": "醫令類別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "OrderTypeOptions",
        "Label": "醫令類別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/132",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "RelMode",
      "Label": "處方調劑方式",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "RelModeOptions",
        "Label": "處方調劑方式選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/131",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "SubMainDiagnosisCode",
      "Label": "主次診斷代碼",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "FilterOptions",
        "Label": "比對欄位",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "ICD9CM_CODE",
          "Label": "主診斷代碼"
         },
         {
          "Value": "ICD9CM_CODE1",
          "Label": "次診斷代碼(一)"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "PartCode",
      "Label": "部分負擔代碼",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "TreatmentArea",
      "Label": "診療之部位",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         },
         {
          "Value": "04",
          "Label": "群組"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "GroupOption",
        "Label": "群組",
        "Type": "String",
        "Options": [
         {
          "Value": "TreatmentG01",
          "Label": "群組一"
         },
         {
          "Value": "TreatmentG02",
          "Label": "群組二"
         },
         {
          "Value": "TreatmentG03",
          "Label": "群組三"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "04"
        }
       }
      ]
     },
     {
      "Value": "Age",
      "Label": "年齡",
      "Fields": [
       {
        "Value": "ReferenceDates",
        "Label": "基準日（可排序）",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "01",
          "Label": "就醫日期"
         },
         {
          "Value": "02",
          "Label": "醫令執行起日"
         },
         {
          "Value": "03",
          "Label": "治療結束日"
         },
         {
          "Value": "04",
          "Label": "住院日期"
         },
         {
          "Value": "05",
          "Label": "出院日期"
         },
         {
          "Value": "06",
          "Label": "調劑日期"
         },
         {
          "Value": "07",
          "Label": "物理治療起日"
         },
         {
          "Value": "08",
          "Label": "檢驗日期"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "OperatorMin",
        "Label": "下限運算子",
        "Type": "String",
        "Options": [
         {
          "Value": ">",
          "Label": "大於"
         },
         {
          "Value": ">=",
          "Label": "大於等於"
         }
        ]
       },
       {
        "Value": "Min",
        "Label": "下限",
        "Type": "Number",
        "Placeholder": "不填表示無下限"
       },
       {
        "Value": "OperatorMax",
        "Label": "上限運算子",
        "Type": "String",
        "Options": [
         {
          "Value": "<",
          "Label": "小於"
         },
         {
          "Value": "<=",
          "Label": "小於等於"
         }
        ]
       },
       {
        "Value": "Max",
        "Label": "上限",
        "Type": "Number",
        "Placeholder": "不填表示無上限"
       },
       {
        "Value": "Unit",
        "Label": "單位",
        "Type": "String",
        "Options": [
         {
          "Value": "Y",
          "Label": "歲"
         },
         {
          "Value": "M",
          "Label": "月"
         },
         {
          "Value": "D",
          "Label": "日"
         }
        ],
        "Default": "Y",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "AssociatedItems",
      "Label": "清單下併報項目",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "項目代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "TreatmentItems",
      "Label": "核定治療項目",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "FilterOptions",
        "Label": "比對欄位",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "01",
          "Label": "特殊治療項目代號（一）"
         },
         {
          "Value": "02",
          "Label": "特殊治療項目代號（二）"
         },
         {
          "Value": "03",
          "Label": "特殊治療項目代號（三）"
         },
         {
          "Value": "04",
          "Label": "特殊治療項目代號（四）"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "Department",
      "Label": "就醫科別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "DepartmentOptions",
        "Label": "就醫科別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PXX/997",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "Robotic",
      "Label": "僅機械手臂輔助手術",
      "Fields": [
       {
        "Value": "RoboticOption",
        "Label": "是否限定",
        "Type": "String",
        "Options": [
         {
          "Value": "Y",
          "Label": "是"
         },
         {
          "Value": "N",
          "Label": "否"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     }
    ]
   },
   {
    "Value": "103",
    "Label": "診療科別",
    "MainFields": [
     {
      "Value": "DeptCodes",
      "Label": "診療科別",
      "Type": "StringArray",
      "OptionsApi": "/api/v1/Options/PxxtCode/MHA/113",
      "Constraints": [
       {
        "Type": "Required",
        "Message": "必填欄位"
       }
      ]
     }
    ],
    "ReferenceFields": [
     {
      "Value": "ReferenceDates",
      "Label": "參考日期",
      "Type": "StringArray",
      "Options": [
       {
        "Value": "ApplyDate",
        "Label": "就醫日期"
       },
       {
        "Value": "ExecutionStartDate",
        "Label": "醫令執行起日"
       },
       {
        "Value": "TreatmentEndDate",
        "Label": "治療結束日"
       },
       {
        "Value": "AdmissionDate",
        "Label": "住院日期"
       },
       {
        "Value": "DischargeDate",
        "Label": "出院日期"
       },
       {
        "Value": "DispensingDate",
        "Label": "調劑日期"
       },
       {
        "Value": "PhysicalTherapyStartDate",
        "Label": "物理治療起日"
       },
       {
        "Value": "ExaminationDate",
        "Label": "檢驗日期"
       }
      ],
      "Default": [
       "ApplyDate",
       "ExecutionStartDate"
      ]
     },
     {
      "Value": "DoctorType",
      "Label": "醫師類別",
      "Type": "String",
      "Options": [
       {
        "Value": "Doctor",
        "Label": "醫師"
       },
       {
        "Value": "DoctorCm",
        "Label": "中醫師"
       },
       {
        "Value": "DoctorDental",
        "Label": "牙醫師"
       }
      ],
      "Default": "Doctor"
     }
    ],
    "Conditions": [
     {
      "Value": "CaseType",
      "Label": "案件分類",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "案件分類類別",
        "Type": "String",
        "Options": [
         {
          "Value": "101",
          "Label": "門診西醫"
         },
         {
          "Value": "104",
          "Label": "住診"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "CaseTypeOptions",
        "Label": "案件分類選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/{Category}",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "Level",
      "Label": "層級別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "LevelOptions",
        "Label": "層級別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/QRD/003",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "HospCode",
      "Label": "醫事類別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "醫事類別類型",
        "Type": "String",
        "Options": [
         {
          "Value": "011",
          "Label": "門診"
         },
         {
          "Value": "012",
          "Label": "住診"
         },
         {
          "Value": "013",
          "Label": "其他"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "HospCodeOptions",
        "Label": "醫事類別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/{Category}",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "OrderType",
      "Label": "醫令類別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "OrderTypeOptions",
        "Label": "醫令類別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/132",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "RelMode",
      "Label": "處方調劑方式",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "RelModeOptions",
        "Label": "處方調劑方式選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/131",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "SubMainDiagnosisCode",
      "Label": "主次診斷代碼",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "FilterOptions",
        "Label": "比對欄位",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "ICD9CM_CODE",
          "Label": "主診斷代碼"
         },
         {
          "Value": "ICD9CM_CODE1",
          "Label": "次診斷代碼(一)"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "PartCode",
      "Label": "部分負擔代碼",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "TreatmentArea",
      "Label": "診療之部位",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         },
         {
          "Value": "04",
          "Label": "群組"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "GroupOption",
        "Label": "群組",
        "Type": "String",
        "Options": [
         {
          "Value": "TreatmentG01",
          "Label": "群組一"
         },
         {
          "Value": "TreatmentG02",
          "Label": "群組二"
         },
         {
          "Value": "TreatmentG03",
          "Label": "群組三"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "04"
        }
       }
      ]
     },
     {
      "Value": "Age",
      "Label": "年齡",
      "Fields": [
       {
        "Value": "ReferenceDates",
        "Label": "基準日（可排序）",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "01",
          "Label": "就醫日期"
         },
         {
          "Value": "02",
          "Label": "醫令執行起日"
         },
         {
          "Value": "03",
          "Label": "治療結束日"
         },
         {
          "Value": "04",
          "Label": "住院日期"
         },
         {
          "Value": "05",
          "Label": "出院日期"
         },
         {
          "Value": "06",
          "Label": "調劑日期"
         },
         {
          "Value": "07",
          "Label": "物理治療起日"
         },
         {
          "Value": "08",
          "Label": "檢驗日期"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "OperatorMin",
        "Label": "下限運算子",
        "Type": "String",
        "Options": [
         {
          "Value": ">",
          "Label": "大於"
         },
         {
          "Value": ">=",
          "Label": "大於等於"
         }
        ]
       },
       {
        "Value": "Min",
        "Label": "下限",
        "Type": "Number",
        "Placeholder": "不填表示無下限"
       },
       {
        "Value": "OperatorMax",
        "Label": "上限運算子",
        "Type": "String",
        "Options": [
         {
          "Value": "<",
          "Label": "小於"
         },
         {
          "Value": "<=",
          "Label": "小於等於"
         }
        ]
       },
       {
        "Value": "Max",
        "Label": "上限",
        "Type": "Number",
        "Placeholder": "不填表示無上限"
       },
       {
        "Value": "Unit",
        "Label": "單位",
        "Type": "String",
        "Options": [
         {
          "Value": "Y",
          "Label": "歲"
         },
         {
          "Value": "M",
          "Label": "月"
         },
         {
          "Value": "D",
          "Label": "日"
         }
        ],
        "Default": "Y",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "AssociatedItems",
      "Label": "清單下併報項目",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "項目代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "TreatmentItems",
      "Label": "核定治療項目",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "FilterOptions",
        "Label": "比對欄位",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "01",
          "Label": "特殊治療項目代號（一）"
         },
         {
          "Value": "02",
          "Label": "特殊治療項目代號（二）"
         },
         {
          "Value": "03",
          "Label": "特殊治療項目代號（三）"
         },
         {
          "Value": "04",
          "Label": "特殊治療項目代號（四）"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "Department",
      "Label": "就醫科別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "DepartmentOptions",
        "Label": "就醫科別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PXX/997",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "Robotic",
      "Label": "僅機械手臂輔助手術",
      "Fields": [
       {
        "Value": "RoboticOption",
        "Label": "是否限定",
        "Type": "String",
        "Options": [
         {
          "Value": "Y",
          "Label": "是"
         },
         {
          "Value": "N",
          "Label": "否"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     }
    ]
   },
   {
    "Value": "104",
    "Label": "評鑑等級代號",
    "MainFields": [
     {
      "Value": "GradeCodes",
      "Label": "評鑑等級代號",
      "Type": "StringArray",
      "OptionsApi": "/api/v1/Options/PxxtCode/MHA/115",
      "Constraints": [
       {
        "Type": "Required",
        "Message": "必填欄位"
       }
      ]
     }
    ],
    "ReferenceFields": [
     {
      "Value": "ReferenceDates",
      "Label": "參考日期",
      "Type": "StringArray",
      "Options": [
       {
        "Value": "ApplyDate",
        "Label": "就醫日期"
       },
       {
        "Value": "ExecutionStartDate",
        "Label": "醫令執行起日"
       },
       {
        "Value": "TreatmentEndDate",
        "Label": "治療結束日"
       },
       {
        "Value": "AdmissionDate",
        "Label": "住院日期"
       },
       {
        "Value": "DischargeDate",
        "Label": "出院日期"
       },
       {
        "Value": "DispensingDate",
        "Label": "調劑日期"
       },
       {
        "Value": "PhysicalTherapyStartDate",
        "Label": "物理治療起日"
       },
       {
        "Value": "ExaminationDate",
        "Label": "檢驗日期"
       }
      ],
      "Default": [
       "ApplyDate",
       "ExecutionStartDate"
      ]
     }
    ],
    "Conditions": [
     {
      "Value": "CaseType",
      "Label": "案件分類",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "案件分類類別",
        "Type": "String",
        "Options": [
         {
          "Value": "101",
          "Label": "門診西醫"
         },
         {
          "Value": "104",
          "Label": "住診"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "CaseTypeOptions",
        "Label": "案件分類選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/{Category}",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "Level",
      "Label": "層級別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "LevelOptions",
        "Label": "層級別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/QRD/003",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "HospCode",
      "Label": "醫事類別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "醫事類別類型",
        "Type": "String",
        "Options": [
         {
          "Value": "011",
          "Label": "門診"
         },
         {
          "Value": "012",
          "Label": "住診"
         },
         {
          "Value": "013",
          "Label": "其他"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "HospCodeOptions",
        "Label": "醫事類別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/{Category}",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "OrderType",
      "Label": "醫令類別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "OrderTypeOptions",
        "Label": "醫令類別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/132",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "RelMode",
      "Label": "處方調劑方式",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "RelModeOptions",
        "Label": "處方調劑方式選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/131",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "SubMainDiagnosisCode",
      "Label": "主次診斷代碼",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "FilterOptions",
        "Label": "比對欄位",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "ICD9CM_CODE",
          "Label": "主診斷代碼"
         },
         {
          "Value": "ICD9CM_CODE1",
          "Label": "次診斷代碼(一)"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "PartCode",
      "Label": "部分負擔代碼",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "TreatmentArea",
      "Label": "診療之部位",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         },
         {
          "Value": "04",
          "Label": "群組"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "GroupOption",
        "Label": "群組",
        "Type": "String",
        "Options": [
         {
          "Value": "TreatmentG01",
          "Label": "群組一"
         },
         {
          "Value": "TreatmentG02",
          "Label": "群組二"
         },
         {
          "Value": "TreatmentG03",
          "Label": "群組三"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "04"
        }
       }
      ]
     },
     {
      "Value": "Age",
      "Label": "年齡",
      "Fields": [
       {
        "Value": "ReferenceDates",
        "Label": "基準日（可排序）",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "01",
          "Label": "就醫日期"
         },
         {
          "Value": "02",
          "Label": "醫令執行起日"
         },
         {
          "Value": "03",
          "Label": "治療結束日"
         },
         {
          "Value": "04",
          "Label": "住院日期"
         },
         {
          "Value": "05",
          "Label": "出院日期"
         },
         {
          "Value": "06",
          "Label": "調劑日期"
         },
         {
          "Value": "07",
          "Label": "物理治療起日"
         },
         {
          "Value": "08",
          "Label": "檢驗日期"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "OperatorMin",
        "Label": "下限運算子",
        "Type": "String",
        "Options": [
         {
          "Value": ">",
          "Label": "大於"
         },
         {
          "Value": ">=",
          "Label": "大於等於"
         }
        ]
       },
       {
        "Value": "Min",
        "Label": "下限",
        "Type": "Number",
        "Placeholder": "不填表示無下限"
       },
       {
        "Value": "OperatorMax",
        "Label": "上限運算子",
        "Type": "String",
        "Options": [
         {
          "Value": "<",
          "Label": "小於"
         },
         {
          "Value": "<=",
          "Label": "小於等於"
         }
        ]
       },
       {
        "Value": "Max",
        "Label": "上限",
        "Type": "Number",
        "Placeholder": "不填表示無上限"
       },
       {
        "Value": "Unit",
        "Label": "單位",
        "Type": "String",
        "Options": [
         {
          "Value": "Y",
          "Label": "歲"
         },
         {
          "Value": "M",
          "Label": "月"
         },
         {
          "Value": "D",
          "Label": "日"
         }
        ],
        "Default": "Y",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "AssociatedItems",
      "Label": "清單下併報項目",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "項目代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "TreatmentItems",
      "Label": "核定治療項目",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "FilterOptions",
        "Label": "比對欄位",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "01",
          "Label": "特殊治療項目代號（一）"
         },
         {
          "Value": "02",
          "Label": "特殊治療項目代號（二）"
         },
         {
          "Value": "03",
          "Label": "特殊治療項目代號（三）"
         },
         {
          "Value": "04",
          "Label": "特殊治療項目代號（四）"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "Department",
      "Label": "就醫科別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "DepartmentOptions",
        "Label": "就醫科別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PXX/997",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "Robotic",
      "Label": "僅機械手臂輔助手術",
      "Fields": [
       {
        "Value": "RoboticOption",
        "Label": "是否限定",
        "Type": "String",
        "Options": [
         {
          "Value": "Y",
          "Label": "是"
         },
         {
          "Value": "N",
          "Label": "否"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     }
    ]
   },
   {
    "Value": "105",
    "Label": "需事前報備",
    "MainFields": [
     {
      "Value": "Note",
      "Label": "說明",
      "Type": "String"
     }
    ],
    "ReferenceFields": [
     {
      "Value": "ReferenceDates",
      "Label": "參考日期",
      "Type": "StringArray",
      "Options": [
       {
        "Value": "ApplyDate",
        "Label": "就醫日期"
       },
       {
        "Value": "ExecutionStartDate",
        "Label": "醫令執行起日"
       },
       {
        "Value": "TreatmentEndDate",
        "Label": "治療結束日"
       },
       {
        "Value": "AdmissionDate",
        "Label": "住院日期"
       },
       {
        "Value": "DischargeDate",
        "Label": "出院日期"
       },
       {
        "Value": "DispensingDate",
        "Label": "調劑日期"
       },
       {
        "Value": "PhysicalTherapyStartDate",
        "Label": "物理治療起日"
       },
       {
        "Value": "ExaminationDate",
        "Label": "檢驗日期"
       }
      ],
      "Default": [
       "ApplyDate",
       "ExecutionStartDate"
      ]
     }
    ],
    "Conditions": [
     {
      "Value": "CaseType",
      "Label": "案件分類",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "案件分類類別",
        "Type": "String",
        "Options": [
         {
          "Value": "101",
          "Label": "門診西醫"
         },
         {
          "Value": "104",
          "Label": "住診"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "CaseTypeOptions",
        "Label": "案件分類選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/{Category}",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "Level",
      "Label": "層級別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "LevelOptions",
        "Label": "層級別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/QRD/003",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "HospCode",
      "Label": "醫事類別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "醫事類別類型",
        "Type": "String",
        "Options": [
         {
          "Value": "011",
          "Label": "門診"
         },
         {
          "Value": "012",
          "Label": "住診"
         },
         {
          "Value": "013",
          "Label": "其他"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "HospCodeOptions",
        "Label": "醫事類別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/{Category}",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "OrderType",
      "Label": "醫令類別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "OrderTypeOptions",
        "Label": "醫令類別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/132",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "RelMode",
      "Label": "處方調劑方式",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "RelModeOptions",
        "Label": "處方調劑方式選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/131",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "SubMainDiagnosisCode",
      "Label": "主次診斷代碼",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "FilterOptions",
        "Label": "比對欄位",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "ICD9CM_CODE",
          "Label": "主診斷代碼"
         },
         {
          "Value": "ICD9CM_CODE1",
          "Label": "次診斷代碼(一)"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "PartCode",
      "Label": "部分負擔代碼",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "TreatmentArea",
      "Label": "診療之部位",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         },
         {
          "Value": "04",
          "Label": "群組"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "GroupOption",
        "Label": "群組",
        "Type": "String",
        "Options": [
         {
          "Value": "TreatmentG01",
          "Label": "群組一"
         },
         {
          "Value": "TreatmentG02",
          "Label": "群組二"
         },
         {
          "Value": "TreatmentG03",
          "Label": "群組三"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "04"
        }
       }
      ]
     },
     {
      "Value": "Age",
      "Label": "年齡",
      "Fields": [
       {
        "Value": "ReferenceDates",
        "Label": "基準日（可排序）",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "01",
          "Label": "就醫日期"
         },
         {
          "Value": "02",
          "Label": "醫令執行起日"
         },
         {
          "Value": "03",
          "Label": "治療結束日"
         },
         {
          "Value": "04",
          "Label": "住院日期"
         },
         {
          "Value": "05",
          "Label": "出院日期"
         },
         {
          "Value": "06",
          "Label": "調劑日期"
         },
         {
          "Value": "07",
          "Label": "物理治療起日"
         },
         {
          "Value": "08",
          "Label": "檢驗日期"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "OperatorMin",
        "Label": "下限運算子",
        "Type": "String",
        "Options": [
         {
          "Value": ">",
          "Label": "大於"
         },
         {
          "Value": ">=",
          "Label": "大於等於"
         }
        ]
       },
       {
        "Value": "Min",
        "Label": "下限",
        "Type": "Number",
        "Placeholder": "不填表示無下限"
       },
       {
        "Value": "OperatorMax",
        "Label": "上限運算子",
        "Type": "String",
        "Options": [
         {
          "Value": "<",
          "Label": "小於"
         },
         {
          "Value": "<=",
          "Label": "小於等於"
         }
        ]
       },
       {
        "Value": "Max",
        "Label": "上限",
        "Type": "Number",
        "Placeholder": "不填表示無上限"
       },
       {
        "Value": "Unit",
        "Label": "單位",
        "Type": "String",
        "Options": [
         {
          "Value": "Y",
          "Label": "歲"
         },
         {
          "Value": "M",
          "Label": "月"
         },
         {
          "Value": "D",
          "Label": "日"
         }
        ],
        "Default": "Y",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "AssociatedItems",
      "Label": "清單下併報項目",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "項目代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "TreatmentItems",
      "Label": "核定治療項目",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "FilterOptions",
        "Label": "比對欄位",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "01",
          "Label": "特殊治療項目代號（一）"
         },
         {
          "Value": "02",
          "Label": "特殊治療項目代號（二）"
         },
         {
          "Value": "03",
          "Label": "特殊治療項目代號（三）"
         },
         {
          "Value": "04",
          "Label": "特殊治療項目代號（四）"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "Department",
      "Label": "就醫科別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "DepartmentOptions",
        "Label": "就醫科別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PXX/997",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "Robotic",
      "Label": "僅機械手臂輔助手術",
      "Fields": [
       {
        "Value": "RoboticOption",
        "Label": "是否限定",
        "Type": "String",
        "Options": [
         {
          "Value": "Y",
          "Label": "是"
         },
         {
          "Value": "N",
          "Label": "否"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     }
    ]
   },
   {
    "Value": "106",
    "Label": "限制特殊設備",
    "MainFields": [
     {
      "Value": "EquipmentCodes",
      "Label": "特殊設備",
      "Type": "StringArray",
      "OptionsApi": "/api/v1/Options/PxxtCode/MHA/112",
      "Constraints": [
       {
        "Type": "Required",
        "Message": "必填欄位"
       }
      ]
     }
    ],
    "ReferenceFields": [
     {
      "Value": "ReferenceDates",
      "Label": "參考日期",
      "Type": "StringArray",
      "Options": [
       {
        "Value": "ApplyDate",
        "Label": "就醫日期"
       },
       {
        "Value": "ExecutionStartDate",
        "Label": "醫令執行起日"
       },
       {
        "Value": "TreatmentEndDate",
        "Label": "治療結束日"
       },
       {
        "Value": "AdmissionDate",
        "Label": "住院日期"
       },
       {
        "Value": "DischargeDate",
        "Label": "出院日期"
       },
       {
        "Value": "DispensingDate",
        "Label": "調劑日期"
       },
       {
        "Value": "PhysicalTherapyStartDate",
        "Label": "物理治療起日"
       },
       {
        "Value": "ExaminationDate",
        "Label": "檢驗日期"
       }
      ],
      "Default": [
       "ApplyDate",
       "ExecutionStartDate"
      ]
     },
     {
      "Value": "HospCodes",
      "Label": "醫事機構代號欄位",
      "Type": "StringArray",
      "Options": [
       {
        "Value": "HOSP_ID",
        "Label": "醫事機構代號"
       },
       {
        "Value": "REAL_HOSP_ID",
        "Label": "實際服務機構代號"
       },
       {
        "Value": "TRAN_INSPECT_HOSP_ID",
        "Label": "轉(代)檢醫事機構代號"
       }
      ],
      "Default": [
       "HOSP_ID",
       "REAL_HOSP_ID",
       "TRAN_INSPECT_HOSP_ID"
      ]
     }
    ],
    "Conditions": [
     {
      "Value": "CaseType",
      "Label": "案件分類",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "案件分類類別",
        "Type": "String",
        "Options": [
         {
          "Value": "101",
          "Label": "門診西醫"
         },
         {
          "Value": "104",
          "Label": "住診"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "CaseTypeOptions",
        "Label": "案件分類選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/{Category}",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "Level",
      "Label": "層級別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "LevelOptions",
        "Label": "層級別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/QRD/003",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "HospCode",
      "Label": "醫事類別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "醫事類別類型",
        "Type": "String",
        "Options": [
         {
          "Value": "011",
          "Label": "門診"
         },
         {
          "Value": "012",
          "Label": "住診"
         },
         {
          "Value": "013",
          "Label": "其他"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "HospCodeOptions",
        "Label": "醫事類別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/{Category}",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "OrderType",
      "Label": "醫令類別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "OrderTypeOptions",
        "Label": "醫令類別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/132",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "RelMode",
      "Label": "處方調劑方式",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "RelModeOptions",
        "Label": "處方調劑方式選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/131",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "SubMainDiagnosisCode",
      "Label": "主次診斷代碼",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "FilterOptions",
        "Label": "比對欄位",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "ICD9CM_CODE",
          "Label": "主診斷代碼"
         },
         {
          "Value": "ICD9CM_CODE1",
          "Label": "次診斷代碼(一)"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "PartCode",
      "Label": "部分負擔代碼",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "TreatmentArea",
      "Label": "診療之部位",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         },
         {
          "Value": "04",
          "Label": "群組"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "GroupOption",
        "Label": "群組",
        "Type": "String",
        "Options": [
         {
          "Value": "TreatmentG01",
          "Label": "群組一"
         },
         {
          "Value": "TreatmentG02",
          "Label": "群組二"
         },
         {
          "Value": "TreatmentG03",
          "Label": "群組三"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "04"
        }
       }
      ]
     },
     {
      "Value": "Age",
      "Label": "年齡",
      "Fields": [
       {
        "Value": "ReferenceDates",
        "Label": "基準日（可排序）",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "01",
          "Label": "就醫日期"
         },
         {
          "Value": "02",
          "Label": "醫令執行起日"
         },
         {
          "Value": "03",
          "Label": "治療結束日"
         },
         {
          "Value": "04",
          "Label": "住院日期"
         },
         {
          "Value": "05",
          "Label": "出院日期"
         },
         {
          "Value": "06",
          "Label": "調劑日期"
         },
         {
          "Value": "07",
          "Label": "物理治療起日"
         },
         {
          "Value": "08",
          "Label": "檢驗日期"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "OperatorMin",
        "Label": "下限運算子",
        "Type": "String",
        "Options": [
         {
          "Value": ">",
          "Label": "大於"
         },
         {
          "Value": ">=",
          "Label": "大於等於"
         }
        ]
       },
       {
        "Value": "Min",
        "Label": "下限",
        "Type": "Number",
        "Placeholder": "不填表示無下限"
       },
       {
        "Value": "OperatorMax",
        "Label": "上限運算子",
        "Type": "String",
        "Options": [
         {
          "Value": "<",
          "Label": "小於"
         },
         {
          "Value": "<=",
          "Label": "小於等於"
         }
        ]
       },
       {
        "Value": "Max",
        "Label": "上限",
        "Type": "Number",
        "Placeholder": "不填表示無上限"
       },
       {
        "Value": "Unit",
        "Label": "單位",
        "Type": "String",
        "Options": [
         {
          "Value": "Y",
          "Label": "歲"
         },
         {
          "Value": "M",
          "Label": "月"
         },
         {
          "Value": "D",
          "Label": "日"
         }
        ],
        "Default": "Y",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "AssociatedItems",
      "Label": "清單下併報項目",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "項目代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "TreatmentItems",
      "Label": "核定治療項目",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "FilterOptions",
        "Label": "比對欄位",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "01",
          "Label": "特殊治療項目代號（一）"
         },
         {
          "Value": "02",
          "Label": "特殊治療項目代號（二）"
         },
         {
          "Value": "03",
          "Label": "特殊治療項目代號（三）"
         },
         {
          "Value": "04",
          "Label": "特殊治療項目代號（四）"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "Department",
      "Label": "就醫科別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "DepartmentOptions",
        "Label": "就醫科別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PXX/997",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "Robotic",
      "Label": "僅機械手臂輔助手術",
      "Fields": [
       {
        "Value": "RoboticOption",
        "Label": "是否限定",
        "Type": "String",
        "Options": [
         {
          "Value": "Y",
          "Label": "是"
         },
         {
          "Value": "N",
          "Label": "否"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     }
    ]
   },
   {
    "Value": "201",
    "Label": "限制申報科別",
    "MainFields": [
     {
      "Value": "DeptCodes",
      "Label": "申報科別",
      "Type": "StringArray",
      "OptionsApi": "/api/v1/Options/PxxtCode/PXX/997",
      "Constraints": [
       {
        "Type": "Required",
        "Message": "必填欄位"
       }
      ]
     }
    ],
    "Conditions": [
     {
      "Value": "CaseType",
      "Label": "案件分類",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "案件分類類別",
        "Type": "String",
        "Options": [
         {
          "Value": "101",
          "Label": "門診西醫"
         },
         {
          "Value": "104",
          "Label": "住診"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "CaseTypeOptions",
        "Label": "案件分類選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/{Category}",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "Level",
      "Label": "層級別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "LevelOptions",
        "Label": "層級別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/QRD/003",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ],
      "Disabled": true
     },
     {
      "Value": "HospCode",
      "Label": "醫事類別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "醫事類別類型",
        "Type": "String",
        "Options": [
         {
          "Value": "011",
          "Label": "門診"
         },
         {
          "Value": "012",
          "Label": "住診"
         },
         {
          "Value": "013",
          "Label": "其他"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "HospCodeOptions",
        "Label": "醫事類別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/{Category}",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "OrderType",
      "Label": "醫令類別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "OrderTypeOptions",
        "Label": "醫令類別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/132",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "RelMode",
      "Label": "處方調劑方式",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "RelModeOptions",
        "Label": "處方調劑方式選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/131",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ],
      "Disabled": true
     },
     {
      "Value": "SubMainDiagnosisCode",
      "Label": "主次診斷代碼",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "FilterOptions",
        "Label": "比對欄位",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "ICD9CM_CODE",
          "Label": "主診斷代碼"
         },
         {
          "Value": "ICD9CM_CODE1",
          "Label": "次診斷代碼(一)"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ],
      "Disabled": true
     },
     {
      "Value": "PartCode",
      "Label": "部分負擔代碼",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ],
      "Disabled": true
     },
     {
      "Value": "TreatmentArea",
      "Label": "診療之部位",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         },
         {
          "Value": "04",
          "Label": "群組"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "GroupOption",
        "Label": "群組",
        "Type": "String",
        "Options": [
         {
          "Value": "TreatmentG01",
          "Label": "群組一"
         },
         {
          "Value": "TreatmentG02",
          "Label": "群組二"
         },
         {
          "Value": "TreatmentG03",
          "Label": "群組三"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "04"
        }
       }
      ],
      "Disabled": true
     },
     {
      "Value": "Age",
      "Label": "年齡",
      "Fields": [
       {
        "Value": "ReferenceDates",
        "Label": "基準日（可排序）",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "01",
          "Label": "就醫日期"
         },
         {
          "Value": "02",
          "Label": "醫令執行起日"
         },
         {
          "Value": "03",
          "Label": "治療結束日"
         },
         {
          "Value": "04",
          "Label": "住院日期"
         },
         {
          "Value": "05",
          "Label": "出院日期"
         },
         {
          "Value": "06",
          "Label": "調劑日期"
         },
         {
          "Value": "07",
          "Label": "物理治療起日"
         },
         {
          "Value": "08",
          "Label": "檢驗日期"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "OperatorMin",
        "Label": "下限運算子",
        "Type": "String",
        "Options": [
         {
          "Value": ">",
          "Label": "大於"
         },
         {
          "Value": ">=",
          "Label": "大於等於"
         }
        ]
       },
       {
        "Value": "Min",
        "Label": "下限",
        "Type": "Number",
        "Placeholder": "不填表示無下限"
       },
       {
        "Value": "OperatorMax",
        "Label": "上限運算子",
        "Type": "String",
        "Options": [
         {
          "Value": "<",
          "Label": "小於"
         },
         {
          "Value": "<=",
          "Label": "小於等於"
         }
        ]
       },
       {
        "Value": "Max",
        "Label": "上限",
        "Type": "Number",
        "Placeholder": "不填表示無上限"
       },
       {
        "Value": "Unit",
        "Label": "單位",
        "Type": "String",
        "Options": [
         {
          "Value": "Y",
          "Label": "歲"
         },
         {
          "Value": "M",
          "Label": "月"
         },
         {
          "Value": "D",
          "Label": "日"
         }
        ],
        "Default": "Y",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ],
      "Disabled": true
     },
     {
      "Value": "AssociatedItems",
      "Label": "清單下併報項目",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "項目代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ],
      "Disabled": true
     },
     {
      "Value": "TreatmentItems",
      "Label": "核定治療項目",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "FilterOptions",
        "Label": "比對欄位",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "01",
          "Label": "特殊治療項目代號（一）"
         },
         {
          "Value": "02",
          "Label": "特殊治療項目代號（二）"
         },
         {
          "Value": "03",
          "Label": "特殊治療項目代號（三）"
         },
         {
          "Value": "04",
          "Label": "特殊治療項目代號（四）"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ],
      "Disabled": true
     },
     {
      "Value": "Department",
      "Label": "就醫科別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "DepartmentOptions",
        "Label": "就醫科別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PXX/997",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "Robotic",
      "Label": "僅機械手臂輔助手術",
      "Fields": [
       {
        "Value": "RoboticOption",
        "Label": "是否限定",
        "Type": "String",
        "Options": [
         {
          "Value": "Y",
          "Label": "是"
         },
         {
          "Value": "N",
          "Label": "否"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ],
      "Disabled": true
     }
    ]
   },
   {
    "Value": "202",
    "Label": "限專科醫師別",
    "MainFields": [
     {
      "Value": "SpecialistCodes",
      "Label": "專科醫師別",
      "Type": "StringArray",
      "OptionsApi": "/api/v1/Options/PxxtCode/MHA/123?$filter=Value ge 'A0100' and Value le 'C1300'",
      "Constraints": [
       {
        "Type": "Required",
        "Message": "必填欄位"
       }
      ]
     },
     {
      "Value": "DoctorRole",
      "Label": "執行醫師",
      "Type": "String",
      "Options": [
       {
        "Value": "Executor",
        "Label": "執行醫師"
       },
       {
        "Value": "FullTime",
        "Label": "專任"
       }
      ]
     }
    ],
    "ReferenceFields": [
     {
      "Value": "ReferenceDates",
      "Label": "參考日期",
      "Type": "StringArray",
      "Options": [
       {
        "Value": "ApplyDate",
        "Label": "就醫日期"
       },
       {
        "Value": "ExecutionStartDate",
        "Label": "醫令執行起日"
       },
       {
        "Value": "TreatmentEndDate",
        "Label": "治療結束日"
       },
       {
        "Value": "AdmissionDate",
        "Label": "住院日期"
       },
       {
        "Value": "DischargeDate",
        "Label": "出院日期"
       },
       {
        "Value": "DispensingDate",
        "Label": "調劑日期"
       },
       {
        "Value": "PhysicalTherapyStartDate",
        "Label": "物理治療起日"
       },
       {
        "Value": "ExaminationDate",
        "Label": "檢驗日期"
       }
      ],
      "Default": [
       "ApplyDate",
       "ExecutionStartDate"
      ]
     },
     {
      "Value": "DoctorTypes",
      "Label": "醫師角色",
      "Type": "StringArray",
      "Options": [
       {
        "Value": "01",
        "Label": "執行醫師"
       },
       {
        "Value": "02",
        "Label": "處方醫師"
       },
       {
        "Value": "03",
        "Label": "遠距"
       }
      ],
      "Default": [
       "01",
       "02",
       "03"
      ]
     },
     {
      "Value": "HospCodes",
      "Label": "醫事機構代號欄位",
      "Type": "StringArray",
      "Options": [
       {
        "Value": "HOSP_ID",
        "Label": "醫事機構代號"
       },
       {
        "Value": "REAL_HOSP_ID",
        "Label": "實際服務機構代號"
       },
       {
        "Value": "TRAN_INSPECT_HOSP_ID",
        "Label": "轉(代)檢醫事機構代號"
       }
      ],
      "Default": [
       "HOSP_ID",
       "REAL_HOSP_ID",
       "TRAN_INSPECT_HOSP_ID"
      ]
     }
    ],
    "Conditions": [
     {
      "Value": "CaseType",
      "Label": "案件分類",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "案件分類類別",
        "Type": "String",
        "Options": [
         {
          "Value": "101",
          "Label": "門診西醫"
         },
         {
          "Value": "104",
          "Label": "住診"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "CaseTypeOptions",
        "Label": "案件分類選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/{Category}",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "Level",
      "Label": "層級別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "LevelOptions",
        "Label": "層級別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/QRD/003",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "HospCode",
      "Label": "醫事類別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "醫事類別類型",
        "Type": "String",
        "Options": [
         {
          "Value": "011",
          "Label": "門診"
         },
         {
          "Value": "012",
          "Label": "住診"
         },
         {
          "Value": "013",
          "Label": "其他"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "HospCodeOptions",
        "Label": "醫事類別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/{Category}",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "OrderType",
      "Label": "醫令類別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "OrderTypeOptions",
        "Label": "醫令類別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/132",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "RelMode",
      "Label": "處方調劑方式",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "RelModeOptions",
        "Label": "處方調劑方式選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/131",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "SubMainDiagnosisCode",
      "Label": "主次診斷代碼",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "FilterOptions",
        "Label": "比對欄位",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "ICD9CM_CODE",
          "Label": "主診斷代碼"
         },
         {
          "Value": "ICD9CM_CODE1",
          "Label": "次診斷代碼(一)"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "PartCode",
      "Label": "部分負擔代碼",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "TreatmentArea",
      "Label": "診療之部位",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         },
         {
          "Value": "04",
          "Label": "群組"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "GroupOption",
        "Label": "群組",
        "Type": "String",
        "Options": [
         {
          "Value": "TreatmentG01",
          "Label": "群組一"
         },
         {
          "Value": "TreatmentG02",
          "Label": "群組二"
         },
         {
          "Value": "TreatmentG03",
          "Label": "群組三"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "04"
        }
       }
      ]
     },
     {
      "Value": "Age",
      "Label": "年齡",
      "Fields": [
       {
        "Value": "ReferenceDates",
        "Label": "基準日（可排序）",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "01",
          "Label": "就醫日期"
         },
         {
          "Value": "02",
          "Label": "醫令執行起日"
         },
         {
          "Value": "03",
          "Label": "治療結束日"
         },
         {
          "Value": "04",
          "Label": "住院日期"
         },
         {
          "Value": "05",
          "Label": "出院日期"
         },
         {
          "Value": "06",
          "Label": "調劑日期"
         },
         {
          "Value": "07",
          "Label": "物理治療起日"
         },
         {
          "Value": "08",
          "Label": "檢驗日期"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "OperatorMin",
        "Label": "下限運算子",
        "Type": "String",
        "Options": [
         {
          "Value": ">",
          "Label": "大於"
         },
         {
          "Value": ">=",
          "Label": "大於等於"
         }
        ]
       },
       {
        "Value": "Min",
        "Label": "下限",
        "Type": "Number",
        "Placeholder": "不填表示無下限"
       },
       {
        "Value": "OperatorMax",
        "Label": "上限運算子",
        "Type": "String",
        "Options": [
         {
          "Value": "<",
          "Label": "小於"
         },
         {
          "Value": "<=",
          "Label": "小於等於"
         }
        ]
       },
       {
        "Value": "Max",
        "Label": "上限",
        "Type": "Number",
        "Placeholder": "不填表示無上限"
       },
       {
        "Value": "Unit",
        "Label": "單位",
        "Type": "String",
        "Options": [
         {
          "Value": "Y",
          "Label": "歲"
         },
         {
          "Value": "M",
          "Label": "月"
         },
         {
          "Value": "D",
          "Label": "日"
         }
        ],
        "Default": "Y",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "AssociatedItems",
      "Label": "清單下併報項目",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "項目代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "TreatmentItems",
      "Label": "核定治療項目",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "FilterOptions",
        "Label": "比對欄位",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "01",
          "Label": "特殊治療項目代號（一）"
         },
         {
          "Value": "02",
          "Label": "特殊治療項目代號（二）"
         },
         {
          "Value": "03",
          "Label": "特殊治療項目代號（三）"
         },
         {
          "Value": "04",
          "Label": "特殊治療項目代號（四）"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "Department",
      "Label": "就醫科別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "DepartmentOptions",
        "Label": "就醫科別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PXX/997",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "Robotic",
      "Label": "僅機械手臂輔助手術",
      "Fields": [
       {
        "Value": "RoboticOption",
        "Label": "是否限定",
        "Type": "String",
        "Options": [
         {
          "Value": "Y",
          "Label": "是"
         },
         {
          "Value": "N",
          "Label": "否"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     }
    ]
   },
   {
    "Value": "203",
    "Label": "醫事人員類別",
    "MainFields": [
     {
      "Value": "PersonnelTypes",
      "Label": "醫事人員類別",
      "Type": "StringArray",
      "OptionsApi": "/api/v1/Options/PxxtCode/MHA/121",
      "Constraints": [
       {
        "Type": "Required",
        "Message": "必填欄位"
       }
      ]
     }
    ],
    "ReferenceFields": [
     {
      "Value": "ReferenceDates",
      "Label": "參考日期",
      "Type": "StringArray",
      "Options": [
       {
        "Value": "ApplyDate",
        "Label": "就醫日期"
       },
       {
        "Value": "ExecutionStartDate",
        "Label": "醫令執行起日"
       },
       {
        "Value": "TreatmentEndDate",
        "Label": "治療結束日"
       },
       {
        "Value": "AdmissionDate",
        "Label": "住院日期"
       },
       {
        "Value": "DischargeDate",
        "Label": "出院日期"
       },
       {
        "Value": "DispensingDate",
        "Label": "調劑日期"
       },
       {
        "Value": "PhysicalTherapyStartDate",
        "Label": "物理治療起日"
       },
       {
        "Value": "ExaminationDate",
        "Label": "檢驗日期"
       }
      ],
      "Default": [
       "ApplyDate",
       "ExecutionStartDate"
      ]
     },
     {
      "Value": "HospCodes",
      "Label": "醫事機構代號欄位",
      "Type": "StringArray",
      "Options": [
       {
        "Value": "HOSP_ID",
        "Label": "醫事機構代號"
       },
       {
        "Value": "REAL_HOSP_ID",
        "Label": "實際服務機構代號"
       },
       {
        "Value": "TRAN_INSPECT_HOSP_ID",
        "Label": "轉(代)檢醫事機構代號"
       }
      ],
      "Default": [
       "HOSP_ID",
       "REAL_HOSP_ID",
       "TRAN_INSPECT_HOSP_ID"
      ]
     }
    ],
    "Conditions": [
     {
      "Value": "CaseType",
      "Label": "案件分類",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "案件分類類別",
        "Type": "String",
        "Options": [
         {
          "Value": "101",
          "Label": "門診西醫"
         },
         {
          "Value": "104",
          "Label": "住診"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "CaseTypeOptions",
        "Label": "案件分類選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/{Category}",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "Level",
      "Label": "層級別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "LevelOptions",
        "Label": "層級別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/QRD/003",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "HospCode",
      "Label": "醫事類別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "醫事類別類型",
        "Type": "String",
        "Options": [
         {
          "Value": "011",
          "Label": "門診"
         },
         {
          "Value": "012",
          "Label": "住診"
         },
         {
          "Value": "013",
          "Label": "其他"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "HospCodeOptions",
        "Label": "醫事類別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/{Category}",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "OrderType",
      "Label": "醫令類別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "OrderTypeOptions",
        "Label": "醫令類別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/132",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "RelMode",
      "Label": "處方調劑方式",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "RelModeOptions",
        "Label": "處方調劑方式選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/131",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "SubMainDiagnosisCode",
      "Label": "主次診斷代碼",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "FilterOptions",
        "Label": "比對欄位",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "ICD9CM_CODE",
          "Label": "主診斷代碼"
         },
         {
          "Value": "ICD9CM_CODE1",
          "Label": "次診斷代碼(一)"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "PartCode",
      "Label": "部分負擔代碼",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "TreatmentArea",
      "Label": "診療之部位",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         },
         {
          "Value": "04",
          "Label": "群組"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "GroupOption",
        "Label": "群組",
        "Type": "String",
        "Options": [
         {
          "Value": "TreatmentG01",
          "Label": "群組一"
         },
         {
          "Value": "TreatmentG02",
          "Label": "群組二"
         },
         {
          "Value": "TreatmentG03",
          "Label": "群組三"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "04"
        }
       }
      ]
     },
     {
      "Value": "Age",
      "Label": "年齡",
      "Fields": [
       {
        "Value": "ReferenceDates",
        "Label": "基準日（可排序）",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "01",
          "Label": "就醫日期"
         },
         {
          "Value": "02",
          "Label": "醫令執行起日"
         },
         {
          "Value": "03",
          "Label": "治療結束日"
         },
         {
          "Value": "04",
          "Label": "住院日期"
         },
         {
          "Value": "05",
          "Label": "出院日期"
         },
         {
          "Value": "06",
          "Label": "調劑日期"
         },
         {
          "Value": "07",
          "Label": "物理治療起日"
         },
         {
          "Value": "08",
          "Label": "檢驗日期"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "OperatorMin",
        "Label": "下限運算子",
        "Type": "String",
        "Options": [
         {
          "Value": ">",
          "Label": "大於"
         },
         {
          "Value": ">=",
          "Label": "大於等於"
         }
        ]
       },
       {
        "Value": "Min",
        "Label": "下限",
        "Type": "Number",
        "Placeholder": "不填表示無下限"
       },
       {
        "Value": "OperatorMax",
        "Label": "上限運算子",
        "Type": "String",
        "Options": [
         {
          "Value": "<",
          "Label": "小於"
         },
         {
          "Value": "<=",
          "Label": "小於等於"
         }
        ]
       },
       {
        "Value": "Max",
        "Label": "上限",
        "Type": "Number",
        "Placeholder": "不填表示無上限"
       },
       {
        "Value": "Unit",
        "Label": "單位",
        "Type": "String",
        "Options": [
         {
          "Value": "Y",
          "Label": "歲"
         },
         {
          "Value": "M",
          "Label": "月"
         },
         {
          "Value": "D",
          "Label": "日"
         }
        ],
        "Default": "Y",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "AssociatedItems",
      "Label": "清單下併報項目",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "項目代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "TreatmentItems",
      "Label": "核定治療項目",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "FilterOptions",
        "Label": "比對欄位",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "01",
          "Label": "特殊治療項目代號（一）"
         },
         {
          "Value": "02",
          "Label": "特殊治療項目代號（二）"
         },
         {
          "Value": "03",
          "Label": "特殊治療項目代號（三）"
         },
         {
          "Value": "04",
          "Label": "特殊治療項目代號（四）"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "Department",
      "Label": "就醫科別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "DepartmentOptions",
        "Label": "就醫科別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PXX/997",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "Robotic",
      "Label": "僅機械手臂輔助手術",
      "Fields": [
       {
        "Value": "RoboticOption",
        "Label": "是否限定",
        "Type": "String",
        "Options": [
         {
          "Value": "Y",
          "Label": "是"
         },
         {
          "Value": "N",
          "Label": "否"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     }
    ]
   },
   {
    "Value": "204",
    "Label": "限醫事人員資格",
    "MainFields": [
     {
      "Value": "QualificationCodes",
      "Label": "醫事人員資格",
      "Type": "StringArray",
      "OptionsApi": "/api/v1/Options/PxxtCode/MHA/127",
      "Constraints": [
       {
        "Type": "Required",
        "Message": "必填欄位"
       }
      ]
     }
    ],
    "ReferenceFields": [
     {
      "Value": "ReferenceDates",
      "Label": "參考日期",
      "Type": "StringArray",
      "Options": [
       {
        "Value": "ApplyDate",
        "Label": "就醫日期"
       },
       {
        "Value": "ExecutionStartDate",
        "Label": "醫令執行起日"
       },
       {
        "Value": "TreatmentEndDate",
        "Label": "治療結束日"
       },
       {
        "Value": "AdmissionDate",
        "Label": "住院日期"
       },
       {
        "Value": "DischargeDate",
        "Label": "出院日期"
       },
       {
        "Value": "DispensingDate",
        "Label": "調劑日期"
       },
       {
        "Value": "PhysicalTherapyStartDate",
        "Label": "物理治療起日"
       },
       {
        "Value": "ExaminationDate",
        "Label": "檢驗日期"
       }
      ],
      "Default": [
       "ApplyDate",
       "ExecutionStartDate"
      ]
     }
    ],
    "Conditions": [
     {
      "Value": "CaseType",
      "Label": "案件分類",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "案件分類類別",
        "Type": "String",
        "Options": [
         {
          "Value": "101",
          "Label": "門診西醫"
         },
         {
          "Value": "104",
          "Label": "住診"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "CaseTypeOptions",
        "Label": "案件分類選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/{Category}",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "Level",
      "Label": "層級別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "LevelOptions",
        "Label": "層級別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/QRD/003",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "HospCode",
      "Label": "醫事類別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "醫事類別類型",
        "Type": "String",
        "Options": [
         {
          "Value": "011",
          "Label": "門診"
         },
         {
          "Value": "012",
          "Label": "住診"
         },
         {
          "Value": "013",
          "Label": "其他"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "HospCodeOptions",
        "Label": "醫事類別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/{Category}",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "OrderType",
      "Label": "醫令類別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "OrderTypeOptions",
        "Label": "醫令類別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/132",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "RelMode",
      "Label": "處方調劑方式",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "RelModeOptions",
        "Label": "處方調劑方式選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/131",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "SubMainDiagnosisCode",
      "Label": "主次診斷代碼",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "FilterOptions",
        "Label": "比對欄位",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "ICD9CM_CODE",
          "Label": "主診斷代碼"
         },
         {
          "Value": "ICD9CM_CODE1",
          "Label": "次診斷代碼(一)"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "PartCode",
      "Label": "部分負擔代碼",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "TreatmentArea",
      "Label": "診療之部位",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         },
         {
          "Value": "04",
          "Label": "群組"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "GroupOption",
        "Label": "群組",
        "Type": "String",
        "Options": [
         {
          "Value": "TreatmentG01",
          "Label": "群組一"
         },
         {
          "Value": "TreatmentG02",
          "Label": "群組二"
         },
         {
          "Value": "TreatmentG03",
          "Label": "群組三"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "04"
        }
       }
      ]
     },
     {
      "Value": "Age",
      "Label": "年齡",
      "Fields": [
       {
        "Value": "ReferenceDates",
        "Label": "基準日（可排序）",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "01",
          "Label": "就醫日期"
         },
         {
          "Value": "02",
          "Label": "醫令執行起日"
         },
         {
          "Value": "03",
          "Label": "治療結束日"
         },
         {
          "Value": "04",
          "Label": "住院日期"
         },
         {
          "Value": "05",
          "Label": "出院日期"
         },
         {
          "Value": "06",
          "Label": "調劑日期"
         },
         {
          "Value": "07",
          "Label": "物理治療起日"
         },
         {
          "Value": "08",
          "Label": "檢驗日期"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "OperatorMin",
        "Label": "下限運算子",
        "Type": "String",
        "Options": [
         {
          "Value": ">",
          "Label": "大於"
         },
         {
          "Value": ">=",
          "Label": "大於等於"
         }
        ]
       },
       {
        "Value": "Min",
        "Label": "下限",
        "Type": "Number",
        "Placeholder": "不填表示無下限"
       },
       {
        "Value": "OperatorMax",
        "Label": "上限運算子",
        "Type": "String",
        "Options": [
         {
          "Value": "<",
          "Label": "小於"
         },
         {
          "Value": "<=",
          "Label": "小於等於"
         }
        ]
       },
       {
        "Value": "Max",
        "Label": "上限",
        "Type": "Number",
        "Placeholder": "不填表示無上限"
       },
       {
        "Value": "Unit",
        "Label": "單位",
        "Type": "String",
        "Options": [
         {
          "Value": "Y",
          "Label": "歲"
         },
         {
          "Value": "M",
          "Label": "月"
         },
         {
          "Value": "D",
          "Label": "日"
         }
        ],
        "Default": "Y",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "AssociatedItems",
      "Label": "清單下併報項目",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "項目代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "TreatmentItems",
      "Label": "核定治療項目",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "FilterOptions",
        "Label": "比對欄位",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "01",
          "Label": "特殊治療項目代號（一）"
         },
         {
          "Value": "02",
          "Label": "特殊治療項目代號（二）"
         },
         {
          "Value": "03",
          "Label": "特殊治療項目代號（三）"
         },
         {
          "Value": "04",
          "Label": "特殊治療項目代號（四）"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "Department",
      "Label": "就醫科別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "DepartmentOptions",
        "Label": "就醫科別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PXX/997",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "Robotic",
      "Label": "僅機械手臂輔助手術",
      "Fields": [
       {
        "Value": "RoboticOption",
        "Label": "是否限定",
        "Type": "String",
        "Options": [
         {
          "Value": "Y",
          "Label": "是"
         },
         {
          "Value": "N",
          "Label": "否"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     }
    ]
   },
   {
    "Value": "205",
    "Label": "限專任醫師處方",
    "MainFields": [
     {
      "Value": "SpecialistCodes",
      "Label": "專科醫師別",
      "Type": "String",
      "Options": [
       {
        "Value": "1",
        "Label": "無限制"
       },
       {
        "Value": "2",
        "Label": "除山地離島地區之外基層院所"
       }
      ],
      "Constraints": [
       {
        "Type": "Required",
        "Message": "必填欄位"
       }
      ]
     }
    ],
    "ReferenceFields": [
     {
      "Value": "ReferenceDates",
      "Label": "參考日期",
      "Type": "StringArray",
      "Options": [
       {
        "Value": "ApplyDate",
        "Label": "就醫日期"
       },
       {
        "Value": "ExecutionStartDate",
        "Label": "醫令執行起日"
       },
       {
        "Value": "TreatmentEndDate",
        "Label": "治療結束日"
       },
       {
        "Value": "AdmissionDate",
        "Label": "住院日期"
       },
       {
        "Value": "DischargeDate",
        "Label": "出院日期"
       },
       {
        "Value": "DispensingDate",
        "Label": "調劑日期"
       },
       {
        "Value": "PhysicalTherapyStartDate",
        "Label": "物理治療起日"
       },
       {
        "Value": "ExaminationDate",
        "Label": "檢驗日期"
       }
      ],
      "Default": [
       "ApplyDate",
       "ExecutionStartDate"
      ]
     },
     {
      "Value": "DoctorTypes",
      "Label": "醫師角色",
      "Type": "StringArray",
      "Options": [
       {
        "Value": "01",
        "Label": "執行醫師"
       },
       {
        "Value": "02",
        "Label": "處方醫師"
       },
       {
        "Value": "03",
        "Label": "遠距"
       }
      ],
      "Default": [
       "01",
       "02",
       "03"
      ]
     }
    ],
    "Conditions": [
     {
      "Value": "CaseType",
      "Label": "案件分類",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "案件分類類別",
        "Type": "String",
        "Options": [
         {
          "Value": "101",
          "Label": "門診西醫"
         },
         {
          "Value": "104",
          "Label": "住診"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "CaseTypeOptions",
        "Label": "案件分類選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/{Category}",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "Level",
      "Label": "層級別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "LevelOptions",
        "Label": "層級別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/QRD/003",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "HospCode",
      "Label": "醫事類別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "醫事類別類型",
        "Type": "String",
        "Options": [
         {
          "Value": "011",
          "Label": "門診"
         },
         {
          "Value": "012",
          "Label": "住診"
         },
         {
          "Value": "013",
          "Label": "其他"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "HospCodeOptions",
        "Label": "醫事類別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/{Category}",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "OrderType",
      "Label": "醫令類別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "OrderTypeOptions",
        "Label": "醫令類別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/132",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "RelMode",
      "Label": "處方調劑方式",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "RelModeOptions",
        "Label": "處方調劑方式選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/131",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "SubMainDiagnosisCode",
      "Label": "主次診斷代碼",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "FilterOptions",
        "Label": "比對欄位",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "ICD9CM_CODE",
          "Label": "主診斷代碼"
         },
         {
          "Value": "ICD9CM_CODE1",
          "Label": "次診斷代碼(一)"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "PartCode",
      "Label": "部分負擔代碼",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "TreatmentArea",
      "Label": "診療之部位",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         },
         {
          "Value": "04",
          "Label": "群組"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "GroupOption",
        "Label": "群組",
        "Type": "String",
        "Options": [
         {
          "Value": "TreatmentG01",
          "Label": "群組一"
         },
         {
          "Value": "TreatmentG02",
          "Label": "群組二"
         },
         {
          "Value": "TreatmentG03",
          "Label": "群組三"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "04"
        }
       }
      ]
     },
     {
      "Value": "Age",
      "Label": "年齡",
      "Fields": [
       {
        "Value": "ReferenceDates",
        "Label": "基準日（可排序）",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "01",
          "Label": "就醫日期"
         },
         {
          "Value": "02",
          "Label": "醫令執行起日"
         },
         {
          "Value": "03",
          "Label": "治療結束日"
         },
         {
          "Value": "04",
          "Label": "住院日期"
         },
         {
          "Value": "05",
          "Label": "出院日期"
         },
         {
          "Value": "06",
          "Label": "調劑日期"
         },
         {
          "Value": "07",
          "Label": "物理治療起日"
         },
         {
          "Value": "08",
          "Label": "檢驗日期"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "OperatorMin",
        "Label": "下限運算子",
        "Type": "String",
        "Options": [
         {
          "Value": ">",
          "Label": "大於"
         },
         {
          "Value": ">=",
          "Label": "大於等於"
         }
        ]
       },
       {
        "Value": "Min",
        "Label": "下限",
        "Type": "Number",
        "Placeholder": "不填表示無下限"
       },
       {
        "Value": "OperatorMax",
        "Label": "上限運算子",
        "Type": "String",
        "Options": [
         {
          "Value": "<",
          "Label": "小於"
         },
         {
          "Value": "<=",
          "Label": "小於等於"
         }
        ]
       },
       {
        "Value": "Max",
        "Label": "上限",
        "Type": "Number",
        "Placeholder": "不填表示無上限"
       },
       {
        "Value": "Unit",
        "Label": "單位",
        "Type": "String",
        "Options": [
         {
          "Value": "Y",
          "Label": "歲"
         },
         {
          "Value": "M",
          "Label": "月"
         },
         {
          "Value": "D",
          "Label": "日"
         }
        ],
        "Default": "Y",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "AssociatedItems",
      "Label": "清單下併報項目",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "項目代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "TreatmentItems",
      "Label": "核定治療項目",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "FilterOptions",
        "Label": "比對欄位",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "01",
          "Label": "特殊治療項目代號（一）"
         },
         {
          "Value": "02",
          "Label": "特殊治療項目代號（二）"
         },
         {
          "Value": "03",
          "Label": "特殊治療項目代號（三）"
         },
         {
          "Value": "04",
          "Label": "特殊治療項目代號（四）"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "Department",
      "Label": "就醫科別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "DepartmentOptions",
        "Label": "就醫科別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PXX/997",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "Robotic",
      "Label": "僅機械手臂輔助手術",
      "Fields": [
       {
        "Value": "RoboticOption",
        "Label": "是否限定",
        "Type": "String",
        "Options": [
         {
          "Value": "Y",
          "Label": "是"
         },
         {
          "Value": "N",
          "Label": "否"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     }
    ]
   },
   {
    "Value": "206",
    "Label": "限專任醫師執行",
    "MainFields": [
     {
      "Value": "SpecialistCodes",
      "Label": "專科醫師別",
      "Type": "String",
      "Options": [
       {
        "Value": "1",
        "Label": "無限制"
       },
       {
        "Value": "2",
        "Label": "除山地離島地區之外基層院所"
       }
      ],
      "Constraints": [
       {
        "Type": "Required",
        "Message": "必填欄位"
       }
      ]
     }
    ],
    "ReferenceFields": [
     {
      "Value": "ReferenceDates",
      "Label": "參考日期",
      "Type": "StringArray",
      "Options": [
       {
        "Value": "ApplyDate",
        "Label": "就醫日期"
       },
       {
        "Value": "ExecutionStartDate",
        "Label": "醫令執行起日"
       },
       {
        "Value": "TreatmentEndDate",
        "Label": "治療結束日"
       },
       {
        "Value": "AdmissionDate",
        "Label": "住院日期"
       },
       {
        "Value": "DischargeDate",
        "Label": "出院日期"
       },
       {
        "Value": "DispensingDate",
        "Label": "調劑日期"
       },
       {
        "Value": "PhysicalTherapyStartDate",
        "Label": "物理治療起日"
       },
       {
        "Value": "ExaminationDate",
        "Label": "檢驗日期"
       }
      ],
      "Default": [
       "ApplyDate",
       "ExecutionStartDate"
      ]
     },
     {
      "Value": "DoctorTypes",
      "Label": "醫師角色",
      "Type": "StringArray",
      "Options": [
       {
        "Value": "01",
        "Label": "執行醫師"
       },
       {
        "Value": "02",
        "Label": "處方醫師"
       },
       {
        "Value": "03",
        "Label": "遠距"
       }
      ],
      "Default": [
       "01",
       "02",
       "03"
      ]
     }
    ],
    "Conditions": [
     {
      "Value": "CaseType",
      "Label": "案件分類",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "案件分類類別",
        "Type": "String",
        "Options": [
         {
          "Value": "101",
          "Label": "門診西醫"
         },
         {
          "Value": "104",
          "Label": "住診"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "CaseTypeOptions",
        "Label": "案件分類選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/{Category}",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "Level",
      "Label": "層級別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "LevelOptions",
        "Label": "層級別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/QRD/003",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "HospCode",
      "Label": "醫事類別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "醫事類別類型",
        "Type": "String",
        "Options": [
         {
          "Value": "011",
          "Label": "門診"
         },
         {
          "Value": "012",
          "Label": "住診"
         },
         {
          "Value": "013",
          "Label": "其他"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "HospCodeOptions",
        "Label": "醫事類別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/{Category}",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "OrderType",
      "Label": "醫令類別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "OrderTypeOptions",
        "Label": "醫令類別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/132",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "RelMode",
      "Label": "處方調劑方式",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "RelModeOptions",
        "Label": "處方調劑方式選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/131",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "SubMainDiagnosisCode",
      "Label": "主次診斷代碼",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "FilterOptions",
        "Label": "比對欄位",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "ICD9CM_CODE",
          "Label": "主診斷代碼"
         },
         {
          "Value": "ICD9CM_CODE1",
          "Label": "次診斷代碼(一)"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "PartCode",
      "Label": "部分負擔代碼",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "TreatmentArea",
      "Label": "診療之部位",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         },
         {
          "Value": "04",
          "Label": "群組"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "GroupOption",
        "Label": "群組",
        "Type": "String",
        "Options": [
         {
          "Value": "TreatmentG01",
          "Label": "群組一"
         },
         {
          "Value": "TreatmentG02",
          "Label": "群組二"
         },
         {
          "Value": "TreatmentG03",
          "Label": "群組三"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "04"
        }
       }
      ]
     },
     {
      "Value": "Age",
      "Label": "年齡",
      "Fields": [
       {
        "Value": "ReferenceDates",
        "Label": "基準日（可排序）",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "01",
          "Label": "就醫日期"
         },
         {
          "Value": "02",
          "Label": "醫令執行起日"
         },
         {
          "Value": "03",
          "Label": "治療結束日"
         },
         {
          "Value": "04",
          "Label": "住院日期"
         },
         {
          "Value": "05",
          "Label": "出院日期"
         },
         {
          "Value": "06",
          "Label": "調劑日期"
         },
         {
          "Value": "07",
          "Label": "物理治療起日"
         },
         {
          "Value": "08",
          "Label": "檢驗日期"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "OperatorMin",
        "Label": "下限運算子",
        "Type": "String",
        "Options": [
         {
          "Value": ">",
          "Label": "大於"
         },
         {
          "Value": ">=",
          "Label": "大於等於"
         }
        ]
       },
       {
        "Value": "Min",
        "Label": "下限",
        "Type": "Number",
        "Placeholder": "不填表示無下限"
       },
       {
        "Value": "OperatorMax",
        "Label": "上限運算子",
        "Type": "String",
        "Options": [
         {
          "Value": "<",
          "Label": "小於"
         },
         {
          "Value": "<=",
          "Label": "小於等於"
         }
        ]
       },
       {
        "Value": "Max",
        "Label": "上限",
        "Type": "Number",
        "Placeholder": "不填表示無上限"
       },
       {
        "Value": "Unit",
        "Label": "單位",
        "Type": "String",
        "Options": [
         {
          "Value": "Y",
          "Label": "歲"
         },
         {
          "Value": "M",
          "Label": "月"
         },
         {
          "Value": "D",
          "Label": "日"
         }
        ],
        "Default": "Y",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "AssociatedItems",
      "Label": "清單下併報項目",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "項目代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "TreatmentItems",
      "Label": "核定治療項目",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "FilterOptions",
        "Label": "比對欄位",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "01",
          "Label": "特殊治療項目代號（一）"
         },
         {
          "Value": "02",
          "Label": "特殊治療項目代號（二）"
         },
         {
          "Value": "03",
          "Label": "特殊治療項目代號（三）"
         },
         {
          "Value": "04",
          "Label": "特殊治療項目代號（四）"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "Department",
      "Label": "就醫科別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "DepartmentOptions",
        "Label": "就醫科別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PXX/997",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "Robotic",
      "Label": "僅機械手臂輔助手術",
      "Fields": [
       {
        "Value": "RoboticOption",
        "Label": "是否限定",
        "Type": "String",
        "Options": [
         {
          "Value": "Y",
          "Label": "是"
         },
         {
          "Value": "N",
          "Label": "否"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     }
    ]
   },
   {
    "Value": "301",
    "Label": "適用性別",
    "MainFields": [
     {
      "Value": "GenderCode",
      "Label": "性別",
      "Type": "String",
      "Options": [
       {
        "Value": "1",
        "Label": "男"
       },
       {
        "Value": "2",
        "Label": "女"
       },
       {
        "Value": "3",
        "Label": "其他"
       }
      ],
      "Constraints": [
       {
        "Type": "Required",
        "Message": "必填欄位"
       }
      ]
     }
    ],
    "Conditions": [
     {
      "Value": "CaseType",
      "Label": "案件分類",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "案件分類類別",
        "Type": "String",
        "Options": [
         {
          "Value": "101",
          "Label": "門診西醫"
         },
         {
          "Value": "104",
          "Label": "住診"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "CaseTypeOptions",
        "Label": "案件分類選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/{Category}",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "Level",
      "Label": "層級別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "LevelOptions",
        "Label": "層級別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/QRD/003",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "HospCode",
      "Label": "醫事類別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "醫事類別類型",
        "Type": "String",
        "Options": [
         {
          "Value": "011",
          "Label": "門診"
         },
         {
          "Value": "012",
          "Label": "住診"
         },
         {
          "Value": "013",
          "Label": "其他"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "HospCodeOptions",
        "Label": "醫事類別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/{Category}",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "OrderType",
      "Label": "醫令類別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "OrderTypeOptions",
        "Label": "醫令類別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/132",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "RelMode",
      "Label": "處方調劑方式",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "RelModeOptions",
        "Label": "處方調劑方式選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/131",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "SubMainDiagnosisCode",
      "Label": "主次診斷代碼",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "FilterOptions",
        "Label": "比對欄位",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "ICD9CM_CODE",
          "Label": "主診斷代碼"
         },
         {
          "Value": "ICD9CM_CODE1",
          "Label": "次診斷代碼(一)"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "PartCode",
      "Label": "部分負擔代碼",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "TreatmentArea",
      "Label": "診療之部位",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         },
         {
          "Value": "04",
          "Label": "群組"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "GroupOption",
        "Label": "群組",
        "Type": "String",
        "Options": [
         {
          "Value": "TreatmentG01",
          "Label": "群組一"
         },
         {
          "Value": "TreatmentG02",
          "Label": "群組二"
         },
         {
          "Value": "TreatmentG03",
          "Label": "群組三"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "04"
        }
       }
      ]
     },
     {
      "Value": "Age",
      "Label": "年齡",
      "Fields": [
       {
        "Value": "ReferenceDates",
        "Label": "基準日（可排序）",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "01",
          "Label": "就醫日期"
         },
         {
          "Value": "02",
          "Label": "醫令執行起日"
         },
         {
          "Value": "03",
          "Label": "治療結束日"
         },
         {
          "Value": "04",
          "Label": "住院日期"
         },
         {
          "Value": "05",
          "Label": "出院日期"
         },
         {
          "Value": "06",
          "Label": "調劑日期"
         },
         {
          "Value": "07",
          "Label": "物理治療起日"
         },
         {
          "Value": "08",
          "Label": "檢驗日期"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "OperatorMin",
        "Label": "下限運算子",
        "Type": "String",
        "Options": [
         {
          "Value": ">",
          "Label": "大於"
         },
         {
          "Value": ">=",
          "Label": "大於等於"
         }
        ]
       },
       {
        "Value": "Min",
        "Label": "下限",
        "Type": "Number",
        "Placeholder": "不填表示無下限"
       },
       {
        "Value": "OperatorMax",
        "Label": "上限運算子",
        "Type": "String",
        "Options": [
         {
          "Value": "<",
          "Label": "小於"
         },
         {
          "Value": "<=",
          "Label": "小於等於"
         }
        ]
       },
       {
        "Value": "Max",
        "Label": "上限",
        "Type": "Number",
        "Placeholder": "不填表示無上限"
       },
       {
        "Value": "Unit",
        "Label": "單位",
        "Type": "String",
        "Options": [
         {
          "Value": "Y",
          "Label": "歲"
         },
         {
          "Value": "M",
          "Label": "月"
         },
         {
          "Value": "D",
          "Label": "日"
         }
        ],
        "Default": "Y",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "AssociatedItems",
      "Label": "清單下併報項目",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "項目代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "TreatmentItems",
      "Label": "核定治療項目",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "FilterOptions",
        "Label": "比對欄位",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "01",
          "Label": "特殊治療項目代號（一）"
         },
         {
          "Value": "02",
          "Label": "特殊治療項目代號（二）"
         },
         {
          "Value": "03",
          "Label": "特殊治療項目代號（三）"
         },
         {
          "Value": "04",
          "Label": "特殊治療項目代號（四）"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "Department",
      "Label": "就醫科別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "DepartmentOptions",
        "Label": "就醫科別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PXX/997",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "Robotic",
      "Label": "僅機械手臂輔助手術",
      "Fields": [
       {
        "Value": "RoboticOption",
        "Label": "是否限定",
        "Type": "String",
        "Options": [
         {
          "Value": "Y",
          "Label": "是"
         },
         {
          "Value": "N",
          "Label": "否"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     }
    ]
   },
   {
    "Value": "302",
    "Label": "適用年齡",
    "MainFields": [
     {
      "Value": "MinOp",
      "Label": "下限符號",
      "Type": "String",
      "Options": [
       {
        "Value": ">=",
        "Label": "大於等於"
       },
       {
        "Value": ">",
        "Label": "大於"
       },
       {
        "Value": "==",
        "Label": "等於"
       }
      ],
      "Constraints": [
       {
        "Type": "Required",
        "Message": "必填欄位"
       }
      ]
     },
     {
      "Value": "Min",
      "Label": "最小值",
      "Type": "Number",
      "Constraints": [
       {
        "Type": "Required",
        "Message": "必填欄位"
       },
       {
        "Type": "Min",
        "Message": "最小值不得小於 0",
        "Value": 0
       }
      ]
     },
     {
      "Value": "MaxOp",
      "Label": "上限符號",
      "Type": "String",
      "Options": [
       {
        "Value": "<=",
        "Label": "小於等於"
       },
       {
        "Value": "<",
        "Label": "小於"
       }
      ]
     },
     {
      "Value": "Max",
      "Label": "最大值",
      "Type": "Number",
      "Placeholder": "不填表示無上限",
      "Constraints": [
       {
        "Type": "Min",
        "Message": "最大值不得小於 0",
        "Value": 0
       },
       {
        "Type": "CompareField",
        "Message": "最大值須大於最小值",
        "Field": "Min",
        "Op": ">"
       }
      ]
     },
     {
      "Value": "Unit",
      "Label": "單位",
      "Type": "String",
      "Options": [
       {
        "Value": "Y",
        "Label": "歲"
       },
       {
        "Value": "M",
        "Label": "月"
       },
       {
        "Value": "D",
        "Label": "日"
       }
      ],
      "Default": "Y",
      "Constraints": [
       {
        "Type": "Required",
        "Message": "必填欄位"
       }
      ]
     }
    ],
    "ReferenceFields": [
     {
      "Value": "ReferenceDates",
      "Label": "參考日期",
      "Type": "StringArray",
      "Options": [
       {
        "Value": "ApplyDate",
        "Label": "就醫日期"
       },
       {
        "Value": "ExecutionStartDate",
        "Label": "醫令執行起日"
       },
       {
        "Value": "TreatmentEndDate",
        "Label": "治療結束日"
       },
       {
        "Value": "AdmissionDate",
        "Label": "住院日期"
       },
       {
        "Value": "DischargeDate",
        "Label": "出院日期"
       },
       {
        "Value": "DispensingDate",
        "Label": "調劑日期"
       },
       {
        "Value": "PhysicalTherapyStartDate",
        "Label": "物理治療起日"
       },
       {
        "Value": "ExaminationDate",
        "Label": "檢驗日期"
       }
      ],
      "Default": [
       "ApplyDate",
       "ExecutionStartDate"
      ]
     },
     {
      "Value": "AgeReference",
      "Label": "出生日期來源",
      "Type": "StringArray",
      "Options": [
       {
        "Value": "birthday",
        "Label": "出生日期"
       },
       {
        "Value": "child_birthday",
        "Label": "新生兒出生日"
       }
      ],
      "Default": [
       "birthday",
       "child_birthday"
      ]
     }
    ],
    "Conditions": [
     {
      "Value": "CaseType",
      "Label": "案件分類",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "案件分類類別",
        "Type": "String",
        "Options": [
         {
          "Value": "101",
          "Label": "門診西醫"
         },
         {
          "Value": "104",
          "Label": "住診"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "CaseTypeOptions",
        "Label": "案件分類選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/{Category}",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "Level",
      "Label": "層級別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "LevelOptions",
        "Label": "層級別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/QRD/003",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "HospCode",
      "Label": "醫事類別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "醫事類別類型",
        "Type": "String",
        "Options": [
         {
          "Value": "011",
          "Label": "門診"
         },
         {
          "Value": "012",
          "Label": "住診"
         },
         {
          "Value": "013",
          "Label": "其他"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "HospCodeOptions",
        "Label": "醫事類別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/{Category}",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "OrderType",
      "Label": "醫令類別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "OrderTypeOptions",
        "Label": "醫令類別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/132",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "RelMode",
      "Label": "處方調劑方式",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "RelModeOptions",
        "Label": "處方調劑方式選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/131",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "SubMainDiagnosisCode",
      "Label": "主次診斷代碼",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "FilterOptions",
        "Label": "比對欄位",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "ICD9CM_CODE",
          "Label": "主診斷代碼"
         },
         {
          "Value": "ICD9CM_CODE1",
          "Label": "次診斷代碼(一)"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "PartCode",
      "Label": "部分負擔代碼",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "TreatmentArea",
      "Label": "診療之部位",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         },
         {
          "Value": "04",
          "Label": "群組"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "GroupOption",
        "Label": "群組",
        "Type": "String",
        "Options": [
         {
          "Value": "TreatmentG01",
          "Label": "群組一"
         },
         {
          "Value": "TreatmentG02",
          "Label": "群組二"
         },
         {
          "Value": "TreatmentG03",
          "Label": "群組三"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "04"
        }
       }
      ]
     },
     {
      "Value": "Age",
      "Label": "年齡",
      "Fields": [
       {
        "Value": "ReferenceDates",
        "Label": "基準日（可排序）",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "01",
          "Label": "就醫日期"
         },
         {
          "Value": "02",
          "Label": "醫令執行起日"
         },
         {
          "Value": "03",
          "Label": "治療結束日"
         },
         {
          "Value": "04",
          "Label": "住院日期"
         },
         {
          "Value": "05",
          "Label": "出院日期"
         },
         {
          "Value": "06",
          "Label": "調劑日期"
         },
         {
          "Value": "07",
          "Label": "物理治療起日"
         },
         {
          "Value": "08",
          "Label": "檢驗日期"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "OperatorMin",
        "Label": "下限運算子",
        "Type": "String",
        "Options": [
         {
          "Value": ">",
          "Label": "大於"
         },
         {
          "Value": ">=",
          "Label": "大於等於"
         }
        ]
       },
       {
        "Value": "Min",
        "Label": "下限",
        "Type": "Number",
        "Placeholder": "不填表示無下限"
       },
       {
        "Value": "OperatorMax",
        "Label": "上限運算子",
        "Type": "String",
        "Options": [
         {
          "Value": "<",
          "Label": "小於"
         },
         {
          "Value": "<=",
          "Label": "小於等於"
         }
        ]
       },
       {
        "Value": "Max",
        "Label": "上限",
        "Type": "Number",
        "Placeholder": "不填表示無上限"
       },
       {
        "Value": "Unit",
        "Label": "單位",
        "Type": "String",
        "Options": [
         {
          "Value": "Y",
          "Label": "歲"
         },
         {
          "Value": "M",
          "Label": "月"
         },
         {
          "Value": "D",
          "Label": "日"
         }
        ],
        "Default": "Y",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "AssociatedItems",
      "Label": "清單下併報項目",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "項目代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "TreatmentItems",
      "Label": "核定治療項目",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "FilterOptions",
        "Label": "比對欄位",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "01",
          "Label": "特殊治療項目代號（一）"
         },
         {
          "Value": "02",
          "Label": "特殊治療項目代號（二）"
         },
         {
          "Value": "03",
          "Label": "特殊治療項目代號（三）"
         },
         {
          "Value": "04",
          "Label": "特殊治療項目代號（四）"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "Department",
      "Label": "就醫科別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "DepartmentOptions",
        "Label": "就醫科別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PXX/997",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "Robotic",
      "Label": "僅機械手臂輔助手術",
      "Fields": [
       {
        "Value": "RoboticOption",
        "Label": "是否限定",
        "Type": "String",
        "Options": [
         {
          "Value": "Y",
          "Label": "是"
         },
         {
          "Value": "N",
          "Label": "否"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     }
    ]
   },
   {
    "Value": "303",
    "Label": "限制申報頻率",
    "MainFields": [
     {
      "Value": "FrequencyType",
      "Label": "頻率類型",
      "Type": "String",
      "Options": [
       {
        "Value": "01",
        "Label": "每日"
       },
       {
        "Value": "02",
        "Label": "每月"
       },
       {
        "Value": "03",
        "Label": "每半年"
       },
       {
        "Value": "04",
        "Label": "每年"
       },
       {
        "Value": "05",
        "Label": "每週最多"
       },
       {
        "Value": "06",
        "Label": "每_週限制次數"
       },
       {
        "Value": "07",
        "Label": "特定時間內限申報次數"
       },
       {
        "Value": "08",
        "Label": "特定時間間隔次數"
       },
       {
        "Value": "09",
        "Label": "同部位限申報次數"
       }
      ],
      "Constraints": [
       {
        "Type": "Required",
        "Message": "必填欄位"
       }
      ]
     },
     {
      "Value": "Weeks",
      "Label": "週數",
      "Type": "Number",
      "PrefixText": "每",
      "SuffixText": "週",
      "Constraints": [
       {
        "Type": "Min",
        "Message": "不得小於 0",
        "Value": 0
       }
      ]
     },
     {
      "Value": "Period",
      "Label": "期間長度",
      "Type": "Number",
      "Constraints": [
       {
        "Type": "Min",
        "Message": "不得小於 0",
        "Value": 0
       }
      ]
     },
     {
      "Value": "PeriodUnit",
      "Label": "期間單位",
      "Type": "String",
      "Options": [
       {
        "Value": "D",
        "Label": "日"
       },
       {
        "Value": "M",
        "Label": "月"
       },
       {
        "Value": "Y",
        "Label": "年"
       }
      ],
      "Placeholder": "單位"
     },
     {
      "Value": "Max",
      "Label": "次數上限",
      "Type": "Number",
      "PrefixText": "最多",
      "SuffixText": "次",
      "Constraints": [
       {
        "Type": "Min",
        "Message": "不得小於 0",
        "Value": 0
       }
      ]
     },
     {
      "Value": "IntervalValue",
      "Label": "間隔長度",
      "Type": "Number",
      "PrefixText": "且間隔",
      "Constraints": [
       {
        "Type": "Min",
        "Message": "不得小於 0",
        "Value": 0
       }
      ]
     },
     {
      "Value": "IntervalUnit",
      "Label": "間隔單位",
      "Type": "String",
      "Options": [
       {
        "Value": "D",
        "Label": "日"
       },
       {
        "Value": "M",
        "Label": "月"
       },
       {
        "Value": "Y",
        "Label": "年"
       }
      ],
      "Placeholder": "單位"
     }
    ],
    "ReferenceFields": [
     {
      "Value": "ReferenceDates",
      "Label": "參考日期",
      "Type": "StringArray",
      "Options": [
       {
        "Value": "ApplyDate",
        "Label": "就醫日期"
       },
       {
        "Value": "ExecutionStartDate",
        "Label": "醫令執行起日"
       },
       {
        "Value": "TreatmentEndDate",
        "Label": "治療結束日"
       },
       {
        "Value": "AdmissionDate",
        "Label": "住院日期"
       },
       {
        "Value": "DischargeDate",
        "Label": "出院日期"
       },
       {
        "Value": "DispensingDate",
        "Label": "調劑日期"
       },
       {
        "Value": "PhysicalTherapyStartDate",
        "Label": "物理治療起日"
       },
       {
        "Value": "ExaminationDate",
        "Label": "檢驗日期"
       }
      ],
      "Default": [
       "ApplyDate",
       "ExecutionStartDate"
      ]
     }
    ],
    "Conditions": [
     {
      "Value": "CaseType",
      "Label": "案件分類",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "案件分類類別",
        "Type": "String",
        "Options": [
         {
          "Value": "101",
          "Label": "門診西醫"
         },
         {
          "Value": "104",
          "Label": "住診"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "CaseTypeOptions",
        "Label": "案件分類選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/{Category}",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "Level",
      "Label": "層級別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "LevelOptions",
        "Label": "層級別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/QRD/003",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "HospCode",
      "Label": "醫事類別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "醫事類別類型",
        "Type": "String",
        "Options": [
         {
          "Value": "011",
          "Label": "門診"
         },
         {
          "Value": "012",
          "Label": "住診"
         },
         {
          "Value": "013",
          "Label": "其他"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "HospCodeOptions",
        "Label": "醫事類別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/{Category}",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "OrderType",
      "Label": "醫令類別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "OrderTypeOptions",
        "Label": "醫令類別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/132",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "RelMode",
      "Label": "處方調劑方式",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "RelModeOptions",
        "Label": "處方調劑方式選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/131",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "SubMainDiagnosisCode",
      "Label": "主次診斷代碼",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "FilterOptions",
        "Label": "比對欄位",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "ICD9CM_CODE",
          "Label": "主診斷代碼"
         },
         {
          "Value": "ICD9CM_CODE1",
          "Label": "次診斷代碼(一)"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "PartCode",
      "Label": "部分負擔代碼",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "TreatmentArea",
      "Label": "診療之部位",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         },
         {
          "Value": "04",
          "Label": "群組"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "GroupOption",
        "Label": "群組",
        "Type": "String",
        "Options": [
         {
          "Value": "TreatmentG01",
          "Label": "群組一"
         },
         {
          "Value": "TreatmentG02",
          "Label": "群組二"
         },
         {
          "Value": "TreatmentG03",
          "Label": "群組三"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "04"
        }
       }
      ]
     },
     {
      "Value": "Age",
      "Label": "年齡",
      "Fields": [
       {
        "Value": "ReferenceDates",
        "Label": "基準日（可排序）",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "01",
          "Label": "就醫日期"
         },
         {
          "Value": "02",
          "Label": "醫令執行起日"
         },
         {
          "Value": "03",
          "Label": "治療結束日"
         },
         {
          "Value": "04",
          "Label": "住院日期"
         },
         {
          "Value": "05",
          "Label": "出院日期"
         },
         {
          "Value": "06",
          "Label": "調劑日期"
         },
         {
          "Value": "07",
          "Label": "物理治療起日"
         },
         {
          "Value": "08",
          "Label": "檢驗日期"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "OperatorMin",
        "Label": "下限運算子",
        "Type": "String",
        "Options": [
         {
          "Value": ">",
          "Label": "大於"
         },
         {
          "Value": ">=",
          "Label": "大於等於"
         }
        ]
       },
       {
        "Value": "Min",
        "Label": "下限",
        "Type": "Number",
        "Placeholder": "不填表示無下限"
       },
       {
        "Value": "OperatorMax",
        "Label": "上限運算子",
        "Type": "String",
        "Options": [
         {
          "Value": "<",
          "Label": "小於"
         },
         {
          "Value": "<=",
          "Label": "小於等於"
         }
        ]
       },
       {
        "Value": "Max",
        "Label": "上限",
        "Type": "Number",
        "Placeholder": "不填表示無上限"
       },
       {
        "Value": "Unit",
        "Label": "單位",
        "Type": "String",
        "Options": [
         {
          "Value": "Y",
          "Label": "歲"
         },
         {
          "Value": "M",
          "Label": "月"
         },
         {
          "Value": "D",
          "Label": "日"
         }
        ],
        "Default": "Y",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "AssociatedItems",
      "Label": "清單下併報項目",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "項目代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "TreatmentItems",
      "Label": "核定治療項目",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "FilterOptions",
        "Label": "比對欄位",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "01",
          "Label": "特殊治療項目代號（一）"
         },
         {
          "Value": "02",
          "Label": "特殊治療項目代號（二）"
         },
         {
          "Value": "03",
          "Label": "特殊治療項目代號（三）"
         },
         {
          "Value": "04",
          "Label": "特殊治療項目代號（四）"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "Department",
      "Label": "就醫科別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "DepartmentOptions",
        "Label": "就醫科別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PXX/997",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "Robotic",
      "Label": "僅機械手臂輔助手術",
      "Fields": [
       {
        "Value": "RoboticOption",
        "Label": "是否限定",
        "Type": "String",
        "Options": [
         {
          "Value": "Y",
          "Label": "是"
         },
         {
          "Value": "N",
          "Label": "否"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     }
    ]
   },
   {
    "Value": "304",
    "Label": "限制申報次數",
    "MainFields": [
     {
      "Value": "CountLimitType",
      "Label": "次數限制類型",
      "Type": "String",
      "Options": [
       {
        "Value": "01",
        "Label": "一生限申報次數"
       },
       {
        "Value": "02",
        "Label": "單次申報上限次數"
       },
       {
        "Value": "03",
        "Label": "申報超過上限次數，以診療項目申報"
       },
       {
        "Value": "04",
        "Label": "特定時間申報超過次數，以診療項目申報"
       },
       {
        "Value": "05",
        "Label": "申報超過次數，超過次數的另以診療項目申報"
       },
       {
        "Value": "06",
        "Label": "看診次數累計超過次數，改以診療項目申報"
       },
       {
        "Value": "07",
        "Label": "特定時間同部位限申報次數"
       },
       {
        "Value": "08",
        "Label": "每次門/住診限制次數"
       },
       {
        "Value": "10",
        "Label": "當次急/住診限制次數"
       },
       {
        "Value": "11",
        "Label": "超過特定時間限申報次數"
       }
      ],
      "Constraints": [
       {
        "Type": "Required",
        "Message": "必填欄位"
       }
      ]
     },
     {
      "Value": "Period",
      "Label": "期間長度",
      "Type": "Number",
      "Constraints": [
       {
        "Type": "Min",
        "Message": "不得小於 0",
        "Value": 0
       }
      ]
     },
     {
      "Value": "PeriodUnit",
      "Label": "期間單位",
      "Type": "String",
      "Options": [
       {
        "Value": "D",
        "Label": "日"
       },
       {
        "Value": "M",
        "Label": "月"
       },
       {
        "Value": "Y",
        "Label": "年"
       }
      ],
      "Placeholder": "單位"
     },
     {
      "Value": "Max",
      "Label": "次數上限",
      "Type": "Number",
      "SuffixText": "次",
      "Constraints": [
       {
        "Type": "Min",
        "Message": "不得小於 0",
        "Value": 0
       }
      ]
     },
     {
      "Value": "OverTimes",
      "Label": "超過次數",
      "Type": "Number",
      "PrefixText": "超過",
      "SuffixText": "次的",
      "Constraints": [
       {
        "Type": "Min",
        "Message": "不得小於 0",
        "Value": 0
       }
      ]
     },
     {
      "Value": "OrderCode",
      "Label": "診療項目",
      "Type": "String",
      "PrefixText": "以診療項目",
      "SuffixText": "申報"
     },
     {
      "Value": "VisitType",
      "Label": "就診類別",
      "Type": "String",
      "Options": [
       {
        "Value": "outpatient",
        "Label": "門診"
       },
       {
        "Value": "emergency",
        "Label": "急診"
       },
       {
        "Value": "inpatient",
        "Label": "住診"
       }
      ]
     },
     {
      "Value": "BloodTransfusionOnce",
      "Label": "輸血限制",
      "Type": "StringArray",
      "Options": [
       {
        "Value": "1",
        "Label": "每次輸血前限申報1次"
       }
      ]
     }
    ],
    "ReferenceFields": [
     {
      "Value": "ReferenceDates",
      "Label": "參考日期",
      "Type": "StringArray",
      "Options": [
       {
        "Value": "ApplyDate",
        "Label": "就醫日期"
       },
       {
        "Value": "ExecutionStartDate",
        "Label": "醫令執行起日"
       },
       {
        "Value": "TreatmentEndDate",
        "Label": "治療結束日"
       },
       {
        "Value": "AdmissionDate",
        "Label": "住院日期"
       },
       {
        "Value": "DischargeDate",
        "Label": "出院日期"
       },
       {
        "Value": "DispensingDate",
        "Label": "調劑日期"
       },
       {
        "Value": "PhysicalTherapyStartDate",
        "Label": "物理治療起日"
       },
       {
        "Value": "ExaminationDate",
        "Label": "檢驗日期"
       }
      ],
      "Default": [
       "ApplyDate",
       "ExecutionStartDate"
      ]
     }
    ],
    "Conditions": [
     {
      "Value": "CaseType",
      "Label": "案件分類",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "案件分類類別",
        "Type": "String",
        "Options": [
         {
          "Value": "101",
          "Label": "門診西醫"
         },
         {
          "Value": "104",
          "Label": "住診"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "CaseTypeOptions",
        "Label": "案件分類選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/{Category}",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "Level",
      "Label": "層級別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "LevelOptions",
        "Label": "層級別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/QRD/003",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "HospCode",
      "Label": "醫事類別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "醫事類別類型",
        "Type": "String",
        "Options": [
         {
          "Value": "011",
          "Label": "門診"
         },
         {
          "Value": "012",
          "Label": "住診"
         },
         {
          "Value": "013",
          "Label": "其他"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "HospCodeOptions",
        "Label": "醫事類別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/{Category}",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "OrderType",
      "Label": "醫令類別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "OrderTypeOptions",
        "Label": "醫令類別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/132",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "RelMode",
      "Label": "處方調劑方式",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "RelModeOptions",
        "Label": "處方調劑方式選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/131",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "SubMainDiagnosisCode",
      "Label": "主次診斷代碼",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "FilterOptions",
        "Label": "比對欄位",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "ICD9CM_CODE",
          "Label": "主診斷代碼"
         },
         {
          "Value": "ICD9CM_CODE1",
          "Label": "次診斷代碼(一)"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "PartCode",
      "Label": "部分負擔代碼",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "TreatmentArea",
      "Label": "診療之部位",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         },
         {
          "Value": "04",
          "Label": "群組"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "GroupOption",
        "Label": "群組",
        "Type": "String",
        "Options": [
         {
          "Value": "TreatmentG01",
          "Label": "群組一"
         },
         {
          "Value": "TreatmentG02",
          "Label": "群組二"
         },
         {
          "Value": "TreatmentG03",
          "Label": "群組三"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "04"
        }
       }
      ]
     },
     {
      "Value": "Age",
      "Label": "年齡",
      "Fields": [
       {
        "Value": "ReferenceDates",
        "Label": "基準日（可排序）",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "01",
          "Label": "就醫日期"
         },
         {
          "Value": "02",
          "Label": "醫令執行起日"
         },
         {
          "Value": "03",
          "Label": "治療結束日"
         },
         {
          "Value": "04",
          "Label": "住院日期"
         },
         {
          "Value": "05",
          "Label": "出院日期"
         },
         {
          "Value": "06",
          "Label": "調劑日期"
         },
         {
          "Value": "07",
          "Label": "物理治療起日"
         },
         {
          "Value": "08",
          "Label": "檢驗日期"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "OperatorMin",
        "Label": "下限運算子",
        "Type": "String",
        "Options": [
         {
          "Value": ">",
          "Label": "大於"
         },
         {
          "Value": ">=",
          "Label": "大於等於"
         }
        ]
       },
       {
        "Value": "Min",
        "Label": "下限",
        "Type": "Number",
        "Placeholder": "不填表示無下限"
       },
       {
        "Value": "OperatorMax",
        "Label": "上限運算子",
        "Type": "String",
        "Options": [
         {
          "Value": "<",
          "Label": "小於"
         },
         {
          "Value": "<=",
          "Label": "小於等於"
         }
        ]
       },
       {
        "Value": "Max",
        "Label": "上限",
        "Type": "Number",
        "Placeholder": "不填表示無上限"
       },
       {
        "Value": "Unit",
        "Label": "單位",
        "Type": "String",
        "Options": [
         {
          "Value": "Y",
          "Label": "歲"
         },
         {
          "Value": "M",
          "Label": "月"
         },
         {
          "Value": "D",
          "Label": "日"
         }
        ],
        "Default": "Y",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "AssociatedItems",
      "Label": "清單下併報項目",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "項目代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "TreatmentItems",
      "Label": "核定治療項目",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "FilterOptions",
        "Label": "比對欄位",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "01",
          "Label": "特殊治療項目代號（一）"
         },
         {
          "Value": "02",
          "Label": "特殊治療項目代號（二）"
         },
         {
          "Value": "03",
          "Label": "特殊治療項目代號（三）"
         },
         {
          "Value": "04",
          "Label": "特殊治療項目代號（四）"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "Department",
      "Label": "就醫科別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "DepartmentOptions",
        "Label": "就醫科別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PXX/997",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "Robotic",
      "Label": "僅機械手臂輔助手術",
      "Fields": [
       {
        "Value": "RoboticOption",
        "Label": "是否限定",
        "Type": "String",
        "Options": [
         {
          "Value": "Y",
          "Label": "是"
         },
         {
          "Value": "N",
          "Label": "否"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     }
    ]
   },
   {
    "Value": "305",
    "Label": "不得同時申報項目",
    "MainFields": [
     {
      "Value": "BodyPart",
      "Label": "部位",
      "Type": "String",
      "Options": [
       {
        "Value": "B01",
        "Label": "左"
       },
       {
        "Value": "B02",
        "Label": "右"
       },
       {
        "Value": "B03",
        "Label": "雙側"
       },
       {
        "Value": "B04",
        "Label": "不分"
       }
      ]
     },
     {
      "Value": "BodyPartCategory",
      "Label": "部位代碼類別",
      "Type": "String",
      "Options": [
       {
        "Value": "01",
        "Label": "代碼"
       },
       {
        "Value": "02",
        "Label": "開頭"
       },
       {
        "Value": "03",
        "Label": "開頭範圍"
       },
       {
        "Value": "04",
        "Label": "群組"
       }
      ],
      "Constraints": [
       {
        "Type": "Required",
        "Message": "必填欄位"
       }
      ]
     },
     {
      "Value": "BodyPartPrefixLen",
      "Label": "部位前幾碼",
      "Type": "Number",
      "PrefixText": "前",
      "SuffixText": "碼",
      "Constraints": [
       {
        "Type": "Min",
        "Message": "不得小於 0",
        "Value": 0
       }
      ]
     },
     {
      "Value": "BodyPartRangeStart",
      "Label": "部位起始值",
      "Type": "String",
      "Placeholder": "起始值"
     },
     {
      "Value": "BodyPartRangeEnd",
      "Label": "部位結束值",
      "Type": "String",
      "PrefixText": "-",
      "Placeholder": "結束值",
      "Constraints": [
       {
        "Type": "CompareField",
        "Message": "結束值須大於等於起始值",
        "Field": "BodyPartRangeStart",
        "Op": ">="
       }
      ]
     },
     {
      "Value": "BodyPartCodes",
      "Label": "部位代碼",
      "Type": "StringArray",
      "Placeholder": "輸入代碼後按 Enter"
     },
     {
      "Value": "BodyPartPrefix",
      "Label": "部位開頭值",
      "Type": "String",
      "PrefixText": "輸入開頭",
      "Placeholder": "請輸入字首"
     },
     {
      "Value": "BodyPartGroup",
      "Label": "部位群組",
      "Type": "String",
      "Options": [
       {
        "Value": "G01",
        "Label": "群組一"
       },
       {
        "Value": "G02",
        "Label": "群組二"
       },
       {
        "Value": "G03",
        "Label": "群組三"
       }
      ]
     },
     {
      "Value": "OrderCategory",
      "Label": "併同申報項目類別",
      "Type": "String",
      "Options": [
       {
        "Value": "01",
        "Label": "代碼"
       },
       {
        "Value": "02",
        "Label": "開頭"
       },
       {
        "Value": "03",
        "Label": "開頭範圍"
       },
       {
        "Value": "04",
        "Label": "群組"
       }
      ],
      "Constraints": [
       {
        "Type": "Required",
        "Message": "必填欄位"
       }
      ]
     },
     {
      "Value": "OrderPrefixLen",
      "Label": "併同申報項目前幾碼",
      "Type": "Number",
      "PrefixText": "前",
      "SuffixText": "碼",
      "Constraints": [
       {
        "Type": "Min",
        "Message": "不得小於 0",
        "Value": 0
       }
      ]
     },
     {
      "Value": "OrderRangeStart",
      "Label": "併同申報項目起始值",
      "Type": "String",
      "Placeholder": "起始值"
     },
     {
      "Value": "OrderRangeEnd",
      "Label": "併同申報項目結束值",
      "Type": "String",
      "PrefixText": "-",
      "Placeholder": "結束值",
      "Constraints": [
       {
        "Type": "CompareField",
        "Message": "結束值須大於等於起始值",
        "Field": "OrderRangeStart",
        "Op": ">="
       }
      ]
     },
     {
      "Value": "OrderCodes",
      "Label": "併同申報項目代碼",
      "Type": "StringArray",
      "Placeholder": "輸入代碼後按 Enter"
     },
     {
      "Value": "OrderPrefix",
      "Label": "併同申報項目開頭值",
      "Type": "String",
      "PrefixText": "輸入開頭",
      "Placeholder": "請輸入字首"
     },
     {
      "Value": "OrderGroup",
      "Label": "併同申報項目群組",
      "Type": "String",
      "Options": [
       {
        "Value": "G01",
        "Label": "群組一"
       },
       {
        "Value": "G02",
        "Label": "群組二"
       },
       {
        "Value": "G03",
        "Label": "群組三"
       }
      ]
     }
    ],
    "ReferenceFields": [
     {
      "Value": "ReferenceDates",
      "Label": "參考日期",
      "Type": "StringArray",
      "Options": [
       {
        "Value": "ApplyDate",
        "Label": "就醫日期"
       },
       {
        "Value": "ExecutionStartDate",
        "Label": "醫令執行起日"
       },
       {
        "Value": "TreatmentEndDate",
        "Label": "治療結束日"
       },
       {
        "Value": "AdmissionDate",
        "Label": "住院日期"
       },
       {
        "Value": "DischargeDate",
        "Label": "出院日期"
       },
       {
        "Value": "DispensingDate",
        "Label": "調劑日期"
       },
       {
        "Value": "PhysicalTherapyStartDate",
        "Label": "物理治療起日"
       },
       {
        "Value": "ExaminationDate",
        "Label": "檢驗日期"
       }
      ],
      "Default": [
       "ApplyDate",
       "ExecutionStartDate"
      ]
     }
    ],
    "Conditions": [
     {
      "Value": "CaseType",
      "Label": "案件分類",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "案件分類類別",
        "Type": "String",
        "Options": [
         {
          "Value": "101",
          "Label": "門診西醫"
         },
         {
          "Value": "104",
          "Label": "住診"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "CaseTypeOptions",
        "Label": "案件分類選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/{Category}",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "Level",
      "Label": "層級別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "LevelOptions",
        "Label": "層級別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/QRD/003",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "HospCode",
      "Label": "醫事類別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "醫事類別類型",
        "Type": "String",
        "Options": [
         {
          "Value": "011",
          "Label": "門診"
         },
         {
          "Value": "012",
          "Label": "住診"
         },
         {
          "Value": "013",
          "Label": "其他"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "HospCodeOptions",
        "Label": "醫事類別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/{Category}",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "OrderType",
      "Label": "醫令類別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "OrderTypeOptions",
        "Label": "醫令類別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/132",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "RelMode",
      "Label": "處方調劑方式",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "RelModeOptions",
        "Label": "處方調劑方式選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/131",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "SubMainDiagnosisCode",
      "Label": "主次診斷代碼",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "FilterOptions",
        "Label": "比對欄位",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "ICD9CM_CODE",
          "Label": "主診斷代碼"
         },
         {
          "Value": "ICD9CM_CODE1",
          "Label": "次診斷代碼(一)"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "PartCode",
      "Label": "部分負擔代碼",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "TreatmentArea",
      "Label": "診療之部位",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         },
         {
          "Value": "04",
          "Label": "群組"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "GroupOption",
        "Label": "群組",
        "Type": "String",
        "Options": [
         {
          "Value": "TreatmentG01",
          "Label": "群組一"
         },
         {
          "Value": "TreatmentG02",
          "Label": "群組二"
         },
         {
          "Value": "TreatmentG03",
          "Label": "群組三"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "04"
        }
       }
      ]
     },
     {
      "Value": "Age",
      "Label": "年齡",
      "Fields": [
       {
        "Value": "ReferenceDates",
        "Label": "基準日（可排序）",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "01",
          "Label": "就醫日期"
         },
         {
          "Value": "02",
          "Label": "醫令執行起日"
         },
         {
          "Value": "03",
          "Label": "治療結束日"
         },
         {
          "Value": "04",
          "Label": "住院日期"
         },
         {
          "Value": "05",
          "Label": "出院日期"
         },
         {
          "Value": "06",
          "Label": "調劑日期"
         },
         {
          "Value": "07",
          "Label": "物理治療起日"
         },
         {
          "Value": "08",
          "Label": "檢驗日期"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "OperatorMin",
        "Label": "下限運算子",
        "Type": "String",
        "Options": [
         {
          "Value": ">",
          "Label": "大於"
         },
         {
          "Value": ">=",
          "Label": "大於等於"
         }
        ]
       },
       {
        "Value": "Min",
        "Label": "下限",
        "Type": "Number",
        "Placeholder": "不填表示無下限"
       },
       {
        "Value": "OperatorMax",
        "Label": "上限運算子",
        "Type": "String",
        "Options": [
         {
          "Value": "<",
          "Label": "小於"
         },
         {
          "Value": "<=",
          "Label": "小於等於"
         }
        ]
       },
       {
        "Value": "Max",
        "Label": "上限",
        "Type": "Number",
        "Placeholder": "不填表示無上限"
       },
       {
        "Value": "Unit",
        "Label": "單位",
        "Type": "String",
        "Options": [
         {
          "Value": "Y",
          "Label": "歲"
         },
         {
          "Value": "M",
          "Label": "月"
         },
         {
          "Value": "D",
          "Label": "日"
         }
        ],
        "Default": "Y",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "AssociatedItems",
      "Label": "清單下併報項目",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "項目代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "TreatmentItems",
      "Label": "核定治療項目",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "FilterOptions",
        "Label": "比對欄位",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "01",
          "Label": "特殊治療項目代號（一）"
         },
         {
          "Value": "02",
          "Label": "特殊治療項目代號（二）"
         },
         {
          "Value": "03",
          "Label": "特殊治療項目代號（三）"
         },
         {
          "Value": "04",
          "Label": "特殊治療項目代號（四）"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "Department",
      "Label": "就醫科別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "DepartmentOptions",
        "Label": "就醫科別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PXX/997",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "Robotic",
      "Label": "僅機械手臂輔助手術",
      "Fields": [
       {
        "Value": "RoboticOption",
        "Label": "是否限定",
        "Type": "String",
        "Options": [
         {
          "Value": "Y",
          "Label": "是"
         },
         {
          "Value": "N",
          "Label": "否"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     }
    ]
   },
   {
    "Value": "306",
    "Label": "需同時併報項目",
    "MainFields": [
     {
      "Value": "DiagnosisCategory",
      "Label": "主診斷代碼類別",
      "Type": "String",
      "Options": [
       {
        "Value": "01",
        "Label": "代碼"
       },
       {
        "Value": "02",
        "Label": "開頭"
       },
       {
        "Value": "03",
        "Label": "開頭範圍"
       }
      ],
      "Constraints": [
       {
        "Type": "Required",
        "Message": "必填欄位"
       }
      ]
     },
     {
      "Value": "DiagnosisPrefixLen",
      "Label": "主診斷代碼前幾碼",
      "Type": "Number",
      "PrefixText": "前",
      "SuffixText": "碼",
      "Constraints": [
       {
        "Type": "Min",
        "Message": "不得小於 0",
        "Value": 0
       }
      ]
     },
     {
      "Value": "DiagnosisRangeStart",
      "Label": "主診斷代碼起始值",
      "Type": "String",
      "Placeholder": "起始值"
     },
     {
      "Value": "DiagnosisRangeEnd",
      "Label": "主診斷代碼結束值",
      "Type": "String",
      "PrefixText": "-",
      "Placeholder": "結束值",
      "Constraints": [
       {
        "Type": "CompareField",
        "Message": "結束值須大於等於起始值",
        "Field": "DiagnosisRangeStart",
        "Op": ">="
       }
      ]
     },
     {
      "Value": "DiagnosisCodes",
      "Label": "主診斷代碼代碼",
      "Type": "StringArray",
      "Placeholder": "輸入代碼後按 Enter"
     },
     {
      "Value": "DiagnosisPrefix",
      "Label": "主診斷代碼開頭值",
      "Type": "String",
      "PrefixText": "輸入開頭",
      "Placeholder": "請輸入字首"
     }
    ],
    "ReferenceFields": [
     {
      "Value": "ReferenceDates",
      "Label": "參考日期",
      "Type": "StringArray",
      "Options": [
       {
        "Value": "ApplyDate",
        "Label": "就醫日期"
       },
       {
        "Value": "ExecutionStartDate",
        "Label": "醫令執行起日"
       },
       {
        "Value": "TreatmentEndDate",
        "Label": "治療結束日"
       },
       {
        "Value": "AdmissionDate",
        "Label": "住院日期"
       },
       {
        "Value": "DischargeDate",
        "Label": "出院日期"
       },
       {
        "Value": "DispensingDate",
        "Label": "調劑日期"
       },
       {
        "Value": "PhysicalTherapyStartDate",
        "Label": "物理治療起日"
       },
       {
        "Value": "ExaminationDate",
        "Label": "檢驗日期"
       }
      ],
      "Default": [
       "ApplyDate",
       "ExecutionStartDate"
      ]
     }
    ],
    "Conditions": [
     {
      "Value": "CaseType",
      "Label": "案件分類",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "案件分類類別",
        "Type": "String",
        "Options": [
         {
          "Value": "101",
          "Label": "門診西醫"
         },
         {
          "Value": "104",
          "Label": "住診"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "CaseTypeOptions",
        "Label": "案件分類選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/{Category}",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "Level",
      "Label": "層級別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "LevelOptions",
        "Label": "層級別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/QRD/003",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "HospCode",
      "Label": "醫事類別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "醫事類別類型",
        "Type": "String",
        "Options": [
         {
          "Value": "011",
          "Label": "門診"
         },
         {
          "Value": "012",
          "Label": "住診"
         },
         {
          "Value": "013",
          "Label": "其他"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "HospCodeOptions",
        "Label": "醫事類別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/{Category}",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "OrderType",
      "Label": "醫令類別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "OrderTypeOptions",
        "Label": "醫令類別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/132",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "RelMode",
      "Label": "處方調劑方式",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "RelModeOptions",
        "Label": "處方調劑方式選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/131",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "SubMainDiagnosisCode",
      "Label": "主次診斷代碼",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "FilterOptions",
        "Label": "比對欄位",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "ICD9CM_CODE",
          "Label": "主診斷代碼"
         },
         {
          "Value": "ICD9CM_CODE1",
          "Label": "次診斷代碼(一)"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "PartCode",
      "Label": "部分負擔代碼",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "TreatmentArea",
      "Label": "診療之部位",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         },
         {
          "Value": "04",
          "Label": "群組"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "GroupOption",
        "Label": "群組",
        "Type": "String",
        "Options": [
         {
          "Value": "TreatmentG01",
          "Label": "群組一"
         },
         {
          "Value": "TreatmentG02",
          "Label": "群組二"
         },
         {
          "Value": "TreatmentG03",
          "Label": "群組三"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "04"
        }
       }
      ]
     },
     {
      "Value": "Age",
      "Label": "年齡",
      "Fields": [
       {
        "Value": "ReferenceDates",
        "Label": "基準日（可排序）",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "01",
          "Label": "就醫日期"
         },
         {
          "Value": "02",
          "Label": "醫令執行起日"
         },
         {
          "Value": "03",
          "Label": "治療結束日"
         },
         {
          "Value": "04",
          "Label": "住院日期"
         },
         {
          "Value": "05",
          "Label": "出院日期"
         },
         {
          "Value": "06",
          "Label": "調劑日期"
         },
         {
          "Value": "07",
          "Label": "物理治療起日"
         },
         {
          "Value": "08",
          "Label": "檢驗日期"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "OperatorMin",
        "Label": "下限運算子",
        "Type": "String",
        "Options": [
         {
          "Value": ">",
          "Label": "大於"
         },
         {
          "Value": ">=",
          "Label": "大於等於"
         }
        ]
       },
       {
        "Value": "Min",
        "Label": "下限",
        "Type": "Number",
        "Placeholder": "不填表示無下限"
       },
       {
        "Value": "OperatorMax",
        "Label": "上限運算子",
        "Type": "String",
        "Options": [
         {
          "Value": "<",
          "Label": "小於"
         },
         {
          "Value": "<=",
          "Label": "小於等於"
         }
        ]
       },
       {
        "Value": "Max",
        "Label": "上限",
        "Type": "Number",
        "Placeholder": "不填表示無上限"
       },
       {
        "Value": "Unit",
        "Label": "單位",
        "Type": "String",
        "Options": [
         {
          "Value": "Y",
          "Label": "歲"
         },
         {
          "Value": "M",
          "Label": "月"
         },
         {
          "Value": "D",
          "Label": "日"
         }
        ],
        "Default": "Y",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "AssociatedItems",
      "Label": "清單下併報項目",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "項目代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "TreatmentItems",
      "Label": "核定治療項目",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "FilterOptions",
        "Label": "比對欄位",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "01",
          "Label": "特殊治療項目代號（一）"
         },
         {
          "Value": "02",
          "Label": "特殊治療項目代號（二）"
         },
         {
          "Value": "03",
          "Label": "特殊治療項目代號（三）"
         },
         {
          "Value": "04",
          "Label": "特殊治療項目代號（四）"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "Department",
      "Label": "就醫科別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "DepartmentOptions",
        "Label": "就醫科別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PXX/997",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "Robotic",
      "Label": "僅機械手臂輔助手術",
      "Fields": [
       {
        "Value": "RoboticOption",
        "Label": "是否限定",
        "Type": "String",
        "Options": [
         {
          "Value": "Y",
          "Label": "是"
         },
         {
          "Value": "N",
          "Label": "否"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     }
    ]
   },
   {
    "Value": "307",
    "Label": "適應症診斷碼限制",
    "MainFields": [
     {
      "Value": "DiagnosisCodes",
      "Label": "診斷碼條件",
      "Type": "ObjectArray",
      "SubFields": [
       {
        "Value": "RangeStart1",
        "Label": "起始值",
        "Type": "String",
        "SuffixText": "~",
        "Placeholder": "開頭字元",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "RangeEnd1",
        "Label": "結束值",
        "Type": "String",
        "SuffixText": "，",
        "Placeholder": "結尾字元",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart1",
          "Op": ">="
         }
        ]
       },
       {
        "Value": "RangeStart2",
        "Label": "起始值（第二段）",
        "Type": "Number",
        "SuffixText": "~",
        "Placeholder": "起始月",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "RangeEnd2",
        "Label": "結束值（第二段）",
        "Type": "Number",
        "SuffixText": "月",
        "Placeholder": "結束月",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart2",
          "Op": ">="
         }
        ]
       }
      ]
     },
     {
      "Value": "DiagnosisScope",
      "Label": "篩選範圍",
      "Type": "StringArray",
      "Options": [
       {
        "Value": "01",
        "Label": "(01) 主診斷"
       },
       {
        "Value": "02",
        "Label": "(02) 次診斷"
       }
      ],
      "Constraints": [
       {
        "Type": "Required",
        "Message": "必填欄位"
       }
      ]
     }
    ],
    "ReferenceFields": [
     {
      "Value": "ReferenceDates",
      "Label": "參考日期",
      "Type": "StringArray",
      "Options": [
       {
        "Value": "ApplyDate",
        "Label": "就醫日期"
       },
       {
        "Value": "ExecutionStartDate",
        "Label": "醫令執行起日"
       },
       {
        "Value": "TreatmentEndDate",
        "Label": "治療結束日"
       },
       {
        "Value": "AdmissionDate",
        "Label": "住院日期"
       },
       {
        "Value": "DischargeDate",
        "Label": "出院日期"
       },
       {
        "Value": "DispensingDate",
        "Label": "調劑日期"
       },
       {
        "Value": "PhysicalTherapyStartDate",
        "Label": "物理治療起日"
       },
       {
        "Value": "ExaminationDate",
        "Label": "檢驗日期"
       }
      ],
      "Default": [
       "ApplyDate",
       "ExecutionStartDate"
      ]
     },
     {
      "Value": "AgeReference",
      "Label": "出生日期來源",
      "Type": "StringArray",
      "Options": [
       {
        "Value": "birthday",
        "Label": "出生日期"
       },
       {
        "Value": "child_birthday",
        "Label": "新生兒出生日"
       }
      ],
      "Default": [
       "birthday",
       "child_birthday"
      ]
     }
    ],
    "Conditions": [
     {
      "Value": "CaseType",
      "Label": "案件分類",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "案件分類類別",
        "Type": "String",
        "Options": [
         {
          "Value": "101",
          "Label": "門診西醫"
         },
         {
          "Value": "104",
          "Label": "住診"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "CaseTypeOptions",
        "Label": "案件分類選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/{Category}",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "Level",
      "Label": "層級別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "LevelOptions",
        "Label": "層級別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/QRD/003",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "HospCode",
      "Label": "醫事類別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "醫事類別類型",
        "Type": "String",
        "Options": [
         {
          "Value": "011",
          "Label": "門診"
         },
         {
          "Value": "012",
          "Label": "住診"
         },
         {
          "Value": "013",
          "Label": "其他"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "HospCodeOptions",
        "Label": "醫事類別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/{Category}",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "OrderType",
      "Label": "醫令類別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "OrderTypeOptions",
        "Label": "醫令類別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/132",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "RelMode",
      "Label": "處方調劑方式",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "RelModeOptions",
        "Label": "處方調劑方式選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/131",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "SubMainDiagnosisCode",
      "Label": "主次診斷代碼",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "FilterOptions",
        "Label": "比對欄位",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "ICD9CM_CODE",
          "Label": "主診斷代碼"
         },
         {
          "Value": "ICD9CM_CODE1",
          "Label": "次診斷代碼(一)"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "PartCode",
      "Label": "部分負擔代碼",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "TreatmentArea",
      "Label": "診療之部位",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         },
         {
          "Value": "04",
          "Label": "群組"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "GroupOption",
        "Label": "群組",
        "Type": "String",
        "Options": [
         {
          "Value": "TreatmentG01",
          "Label": "群組一"
         },
         {
          "Value": "TreatmentG02",
          "Label": "群組二"
         },
         {
          "Value": "TreatmentG03",
          "Label": "群組三"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "04"
        }
       }
      ]
     },
     {
      "Value": "Age",
      "Label": "年齡",
      "Fields": [
       {
        "Value": "ReferenceDates",
        "Label": "基準日（可排序）",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "01",
          "Label": "就醫日期"
         },
         {
          "Value": "02",
          "Label": "醫令執行起日"
         },
         {
          "Value": "03",
          "Label": "治療結束日"
         },
         {
          "Value": "04",
          "Label": "住院日期"
         },
         {
          "Value": "05",
          "Label": "出院日期"
         },
         {
          "Value": "06",
          "Label": "調劑日期"
         },
         {
          "Value": "07",
          "Label": "物理治療起日"
         },
         {
          "Value": "08",
          "Label": "檢驗日期"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "OperatorMin",
        "Label": "下限運算子",
        "Type": "String",
        "Options": [
         {
          "Value": ">",
          "Label": "大於"
         },
         {
          "Value": ">=",
          "Label": "大於等於"
         }
        ]
       },
       {
        "Value": "Min",
        "Label": "下限",
        "Type": "Number",
        "Placeholder": "不填表示無下限"
       },
       {
        "Value": "OperatorMax",
        "Label": "上限運算子",
        "Type": "String",
        "Options": [
         {
          "Value": "<",
          "Label": "小於"
         },
         {
          "Value": "<=",
          "Label": "小於等於"
         }
        ]
       },
       {
        "Value": "Max",
        "Label": "上限",
        "Type": "Number",
        "Placeholder": "不填表示無上限"
       },
       {
        "Value": "Unit",
        "Label": "單位",
        "Type": "String",
        "Options": [
         {
          "Value": "Y",
          "Label": "歲"
         },
         {
          "Value": "M",
          "Label": "月"
         },
         {
          "Value": "D",
          "Label": "日"
         }
        ],
        "Default": "Y",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "AssociatedItems",
      "Label": "清單下併報項目",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "項目代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "TreatmentItems",
      "Label": "核定治療項目",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "FilterOptions",
        "Label": "比對欄位",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "01",
          "Label": "特殊治療項目代號（一）"
         },
         {
          "Value": "02",
          "Label": "特殊治療項目代號（二）"
         },
         {
          "Value": "03",
          "Label": "特殊治療項目代號（三）"
         },
         {
          "Value": "04",
          "Label": "特殊治療項目代號（四）"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "Department",
      "Label": "就醫科別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "DepartmentOptions",
        "Label": "就醫科別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PXX/997",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "Robotic",
      "Label": "僅機械手臂輔助手術",
      "Fields": [
       {
        "Value": "RoboticOption",
        "Label": "是否限定",
        "Type": "String",
        "Options": [
         {
          "Value": "Y",
          "Label": "是"
         },
         {
          "Value": "N",
          "Label": "否"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     }
    ]
   },
   {
    "Value": "401",
    "Label": "門住診限制",
    "MainFields": [
     {
      "Value": "VisitTypes",
      "Label": "門住診限制",
      "Type": "StringArray",
      "Options": [
       {
        "Value": "01",
        "Label": "門診"
       },
       {
        "Value": "02",
        "Label": "住診"
       },
       {
        "Value": "03",
        "Label": "限急診"
       },
       {
        "Value": "04",
        "Label": "牙醫門診"
       }
      ],
      "Constraints": [
       {
        "Type": "Required",
        "Message": "必填欄位"
       }
      ]
     }
    ],
    "Conditions": [
     {
      "Value": "CaseType",
      "Label": "案件分類",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "案件分類類別",
        "Type": "String",
        "Options": [
         {
          "Value": "101",
          "Label": "門診西醫"
         },
         {
          "Value": "104",
          "Label": "住診"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "CaseTypeOptions",
        "Label": "案件分類選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/{Category}",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "Level",
      "Label": "層級別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "LevelOptions",
        "Label": "層級別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/QRD/003",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "HospCode",
      "Label": "醫事類別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "醫事類別類型",
        "Type": "String",
        "Options": [
         {
          "Value": "011",
          "Label": "門診"
         },
         {
          "Value": "012",
          "Label": "住診"
         },
         {
          "Value": "013",
          "Label": "其他"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "HospCodeOptions",
        "Label": "醫事類別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/{Category}",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "OrderType",
      "Label": "醫令類別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "OrderTypeOptions",
        "Label": "醫令類別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/132",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "RelMode",
      "Label": "處方調劑方式",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "RelModeOptions",
        "Label": "處方調劑方式選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PBA/131",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "SubMainDiagnosisCode",
      "Label": "主次診斷代碼",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "FilterOptions",
        "Label": "比對欄位",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "ICD9CM_CODE",
          "Label": "主診斷代碼"
         },
         {
          "Value": "ICD9CM_CODE1",
          "Label": "次診斷代碼(一)"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "PartCode",
      "Label": "部分負擔代碼",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "TreatmentArea",
      "Label": "診療之部位",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         },
         {
          "Value": "04",
          "Label": "群組"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "GroupOption",
        "Label": "群組",
        "Type": "String",
        "Options": [
         {
          "Value": "TreatmentG01",
          "Label": "群組一"
         },
         {
          "Value": "TreatmentG02",
          "Label": "群組二"
         },
         {
          "Value": "TreatmentG03",
          "Label": "群組三"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "04"
        }
       }
      ]
     },
     {
      "Value": "Age",
      "Label": "年齡",
      "Fields": [
       {
        "Value": "ReferenceDates",
        "Label": "基準日（可排序）",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "01",
          "Label": "就醫日期"
         },
         {
          "Value": "02",
          "Label": "醫令執行起日"
         },
         {
          "Value": "03",
          "Label": "治療結束日"
         },
         {
          "Value": "04",
          "Label": "住院日期"
         },
         {
          "Value": "05",
          "Label": "出院日期"
         },
         {
          "Value": "06",
          "Label": "調劑日期"
         },
         {
          "Value": "07",
          "Label": "物理治療起日"
         },
         {
          "Value": "08",
          "Label": "檢驗日期"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "OperatorMin",
        "Label": "下限運算子",
        "Type": "String",
        "Options": [
         {
          "Value": ">",
          "Label": "大於"
         },
         {
          "Value": ">=",
          "Label": "大於等於"
         }
        ]
       },
       {
        "Value": "Min",
        "Label": "下限",
        "Type": "Number",
        "Placeholder": "不填表示無下限"
       },
       {
        "Value": "OperatorMax",
        "Label": "上限運算子",
        "Type": "String",
        "Options": [
         {
          "Value": "<",
          "Label": "小於"
         },
         {
          "Value": "<=",
          "Label": "小於等於"
         }
        ]
       },
       {
        "Value": "Max",
        "Label": "上限",
        "Type": "Number",
        "Placeholder": "不填表示無上限"
       },
       {
        "Value": "Unit",
        "Label": "單位",
        "Type": "String",
        "Options": [
         {
          "Value": "Y",
          "Label": "歲"
         },
         {
          "Value": "M",
          "Label": "月"
         },
         {
          "Value": "D",
          "Label": "日"
         }
        ],
        "Default": "Y",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "AssociatedItems",
      "Label": "清單下併報項目",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "項目代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "TreatmentItems",
      "Label": "核定治療項目",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "FilterOptions",
        "Label": "比對欄位",
        "Type": "StringArray",
        "Options": [
         {
          "Value": "01",
          "Label": "特殊治療項目代號（一）"
         },
         {
          "Value": "02",
          "Label": "特殊治療項目代號（二）"
         },
         {
          "Value": "03",
          "Label": "特殊治療項目代號（三）"
         },
         {
          "Value": "04",
          "Label": "特殊治療項目代號（四）"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Category",
        "Label": "輸入方式",
        "Type": "String",
        "Options": [
         {
          "Value": "01",
          "Label": "代碼"
         },
         {
          "Value": "02",
          "Label": "開頭"
         },
         {
          "Value": "03",
          "Label": "開頭範圍"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "Codes",
        "Label": "代碼",
        "Type": "StringArray",
        "Placeholder": "輸入代碼後按 Enter",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "01"
        }
       },
       {
        "Value": "InputPrefix",
        "Label": "開頭值",
        "Type": "String",
        "Placeholder": "請輸入字首",
        "VisibleWhen": {
         "Field": "Category",
         "Value": "02"
        }
       },
       {
        "Value": "RangeStart",
        "Label": "起始值",
        "Type": "String",
        "Placeholder": "起始值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       },
       {
        "Value": "RangeEnd",
        "Label": "結束值",
        "Type": "String",
        "Placeholder": "結束值",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         },
         {
          "Type": "CompareField",
          "Message": "結束值須大於等於起始值",
          "Field": "RangeStart",
          "Op": ">="
         }
        ],
        "VisibleWhen": {
         "Field": "Category",
         "Value": "03"
        }
       }
      ]
     },
     {
      "Value": "Department",
      "Label": "就醫科別",
      "Fields": [
       {
        "Value": "Operator",
        "Label": "比對條件",
        "Type": "String",
        "Options": [
         {
          "Value": "In",
          "Label": "包含"
         },
         {
          "Value": "NotIn",
          "Label": "不包含"
         }
        ],
        "Default": "In",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       },
       {
        "Value": "DepartmentOptions",
        "Label": "就醫科別選項",
        "Type": "StringArray",
        "OptionsApi": "/api/v1/Options/PxxtCode/PXX/997",
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     },
     {
      "Value": "Robotic",
      "Label": "僅機械手臂輔助手術",
      "Fields": [
       {
        "Value": "RoboticOption",
        "Label": "是否限定",
        "Type": "String",
        "Options": [
         {
          "Value": "Y",
          "Label": "是"
         },
         {
          "Value": "N",
          "Label": "否"
         }
        ],
        "Constraints": [
         {
          "Type": "Required",
          "Message": "必填欄位"
         }
        ]
       }
      ]
     }
    ]
   }
  ]
 }
]

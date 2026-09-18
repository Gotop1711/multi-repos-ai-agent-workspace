---
source: docs/assets/rea/2026-09-18-nhia-his3-dev-standard-v2-federation-config-screens-p52-55.pdf
sha256: f27a056c2d54f76a8442a6d156029a0cd3319c585a8111f94750df4b4bd2a6de
bytes: 671669
extractor: vision-ocr
status: ok
received: 2026-09-18-nhia-his3-dev-standard-v2-federation-config-screens-p52-55.pdf
---
<!-- page 1 (ocr) -->
「第三代醫療資訊系統建置案」開發規範
import subSystem from "@/App vue"： /入口
import subSystemPage from "@/views/ subSystemPage/index.vue"；// 子系統頁面載入
export const SubSystemRouter =［e
它
path：""，《
component: subSystem,f
name：" subSystem"，e
redirect："/admin/ subSystem / subSystemPage"，e
children： ［1
path："subSystemPage"，t
component: subSystemPage
name： " subSystemPage"，
meta:0，¢
］；
44
<!-- page 2 (ocr) -->
「第三代醫療資訊系統建置案」開發規範
（3） 子系統 vite.config 設定
import ｛fileURLToPath, URL｝from "node:url"；e
import ｛ defineConfig ｝from "vite"：f
import vue from "@vitejs/plugin-vue"：
import vueDevTools from "vite-plugin-vue-devtools"，f
import federation from "@originjs/vite-plugin-federation"%
export default defineConfig（f
plugins:F
wue,q
VuEDevTools（］，t
federation（f
name： "hmai4000"，f
filename： "remoteEntry.js"，r
remotes：它
main："http:/localhost:5100/dist/assets/remateEntryjs，-
"./hmaSystem"："./src/router/ subSystem Routerjs".//將子系統路由結構 exposes 給主系統刊
shared：［"vue"， "wue-router"，"'pinia"］，f
｝），土
server：它
host: true,r
port: 5102，¢
headers：它
"'access-control-allow-headers"： “GET,POST, PUT, DELETE”，
'access-control-allow-headers"：*f
"'access-control-allow-origin"： "*"，化
｝，¢
resalve：它
alias：它
"@"：fileURLToPath（new URL（"./src"， import.meta.url）），他
｝，+
build：它
target:esnext"，
3：
45
<!-- page 3 (ocr) -->
「第三代醫療資訊系統建置案」開發規範
（三）主系統配置
1、主系統 router 設定
import ｛createRouter, createWebHistory ｝from "wue-router't
import ｛SubSystemRouter ｝ from 'subSystem/ subSystemRouter // 子系统路由結構 從子系統提
供引入
const router = createRouter（f
history: createWebHistorylim port.meta.enW.BASE_ URL），+
rautes:F
path:/admin,f
redirect:/admin/main,e
component: DefaultLayaut, e
children: l
宅
path:main,e
component：（） => import（@/views/home/index.wue），-
name: Main -
meta：它
title： 公告事項，
｝-
｝-
path：'subSystem,// 設定子系统路由名稱＋
chidren: SubSystem Router, //設定在主系統的子系统路由底下H
］+
化
它
path:/：catchAI（.*］
name:404）
companent：（） => importl @/views/errorPage/404. ue），f
title:404，
｝+
46
<!-- page 4 (ocr) -->
「第三代醫療資訊系統建置案」開發規範
2、主系統 vite.config 設定
import ｛ fileURLToPath, URL. ｝ from 'node:urfe
import ｛ definaconfig ｝from 'vitel
import wue from'@viteis/plugin-wuek
import wue DevToals fram "vite:plugin-wue-devtoals
import federation from"@originjs/vite-plugin-federation'e
export dafault defineconfig（它
plugins: l
WUEO），+
vuEDEvTocls（），
federation（f
name： 'Nhivue.main'，e
remates:f
subsystem： 'http://localhost:5102/dist/assets/remoteEntryjs. // 將子系统跆由結常導入主
'/store：，/src/stores/index.js, e
'./1/components：./src/componants/V1/index js,e
：/2/components：'/src/components/V2/index jst
｝¢
shared: R'vue'：｛sing/eton:true ｝， Mue-router'：｛singleton:true ｝， 'pinia'： ｛singleton:true ｝H
14
rESOlve：你
alias：｛
'@：fileU RLTaPath（new URLY'./snc, import.meta.urll
POrt: 5100，元
cor5：定
origin："+，-
mathods： "GET,PUT,POST, DELETE"，t
optionssuccessStatus: 204-
build：｛
target'esnext
Kntonsave:false
47

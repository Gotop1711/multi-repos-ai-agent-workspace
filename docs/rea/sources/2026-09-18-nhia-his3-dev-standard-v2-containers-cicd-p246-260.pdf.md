---
source: docs/assets/rea/2026-09-18-nhia-his3-dev-standard-v2-containers-cicd-p246-260.pdf
sha256: 9c9a0086347d734da2f8edc3bec23c23fafc17c45466dba7ce71024085f25103
bytes: 1020275
extractor: pdfkit
status: ok
received: 2026-09-18-nhia-his3-dev-standard-v2-containers-cicd-p246-260.pdf
pictures: 2026-09-18-nhia-his3-dev-standard-v2-containers-cicd-p246-260.pdf.p2.jpg 2026-09-18-nhia-his3-dev-standard-v2-containers-cicd-p246-260.pdf.p3.jpg 2026-09-18-nhia-his3-dev-standard-v2-containers-cicd-p246-260.pdf.p4.jpg 2026-09-18-nhia-his3-dev-standard-v2-containers-cicd-p246-260.pdf.p10.jpg 2026-09-18-nhia-his3-dev-standard-v2-containers-cicd-p246-260.pdf.p11.jpg 2026-09-18-nhia-his3-dev-standard-v2-containers-cicd-p246-260.pdf.p13.jpg
---
<!-- page 1 -->
「第三代醫療資訊系統建置案」開發規範
玖、容器化與 CI/CD 之關連
一、本機容器化
在本機開發時，要將專案在 Docker 環境內先試著執行檢查
是否有問題，確認在容器化是正常運作。
可使用 Podman 在本機進行容器化測試。
二、k8s 容器佈署
(一) CICD-injection
1、cicd 小組在建置前準備了佈署環境，放在 GitHub
https://hi0lgitetser01.intra.nhi.gov.tw/CICD/cicd-injection
238
<!-- page 2 · picture: 2026-09-18-nhia-his3-dev-standard-v2-containers-cicd-p246-260.pdf.p2.jpg -->
「第三代醫療資訊系統建置案」開發規範
239
<!-- page 3 · picture: 2026-09-18-nhia-his3-dev-standard-v2-containers-cicd-p246-260.pdf.p3.jpg -->
「第三代醫療資訊系統建置案」開發規範
240
<!-- page 4 · picture: 2026-09-18-nhia-his3-dev-standard-v2-containers-cicd-p246-260.pdf.p4.jpg -->
「第三代醫療資訊系統建置案」開發規範
241
<!-- page 5 -->
「第三代醫療資訊系統建置案」開發規範
圖 19、CICD-injection
由具有 PR 的同仁協助將 CICD-injection 合併到子系統，在
GitHub 子系統上就會有 DEV-RELEASE 及 SIT-RELEASE 2 個分
支。
242
<!-- page 6 -->
「第三代醫療資訊系統建置案」開發規範
圖 20、DEV-RELEASE 及 SIT-RELEASE 分支
2、Dockerfile 及 k8s yaml
在經由合併 CICD-injection 後在專案資料夾會在.github、
dockerfile、k8s 3 個資料夾，.github 注意這不可以刪除，萬一
被刪除是無法上版。Dockerfile 內有 dotnet、java、npm 這 3 個
資料夾，要依專案的屬性將其中一個資料夾的 Dockerfile Copy
到專案的根目錄，在根目錄只能有一個 Dockerfile，以 dotnet
內是針對.net Core API 內容如下：
(1) <./path/to/*.csproj>換成自己的專案的*.csproj 的所
在位置
(2) <AppName.dll>換成自己專案的 dll 名稱
(3) 在 WORKDIR/app 這行下方增加一行，RUN mkdir
-p /app/logs 這是 pod 地端存放 log 的位置。
(4) 其中的# 對外服務 Port
243
<!-- page 7 -->
「第三代醫療資訊系統建置案」開發規範
EXPOSE 8080
可依實際需求調整。在三代在 port 部分有規範
dev
fw-web:dev ->8000
fw-api:dev ->8001
fw-batch:dev->8002
fw-bff:dev ->8003
sit
fw-web:sit ->8000
fw-api:sit ->8001
fw-batch:sit->8002
fw-bff:sit ->8003
uat
fw-web:sit ->8000
fw-api:sit ->8001
fw-batch:sit->8002
fw-bff:sit ->8003
如果不依三代已設定 port 更改，那在 dotnet EXPOSE 的
port 要跟 deployment.yaml spec:->ports:->-containerPort: port
要一致即可。
(5) Java Dockerfile
244
<!-- page 8 -->
「第三代醫療資訊系統建置案」開發規範
依實際需求調整相關內容
(6) npm Dockerfile 主要是用在前端 vue3
依實際需求調整相關內容，如果有使用到 nginx，要把
nginx.conf 也 Copy 到根目錄。
(7) yaml 檔資料夾
其內容已在 CICD-injection readme.md 已有說明。要用那
些 yaml 要依實際需求調整。
三代依部門劃分 namespace ，med3h20 醫療科、med3h70
服務科、med3hi0 加值科、med3shared 共用服務，一般只能使
用這 4 個 namespace ，如果其他需求要經由申請。
A、使用一鍵生成 yaml
請參考 tpl 資料夾的 readme.md
245
<!-- page 9 -->
「第三代醫療資訊系統建置案」開發規範
(A) API 專案
使用方式為 bash deploy_api.sh <namespace> <部門名稱>
<子系統名稱(5 碼)> <route path>
以 IHKWC 為例
bash deploy_api.sh med3hi0 hi0 ihkwc IHKE300
執行後會在同層增加子系統名稱資料夾，API 其中包含：
Configmap.yaml、deployment.yaml、route.yaml、
secret.yaml、service.yaml。請依實際需求調整內容。
configmap.yaml
deployment.yaml
246
<!-- page 10 · picture: 2026-09-18-nhia-his3-dev-standard-v2-containers-cicd-p246-260.pdf.p10.jpg -->
「第三代醫療資訊系統建置案」開發規範
route.yaml
247
<!-- page 11 · picture: 2026-09-18-nhia-his3-dev-standard-v2-containers-cicd-p246-260.pdf.p11.jpg -->
「第三代醫療資訊系統建置案」開發規範
secret.yaml
service.yaml
(B) Vue 專案
使用方式為 bash deploy_vue.sh <namespace> <部門名稱>
<子系統名稱(5 碼)> <route path>
以 IHKWC 為例
248
<!-- page 12 -->
「第三代醫療資訊系統建置案」開發規範
bash deploy_vue.sh med3hi0 hi0 ihkwc IHKE300
執行後會在同層增加子系統名稱資料夾，API 其中包含：
deployment.yaml、nginx.conf、route.yaml、service.yaml。
請依實際需求調整內容。
deployment.yaml
nginx.conf
249
<!-- page 13 · picture: 2026-09-18-nhia-his3-dev-standard-v2-containers-cicd-p246-260.pdf.p13.jpg -->
「第三代醫療資訊系統建置案」開發規範
route.yaml
service.yaml
250
<!-- page 14 -->
「第三代醫療資訊系統建置案」開發規範
3、DEV-RELEASE 及 SIT-RELEASE 上版
(1) DEV-RELEASE
要先由 PG 發動發出 PR，負責合併同仁進行合併到
main，再到子系統 Repoditory ，點選 Pull requests 新增 New
2
1
pull request
再把 main 拉到 DEV-RELEASE 上版到 Dev
251
<!-- page 15 -->
「第三代醫療資訊系統建置案」開發規範
再到 Actions 查看上版流程及狀況，如果有問題可以查看
log。
(2) SIT-RELEASE
負責合併同仁將 DEV-RELEASE 拉到 SIT-RELEASE，流
程方式一樣，嚴格規定不可以 main 拉到 SIT-RELEASE，一定
要從 main->DEV-RELEASE->SIT-RELEASE 要照這個流程，完
成上版動作。
252

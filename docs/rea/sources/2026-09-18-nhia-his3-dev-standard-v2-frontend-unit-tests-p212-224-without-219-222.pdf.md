---
source: docs/assets/rea/2026-09-18-nhia-his3-dev-standard-v2-frontend-unit-tests-p212-224-without-219-222.pdf
sha256: 974ab2ca5523ec23ce7db583fb5c9858c9642e8c30b8e78b4e7430108c20f192
bytes: 671011
extractor: pdfkit
status: ok
received: 2026-09-18-nhia-his3-dev-standard-v2-frontend-unit-tests-p212-224-without-219-222.pdf
pictures: 2026-09-18-nhia-his3-dev-standard-v2-frontend-unit-tests-p212-224-without-219-222.pdf.p2.jpg 2026-09-18-nhia-his3-dev-standard-v2-frontend-unit-tests-p212-224-without-219-222.pdf.p3.jpg
---
<!-- page 1 -->
「第三代醫療資訊系統建置案」開發規範
陸、單元測試
一、單元測試註解加註說明
利用 AI 成生單元測試程式碼，必須在程式碼加註說明，但
非 AI 成生單元測試程式碼不在此限，但須依必須內容加註解說
明。
二、前端單元測試
(一) 測試工具
1、套件
 Jsdom
2、安裝步驟
(1) 使用管理者權限開啟 powershell，並移動到專案目
錄
(2) Node 虛擬環境運行測試:
 npm install -D vitest @vue/test-utils jsdom
 檢試覆蓋率: npm install -D @vitest/coverage-v8
 支持檢測代碼覆蓋率: npm install -D @vitest/coverage-
istanbul
 查看測試與編寫方式表格:npm install -D @vitest/ui
 使用 pinia 狀態管理單元測試安裝:npm install -D
@pinia/testing
(3) vite.config 配置文件內新增
import vue from '@vitejs/plugin-vue'
// 定義 vitestConfig
const vitestConfig = {
test: {
globals: true,
environment: "jsdom",
coverage:{
all:true,
204
<!-- page 2 · picture: 2026-09-18-nhia-his3-dev-standard-v2-frontend-unit-tests-p212-224-without-219-222.pdf.p2.jpg -->
「第三代醫療資訊系統建置案」開發規範
provifr:'v8',
reporter:['text','json','html']
}
},
}
export default defineConfig({
plugins: [
vue(),
],
// 設定 test
test: vitestConfig.test,
})
(4) package.json srcipt 加入以下
"scripts": {
"test": "vitest",
"coverage": "vitest --environment jsdom --coverage"
},
(5) 使用管理者權限開啟 powershell
 執行 npm run test
205
<!-- page 3 · picture: 2026-09-18-nhia-his3-dev-standard-v2-frontend-unit-tests-p212-224-without-219-222.pdf.p3.jpg -->
「第三代醫療資訊系統建置案」開發規範
 執行 npm run coverage
(6) 專案內的 coverage 資料夾 / index.html 可以看到
測試與編寫方式表格
(二) 測試說明
1、% Stmts(Statements 覆蓋率)
(1) 說明：程式中的 陳述句 (statements) 有多少被執
行測試涵蓋到。
(2) 範例：src/api/modules/interceptors.js 的 % Stmts =
73.68，表示 73.68% 的敘述句有被執行到。
206
<!-- page 4 -->
「第三代醫療資訊系統建置案」開發規範
2、% Branch(Branches 覆蓋率)
(1) 說明：邏輯分支 (如 if, switch, ? : 三元運算子) 的
涵蓋率。
(2) 範例：interceptors.js 與 request.js 為 100%，表示
每個 if/else 等分支路徑都有被測試到。
3、% Funcs(Functions 覆蓋率)
(1) 說明：函式 有多少比例被執行測試。
(2) 範例：request.js 只有 33.33%，表示這個檔案的函
式中，只有三分之一被執行。
4、% Lines(行數涵蓋率)
(1) 說明：實際撰寫的程式碼行中，有多少被測試涵
蓋。
(2) 跟 % Stmts 類似，但更精確地按行來看。
(3) 範例：interceptors.js 有 73.68% 的程式碼行被涵
蓋。
5、Uncovered Line #s(未涵蓋的行號)
(1) 說明：新增一個檔案副檔名.spec.js,哪些程式碼行
沒有被測試執行到。
(2) 範例：登入頁新增一個檔案 LoginView.spec.js
//引入單元測試的 describe, it, expect
import { describe, it, expect } from 'vitest'
//引入單元測試的 mount
import { mount } from "@vue/test-utils";
//引入要單元測試的頁面
import Login from './LoginView.vue'
//有使用 pinia 狀態管理時必須引入 pinia 方式的單元測試
import { setActivePinia,createPinia } from "pinia";
207
<!-- page 5 -->
「第三代醫療資訊系統建置案」開發規範
//有使用 pinia 時必須引入 pinia 方式的單元測試
import { authStore } from '../../stores/auth.js'
import { usePageTagAndHtmlLangStore } from
'../../stores/titleTagAndHtmlLang.js'
describe('Login', () => {
beforeEach(() => {
setActivePinia(createPinia())
})
//登入頁的底圖是否綁訂到這正確位置
it('Login bgImg', () => {
const wrapper = mount(Login)
authStore()
usePageTagAndHtmlLangStore()
const bgImg = '/images/login_pc_bg.jpg'
expect (wrapper.html()).toContain(bgImg)
})
//使用 id 綁定密碼表單
it('Login userInput setValue ', async() => {
const wrapper = mount(Login)
authStore()
usePageTagAndHtmlLangStore()
const input = wrapper.find('#user_account')
await input.setValue('SA')
expect (input.element.value).toBe('SA')
})
//使用 data-test 綁定密碼表單
it('Login passwordInput setValue ', async() => {
const wrapper = mount(Login)
authStore()
usePageTagAndHtmlLangStore()
const input = wrapper.find('[data-test="user_password"]')
await input.setValue('123456')
expect (input.element.value).toEqual('123456')
})
})
208
<!-- page 6 -->
「第三代醫療資訊系統建置案」開發規範
(3) 元件的傳值:登入頁頁尾父對子傳值，新增一個檔
案 LoginFooter.spec.js
import { describe, it, expect } from 'vitest'
import { mount } from '@vue/test-utils'
import LoginFooter from './LoginFooter.vue'
describe('LoginFooter', async() =>
{
it('頁尾,由登入頁傳入的 sendCopyright', () => {
const props ={
sendCopyright:'版權所有 非經授權禁止轉載'
}
const wrapper = mount(LoginFooter,{props:props})
expect (wrapper.html()).toContain ('版權所有 非經授權禁止轉載')
})
it('登入頁尾,由登入頁傳入的 footerLists', () => {
const footerList =[
{ id: '001', subject: '隱私權政策', href: '' },
{ id: '002', subject: '資訊安全政策', href: '' },
{ id: '003', subject: '政府網站資料開放宣告', href: '' },
]
const props ={
sendFooterList:footerList
}
const wrapper = mount(LoginFooter,{props:props})
expect (wrapper.html()).toContain (footerList)
})
})
(4) Pinia 狀態管理單元測試 auth.spec.js
import { describe, it, expect } from 'vitest'
import { setActivePinia,createPinia } from "pinia";
import { authStore } from './auth.js'
import { mount } from "@vue/test-utils";
import { authStore } from './auth.js'
209
<!-- page 7 -->
「第三代醫療資訊系統建置案」開發規範
import LoginView from '../views/auth/LoginView.vue'
describe('Auth Store', () => {
beforeEach(() => {
setActivePinia(createPinia())
})
it('Auth Store isValidated', () => {
const store=authStore()
store.isValidated = false;
expect (store.isValidated).toBe (false)
})
it('Auth Store verificationCode', () => {
const store=authStore()
store.verificationCode = null
expect (store.verificationCode).toBe (null)
})
it('Auth Store userLength', () => {
const store=authStore()
store.userLength= 2
expect (store.userLength).toBe (2)
})
it('Click SubmitLogin When init loginInfo User is Empty', async()
=> {
const store=authStore()
const wrapper=mount(LoginView)
const loginInfo ={
user: '',
password: '',
group: '',
verification_code: '',
}
await wrapper.find('.btn-login').trigger('click')
const res=store.getToken(loginInfo)
const validateUser = store.validateUser(loginInfo.user)
expect (validateUser).toBe(false)
})
210
<!-- page 8 -->
「第三代醫療資訊系統建置案」開發規範
verification_code: '1234',
}
await wrapper.find('.btn-login').trigger('click')
const res=store.getToken(loginInfo)
store.isValidated = true;
expect (store.isValidated).toBe(true)
})
})

import { describe, it, expect } from 'vitest'
import { setActivePinia,createPinia } from "pinia";
import { authStore } from './auth.js'
import { mount } from "@vue/test-utils";
import { authStore } from './auth.js'
import LoginView from '../views/auth/LoginView.vue'
describe('Auth Store', () => {
beforeEach(() => {
setActivePinia(createPinia())
})
it('Auth Store isValidated', () => {
const store=authStore()
store.isValidated = false;
expect (store.isValidated).toBe (false)
})
it('Auth Store verificationCode', () => {
const store=authStore()
store.verificationCode = null
expect (store.verificationCode).toBe (null)
})
it('Auth Store userLength', () => {
const store=authStore()
store.userLength= 2
expect (store.userLength).toBe (2)
})
it('Click SubmitLogin When init loginInfo User is Empty', async()
=> {
const store=authStore()
212
<!-- page 9 -->
「第三代醫療資訊系統建置案」開發規範
const wrapper=mount(LoginView)
const loginInfo ={
user: '',
password: '',
group: '',
verification_code: '',
}
await wrapper.find('.btn-login').trigger('click')
const res=store.getToken(loginInfo)
const validateUser = store.validateUser(loginInfo.user)
expect (validateUser).toBe(false)
})
it('Click SubmitLogin When init loginInfo async() => {
const store=authStore()
Password is Empty',
const wrapper=mount(LoginView)
const loginInfo ={
user: '',
password: '',
group: '',
verification_code: '',
}
await wrapper.find('.btn-login').trigger('click')
const res=store.getToken(loginInfo)
const validatePassword =
store.validatePassword(loginInfo.password)
expect (validatePassword).toBe(false)
})
it('Click SubmitLogin When init loginInfo Empty', async() => {
const store=authStore()
ValidateVerification is
const wrapper=mount(LoginView)
const loginInfo ={
user: '',
password: '',
group: '',
verification_code: '',
}
await wrapper.find('.btn-login').trigger('click')
213
<!-- page 10 -->
「第三代醫療資訊系統建置案」開發規範
"result": true,
"roles": ["ADMIN", "USER"]
}
import { describe, it, expect, afterEach, beforeAll, afterAll, beforeEach }
from 'vitest'
import { setupServer } from 'msw/node'
import { mount } from "@vue/test-utils"
import GuessAge from "../GuessAge.vue"
//引入 Api 模擬
import { restHandlers } from "../../mocks/ requestInput.json ";
const server = setupServer(...restHandlers)
// 在所有測試之前啟動伺服器
beforeAll(() => server.listen({ onUnhandledRequest: 'error' }))
// 所有測試後關閉伺服器
afterAll(() => server.close())
// 每次測試後重置處理程序“對於測試隔離很重要”
afterEach(() => server.resetHandlers())
describe('GuessAge', () =>
{
let wrapper
const title = 'Guess User Age App'
if (typeof document !== 'undefined') {
beforeEach(() =>
{
wrapper = mount(GuessAge, {
props: {
title
}
})
})
}
it("測試 GuessAge 元件 props title", async () =>
{
if (typeof document !== 'undefined') {
expect(wrapper.find('[data-test="title"]').text()).toBe(title);
}
});
215
<!-- page 11 -->
「第三代醫療資訊系統建置案」開發規範
it("測試資料是否為函數", () =>
{
expect(typeof GuessAge.data).toBe("undefined");
});
it('快照 UI 測試', () =>
{
if (typeof document !== 'undefined') {
const wrapper = mount(GuessAge, {});
expect(wrapper.text()).toMatchSnapshot()
}
})
it("找到按鈕", () =>
{
if (typeof document !== 'undefined') {
expect(wrapper.find('[data-
test="getAge"]').exists()).toBe(true);
}
});
it("按鈕點擊", async () =>
{
if (typeof document !== 'undefined') {
const ac = await wrapper.get('[data-
test="getAge"]').trigger("click")
expect(wrapper.vm.search).toEqual("")
}
})
})
(四) 在生產環境刪除 data-
* attribute
在 vite.config.js 設定中
const isProd = process.env.NODE_ENV === 'production'
const removeDataTestAttrs = (node) => {
const NodeTypes = Object.freeze({
ELEMENT: 1,
ATTRIBUTE: 6,
})
216

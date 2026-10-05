---
source: docs/assets/rea/2026-10-05-nhia-vm-nginx-default.conf
sha256: 7efcb8545bd8d1182ec13113caacb6a18fe165e981135be35af6cd8e2928fa54
bytes: 763
extractor: verbatim
status: ok
received: Default.conf
---
server {
    listen 80;
    listen 443 ssl;

    server_name med3rearuledev.intra.nhi.gov.tw;

    ssl_certificate     /etc/nginx/ssl/server.crt;
    ssl_certificate_key /etc/nginx/ssl/server.key;

    # Timeout 設定（10 分鐘）
    proxy_connect_timeout 600s;
    proxy_send_timeout 600s;
    proxy_read_timeout 600s;

    # 前端目前先不使用
    location / {
        return 404;
    }

    # 後端 API 與 Swagger
    location ~ ^/(api|swagger)(/|$) {
        proxy_pass http://nhi-claimvalidator:8080;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

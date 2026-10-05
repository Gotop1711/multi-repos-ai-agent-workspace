---
source: docs/assets/rea/2026-10-05-nhia-vm-docker-compose.yml
sha256: ea16c0109c8e41ac5d18bea285cf27e650a675ee32bc55d188a011668141ddd3
bytes: 2669
extractor: verbatim
status: ok
received: docker-compose.yml
secret_review: waived 2026-10-05
---
services:
  nhi-mongo:
    image: mongo:8.0
    container_name: nhi-mongo
    restart: unless-stopped

    # 啟動時由環境變數產生 keyfile（避免 Windows 掛載權限問題），再交給官方 entrypoint
    entrypoint:
      - bash
      - -c
      - |
        echo "$$MONGO_KEYFILE_CONTENT" > /tmp/keyfile
        chmod 400 /tmp/keyfile
        chown mongodb:mongodb /tmp/keyfile
        exec docker-entrypoint.sh mongod --replSet rs0 --keyFile /tmp/keyfile --bind_ip_all

    environment:
      MONGO_INITDB_ROOT_USERNAME: nhi_admin
      MONGO_INITDB_ROOT_PASSWORD: ${MONGO_PASSWORD}
      MONGO_KEYFILE_CONTENT: ${MONGO_KEYFILE_CONTENT}

    ports:
      - "27017:27017"

    volumes:
      - mongo-nhi-data:/data/db

    networks:
      - med3_cluster_network


  nhi-claimvalidator:
    image: registry.transportdata.tw/nhi3rdgeneration/claimvalidator/kernel/nhi-claimvalidator:${IMAGE_TAG:-dev}
    container_name: nhi-claimvalidator
    restart: unless-stopped

    depends_on:
      - nhi-mongo

    ports:
      - "8080:8080"

    environment:
      ConnectionStrings__MongoDb: mongodb://nhi_admin:${MONGO_PASSWORD}@nhi-mongo:27017/?authSource=admin&replicaSet=rs0
      ConnectionStrings__OracleDb: ${ORACLE_CONNECTION}

    networks:
      - med3_cluster_network


  nhi-claimvalidator-etl:
    image: registry.transportdata.tw/nhi3rdgeneration/claimvalidator/kernel/nhi-claimvalidator-etl:${IMAGE_TAG:-dev}
    container_name: nhi-claimvalidator-etl
    restart: unless-stopped

    depends_on:
      - nhi-mongo

    environment:
      ConnectionStrings__MongoDb: mongodb://nhi_admin:${MONGO_PASSWORD}@nhi-mongo:27017/?authSource=admin&replicaSet=rs0
      ConnectionStrings__OracleDb: ${ORACLE_CONNECTION}

    networks:
      - med3_cluster_network


  nginx:
    image: nginx:1.27
    container_name: nhi-nginx
    restart: unless-stopped

    # Nginx 啟動前，先確保 API Container 已建立
    depends_on:
      - nhi-claimvalidator

    # 對外提供 HTTP / HTTPS
    ports:
      - "80:80"
      - "443:443"

    # 掛載 Nginx 設定檔與 SSL 憑證
    volumes:
      - ./Nginx/Default.conf:/etc/nginx/conf.d/default.conf:ro
      - ./Nginx/Ssl:/etc/nginx/ssl:ro

    # 與 API 使用同一個 Docker Network，讓 Nginx 可透過 Container Name 存取 API
    networks:
      - med3_cluster_network


volumes:
  mongo-nhi-data:
    # 測試機既有 volume；若要沿用請改為 external: true
    name: mongo-nhi-data


networks:
  med3_cluster_network:
    # 測試機既有 network，由外部建立
    external: true

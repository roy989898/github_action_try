# GitHub Action: 自動構建並推送 Docker 映像檔

這個專案配置了 GitHub Action，每當你將程式碼推送到 `master` 分支時，它會自動構建 Docker 映像檔並將其推送到 Docker Hub。

## 🚀 工作流程功能

1.  **自動版本編號**：使用 GitHub 內建的 `run_number` 自動生成版本標籤（例如 `v1`, `v2`, `v3`）。
2.  **最新版本標籤**：每次構建也會同時更新 `latest` 標籤。
3.  **Docker Hub 整合**：自動登錄並推送到指定的 Docker Hub 儲存庫。

## 🛠️ 配置說明 (`docker-publish.yml`)

### 關鍵步驟解析

*   **`docker/metadata-action`**:
    *   這步驟負責「計算」出映像檔的所有標籤。
    *   它生成 `v${{ github.run_number }}`（自動遞增的版本號）和 `latest`。
*   **`docker/build-push-action`**:
    *   這步驟實際執行 `docker build` 和 `docker push`。
    *   它使用上一步生成的標籤進行推送。

## 🔐 必要設定 (GitHub Secrets)

在 GitHub 儲存庫的 **Settings > Secrets and variables > Actions** 中，你**必須**新增以下兩個 Secrets：

1.  `DOCKERHUB_USERNAME`: 你的 Docker Hub 使用者名稱。
2.  `DOCKERHUB_TOKEN`: 你的 Docker Hub 個人存取權杖 (Personal Access Token)。

## 📦 如何觸發

只要執行以下 Git 操作，就會自動啟動流程：

```bash
git add .
git commit -m "更新 FastAPI 應用程式"
git push origin master
```

## 🏠 本地測試

如果你想在本地測試 Docker 映像檔，可以使用：

```bash
# 構建映像檔
docker build -t fastapi-app .

# 運行容器
docker run -p 8000:8000 fastapi-app
```

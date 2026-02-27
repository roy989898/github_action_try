# GitHub Action 逐行詳細解釋 (`docker-publish.yml`)

這份文件詳細解釋了 `.github/workflows/docker-publish.yml` 檔案中的每一行程式碼及其功能。

```yaml
name: Build and Push Docker Image  # Workflow 的名稱，會顯示在 GitHub Actions 的介面中。

on:                                # 定義「觸發條件」。
  push:                            # 當有程式碼「推送到 (push)」儲存庫時觸發。
    branches:                      # 指定哪些分支會觸發此 Workflow。
      - master                     # 只有推送到 master 分支時才會執行。

jobs:                              # 定義要執行的任務 (Job) 集合。
  push_to_registry:                # 任務的唯一 ID 名稱。
    name: Push Docker image to Docker Hub # 在 GitHub 介面上顯示的任務標題。
    runs-on: ubuntu-latest         # 指定執行環境，這裡使用 GitHub 提供的最新版 Ubuntu 虛擬機。
    steps:                         # 任務中具體的執行步驟列表。
      - name: Check out the repo    # 步驟名稱：取得原始碼。
        uses: actions/checkout@v4  # 使用官方 Action 將儲存庫的程式碼複製到執行環境中。

      - name: Log in to Docker Hub  # 步驟名稱：登入 Docker Hub。
        uses: docker/login-action@v3 # 使用 Docker 官方提供的登入 Action。
        with:                      # 設定登入所需的參數。
          username: ${{ secrets.DOCKERHUB_USERNAME }} # 從 GitHub Secrets 安全地讀取 Docker Hub 帳號。
          password: ${{ secrets.DOCKERHUB_TOKEN }}    # 從 GitHub Secrets 安全地讀取 Docker Hub 存取權杖 (Token)。

      - name: Extract metadata (tags, labels) for Docker # 步驟名稱：準備 Docker 標籤與元數據。
        id: meta                   # 為此步驟設定 ID，以便後面的步驟可以引用其產生的結果。
        uses: docker/metadata-action@v5 # 使用專門處理 Docker 標籤 (Tags) 和標籤 (Labels) 的 Action。
        with:                      # 設定標籤規則。
          images: ${{ secrets.DOCKERHUB_USERNAME }}/fastapi-hello-world # 定義映像檔在 Docker Hub 的完整名稱。
          tags: |                  # 定義要生成的標籤規則。
            type=raw,value=v${{ github.run_number }} # 使用 GitHub 內建計數器生成自動遞增版本號（如 v1, v2...）。
            type=raw,value=latest  # 同時生成一個名為 latest 的標籤，代表最新版本。

      - name: Build and push Docker image # 步驟名稱：執行構建並推送。
        uses: docker/build-push-action@v5 # 使用 Docker 官方提供的構建與推送 Action。
        with:                      # 設定構建與推送的參數。
          context: .               # 指定 Docker 構建的上下文路徑（這裡是專案根目錄）。
          push: true               # 設定為 true，表示構建完成後立即推送到 Docker Hub。
          tags: ${{ steps.meta.outputs.tags }}     # 引用 id 為 meta 的步驟所計算出的所有標籤（如 v1 和 latest）。
          labels: ${{ steps.meta.outputs.labels }} # 引用 id 為 meta 的步驟所生成的元數據標籤。
```

## 💡 核心概念

1.  **GitHub Secrets**: 透過 `${{ secrets.XXX }}` 語法引用，確保敏感資料（如密碼、Token）不會出現在程式碼中。
2.  **github.run_number**: 這是 GitHub 自動提供的變數，代表該工作流執行的序號，非常適合用作簡單的版本控制。
3.  **Step Outputs**: 透過 `steps.<ID>.outputs` 可以取得特定步驟產生的資訊，達成步驟間的資料傳遞。

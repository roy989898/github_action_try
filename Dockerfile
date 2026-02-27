# 使用輕量級 Python 鏡像
FROM python:3.12-slim

# 設定工作目錄
WORKDIR /app

# 安裝 uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# 複製專案文件
COPY pyproject.toml .
COPY uv.lock* .
COPY main.py .

# 使用 uv 同步環境
RUN uv sync --frozen --no-cache

# 暴露端口
EXPOSE 8000

# 啟動應用程式
CMD ["uv", "run", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]

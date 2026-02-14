#!/bin/bash

# .envファイルを読み込む（Raycast環境でも動作するように）
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$SCRIPT_DIR/.env"

if [ -f "$ENV_FILE" ]; then
    # コメント行と空行をスキップして、環境変数をexportする
    while IFS='=' read -r key value || [ -n "$key" ]; do
        # コメント行と空行をスキップ
        if [[ ! "$key" =~ ^[[:space:]]*# ]] && [ -n "$key" ]; then
            # 前後の空白を削除
            key=$(echo "$key" | xargs)
            value=$(echo "$value" | xargs)
            # 引用符を削除（既に引用符で囲まれている場合）
            value="${value%\"}"
            value="${value#\"}"
            value="${value%\'}"
            value="${value#\'}"
            # exportする
            export "$key=$value"
        fi
    done < "$ENV_FILE"
fi
#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Generate Email Alias
# @raycast.mode compact

# Optional parameters:
# @raycast.icon ✉️

# Documentation:
# @raycast.description メールアドレスに日付付きエイリアスを生成してクリップボードにコピー
# @raycast.author suama

# .env読み込み
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/load_env.sh"

# .envからメールアドレスを取得
if [[ -z "$EMAIL_ALIAS_BASE" ]]; then
    echo "EMAIL_ALIAS_BASE が .env に設定されていません"
    exit 1
fi

# メールアドレスをローカルパートとドメインに分割
LOCAL="${EMAIL_ALIAS_BASE%%@*}"
DOMAIN="${EMAIL_ALIAS_BASE#*@}"

if [[ "$LOCAL" == "$EMAIL_ALIAS_BASE" ]] || [[ -z "$DOMAIN" ]]; then
    echo "無効なメールアドレス: $EMAIL_ALIAS_BASE"
    exit 1
fi

# 今日の日付(yyyymmdd)
TODAY=$(date +%Y%m%d)

# カウンターファイル（日付ごとにリセット）
COUNTER_FILE="/tmp/raycast_email_alias_${TODAY}"

# カウンターを読み取ってインクリメント
if [[ -f "$COUNTER_FILE" ]]; then
    NUM=$(<"$COUNTER_FILE")
    NUM=$((NUM + 1))
else
    NUM=1
fi

# カウンターを保存
echo "$NUM" > "$COUNTER_FILE"

# エイリアスメールアドレスを生成
ALIAS="${LOCAL}+${TODAY}-${NUM}@${DOMAIN}"

# クリップボードにコピー
echo -n "$ALIAS" | pbcopy

echo "$ALIAS をクリップボードにコピーしました"
exit 0

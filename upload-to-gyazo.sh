#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Upload to Gyazo
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 📸

# Documentation:
# @raycast.author suama
# @raycast.description クリップボードの画像をGyazoにアップロードして、URLをクリップボードにコピーします。

# load_env.shを読み込む
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/load_env.sh"

# アクセストークンを取得（1Password or 環境変数）
if [ -n "$GYAZO_1PASSWORD_COMMAND" ]; then
    ACCESS_TOKEN=$($GYAZO_1PASSWORD_COMMAND 2>/dev/null)
fi
ACCESS_TOKEN="${ACCESS_TOKEN:-$GYAZO_ACCESS_TOKEN}"

if [ -z "$ACCESS_TOKEN" ]; then
    echo "❌ アクセストークンが設定されていません"
    exit 1
fi

# 一時ファイル
TEMP_FILE=$(mktemp /tmp/gyazo_XXXXXX.png)
trap 'rm -f "$TEMP_FILE"' EXIT

# クリップボードから画像を保存
osascript -e '
try
    set d to the clipboard as «class PNGf»
    set f to open for access POSIX file "'"$TEMP_FILE"'" with write permission
    write d to f
    close access f
on error
    error number 1
end try' 2>/dev/null

if [ $? -ne 0 ] || [ ! -s "$TEMP_FILE" ]; then
    echo "❌ クリップボードに画像がありません"
    exit 1
fi

# Gyazoにアップロード
url=$(curl -s --compressed -X POST https://upload.gyazo.com/api/upload \
    -H "Authorization: Bearer $ACCESS_TOKEN" \
    -F "imagedata=@${TEMP_FILE};type=image/png" \
    | sed -n 's/.*"url":"\([^"]*\)".*/\1/p')

if [ -n "$url" ]; then
    printf '%s' "$url" | pbcopy
    echo "✅ $url"
else
    echo "❌ アップロード失敗"
    exit 1
fi
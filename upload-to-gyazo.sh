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
if [ -n "$GYAZO_1PASSWORD_PATH" ]; then
    ACCESS_TOKEN=$(op read "$GYAZO_1PASSWORD_PATH" 2>/dev/null)
fi

if [ -z "$ACCESS_TOKEN" ]; then
    ACCESS_TOKEN="${GYAZO_ACCESS_TOKEN}"
fi

if [ -z "$ACCESS_TOKEN" ]; then
    echo "❌ アクセストークンが設定されていません"
    echo "スクリプトと同じディレクトリに .env ファイルを作成してください："
    exit 1
fi

# 一時ファイルを作成
TEMP_FILE=$(mktemp /tmp/gyazo_upload_XXXXXX)

# クリップボードから画像を保存
osascript <<EOF
try
    set png_data to the clipboard as «class PNGf»
    set the_file to open for access POSIX file "$TEMP_FILE" with write permission
    write png_data to the_file
    close access the_file
on error
    error "クリップボードに画像がありません"
end try
EOF

if [ $? -ne 0 ]; then
    echo "❌ クリップボードに画像がありません"
    exit 1
fi

# Gyazoにアップロード
response=$(curl -s -X POST https://upload.gyazo.com/api/upload \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -F imagedata=@"$TEMP_FILE")

# URLを取得
url=$(echo "$response" | grep -o '"url":"[^"]*"' | cut -d'"' -f4)

# 一時ファイル削除
rm "$TEMP_FILE"

if [ -n "$url" ]; then
    echo "$url" | pbcopy
    echo "✅ $url"
else
    echo "❌ アップロード失敗"
    exit 1
fi
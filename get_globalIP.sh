#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title get_globalIP
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.description GET Global IP Address
# @raycast.author suama

# グローバルIPアドレスを外部サービスから取得する関数
get_ip() {
    local ip
    for service in "https://ipinfo.io/ip" "https://ifconfig.me" "https://icanhazip.com"; do
        ip=$(curl -s $service)
        if [[ -n "$ip" ]]; then
            echo $ip
            return 0
        fi
    done
    return 1
}

# グローバルIPアドレスを取得
IP=$(get_ip)

if [[ -z "$IP" ]]; then
    echo "Failed to retrieve IP address from all services."
    exit 1
fi

# 取得したグローバルIPアドレスをクリップボードにコピー
echo -n "$IP" | pbcopy

# 通知を表示
echo "Your global IP address ($IP) has been copied to the clipboard."

# Raycastウィンドウを閉じる
exit 0
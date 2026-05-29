#!/bin/bash
set -euo pipefail

# The script expects the message to be passed as the first argument ($1)
MESSAGE="$1"

if [ -z "$MESSAGE" ]; then
    echo "Error: No message provided for Telegram notification."
    exit 1
fi

curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
    --data-urlencode "chat_id=$TELEGRAM_CHAT_ID" \
    --data-urlencode "text=$MESSAGE" > /dev/null

echo "Telegram notification sent successfully."
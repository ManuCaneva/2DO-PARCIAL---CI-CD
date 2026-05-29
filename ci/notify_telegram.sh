#!/bin/bash
set -euo pipefail

# Argument 1: The message to send to Telegram
MESSAGE="$1"

if [ -z "$TELEGRAM_TOKEN" ] || [ -z "$TELEGRAM_CHAT_ID" ]; then
    echo "Warning: Telegram credentials not found. Skipping Telegram notification."
    exit 0
fi

echo "Sending notification to Telegram..."

# Send the message via Telegram API
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" -X POST \
  "https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage" \
  -d chat_id="${TELEGRAM_CHAT_ID}" \
  -d text="${MESSAGE}" \
  -d parse_mode="HTML")

if [ "$HTTP_STATUS" -ne 200 ]; then
    echo "Error: Failed to send Telegram message. HTTP Status: $HTTP_STATUS"
    exit 1
fi

echo "Telegram notification sent successfully."
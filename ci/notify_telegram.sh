#!/bin/bash
set -euo pipefail

MESSAGE="${1:-}"
FILE_PATH="${2:-}"

TELEGRAM_TOKEN="${TELEGRAM_TOKEN:-}"
TELEGRAM_CHAT_ID="${TELEGRAM_CHAT_ID:-}"

if [ -z "$TELEGRAM_TOKEN" ] || [ -z "$TELEGRAM_CHAT_ID" ]; then
    echo "Warning: Telegram credentials not found. Skipping Telegram notification."
    exit 0
fi

CURL_OPTS=(-s -o /dev/null -w "%{http_code}" --connect-timeout 10 --max-time 30)

echo "Sending notification to Telegram..."

MESSAGE_NL="${MESSAGE//'%0A'/$'\n'}"

if [ -n "$MESSAGE_NL" ]; then
    HTTP_STATUS=$(curl "${CURL_OPTS[@]}" -X POST \
      "https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage" \
      --data-urlencode "chat_id=${TELEGRAM_CHAT_ID}" \
      --data-urlencode "text=${MESSAGE_NL}" \
      --data-urlencode "parse_mode=HTML")

    if [ "$HTTP_STATUS" -ne 200 ]; then
        echo "Error: Failed to send Telegram message. HTTP Status: $HTTP_STATUS"
        exit 1
    fi
    echo "Telegram message sent successfully."
fi

if [ -n "$FILE_PATH" ] && [ -f "$FILE_PATH" ]; then
    HTTP_STATUS=$(curl "${CURL_OPTS[@]}" -X POST \
      "https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendDocument" \
      -F chat_id="${TELEGRAM_CHAT_ID}" \
      -F "document=@$FILE_PATH")

    if [ "$HTTP_STATUS" -ne 200 ]; then
        echo "Error: Failed to send Telegram document. HTTP Status: $HTTP_STATUS"
        exit 1
    fi
    echo "Telegram document sent successfully."
fi

echo "Telegram notification completed."
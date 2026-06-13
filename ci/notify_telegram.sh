#!/bin/bash
set -euo pipefail

# Argument 1: The message to send to Telegram
# Argument 2: Optional path to a file to send as a document
MESSAGE="${1:-}"
FILE_PATH="${2:-}"

# Convert %0A to real newlines (works for both -F multipart and --data-urlencode)
MESSAGE="${MESSAGE//'%0A'/$'\n'}"

if [ -z "$TELEGRAM_TOKEN" ] || [ -z "$TELEGRAM_CHAT_ID" ]; then
    echo "Warning: Telegram credentials not found. Skipping Telegram notification."
    exit 0
fi

echo "Sending notification to Telegram..."

# If both a file and a message exist, send them together in one document with caption
if [ -n "$FILE_PATH" ] && [ -f "$FILE_PATH" ]; then
    if [ -n "$MESSAGE" ]; then
        HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" -X POST \
          "https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendDocument" \
          -F chat_id="${TELEGRAM_CHAT_ID}" \
          -F "document=@$FILE_PATH" \
          -F "caption=${MESSAGE}" \
          -F parse_mode="HTML")
    else
        HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" -X POST \
          "https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendDocument" \
          -F chat_id="${TELEGRAM_CHAT_ID}" \
          -F "document=@$FILE_PATH")
    fi

    if [ "$HTTP_STATUS" -ne 200 ]; then
        echo "Error: Failed to send Telegram document. HTTP Status: $HTTP_STATUS"
        exit 1
    fi
    echo "Telegram document sent successfully."
    echo "Telegram notification completed."
    exit 0
fi

# No file, send message only
if [ -n "$MESSAGE" ]; then
    HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" -X POST \
      "https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage" \
      --data-urlencode "chat_id=${TELEGRAM_CHAT_ID}" \
      --data-urlencode "text=${MESSAGE}" \
      --data-urlencode "parse_mode=HTML")

    if [ "$HTTP_STATUS" -ne 200 ]; then
        echo "Error: Failed to send Telegram message. HTTP Status: $HTTP_STATUS"
        exit 1
    fi
    echo "Telegram message sent successfully."
fi

echo "Telegram notification completed."
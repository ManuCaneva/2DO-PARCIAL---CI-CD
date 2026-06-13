#!/bin/bash
set -euo pipefail

# Argument 1: The message to send to Telegram
# Argument 2: Optional path to a file to send as a document
MESSAGE="${1:-}"
FILE_PATH="${2:-}"

if [ -z "$TELEGRAM_TOKEN" ] || [ -z "$TELEGRAM_CHAT_ID" ]; then
    echo "Warning: Telegram credentials not found. Skipping Telegram notification."
    exit 0
fi

echo "Sending notification to Telegram..."

# Send the message via Telegram API
if [ -n "$MESSAGE" ]; then
    HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" -X POST \
      "https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage" \
      -d chat_id="${TELEGRAM_CHAT_ID}" \
      -d text="${MESSAGE}" \
      -d parse_mode="HTML")

    if [ "$HTTP_STATUS" -ne 200 ]; then
        echo "Error: Failed to send Telegram message. HTTP Status: $HTTP_STATUS"
        exit 1
    fi
    echo "Telegram message sent successfully."
fi

# Send a file as a document if provided
if [ -n "$FILE_PATH" ] && [ -f "$FILE_PATH" ]; then
    DOC_STATUS=$(curl -s -o /dev/null -w "%{http_code}" -X POST \
      "https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendDocument" \
      -F chat_id="${TELEGRAM_CHAT_ID}" \
      -F "document=@$FILE_PATH")

    if [ "$DOC_STATUS" -ne 200 ]; then
        echo "Error: Failed to send Telegram document. HTTP Status: $DOC_STATUS"
        exit 1
    fi
    echo "Telegram document sent successfully."
fi

echo "Telegram notification completed."
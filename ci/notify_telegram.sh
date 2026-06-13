#!/bin/bash
set -euo pipefail

# Argument 1: The message to send to Telegram
# Argument 2: Optional path to a file to send as a document
MESSAGE="${1:-}"
FILE_PATH="${2:-}"

# Safe access to env vars (protects against set -u)
TELEGRAM_TOKEN="${TELEGRAM_TOKEN:-}"
TELEGRAM_CHAT_ID="${TELEGRAM_CHAT_ID:-}"

if [ -z "$TELEGRAM_TOKEN" ] || [ -z "$TELEGRAM_CHAT_ID" ]; then
    echo "Warning: Telegram credentials not found. Skipping Telegram notification."
    exit 0
fi

# Curl timeout settings: connect timeout 10s, max total time 30s
CURL_OPTS=(-s -o /dev/null -w "%{http_code}" --connect-timeout 10 --max-time 30)

echo "Sending notification to Telegram..."

# Convert %0A to real newlines for --data-urlencode (sendMessage)
# Keep original %0A for -F multipart (caption in sendDocument) 
MESSAGE_NL="${MESSAGE//'%0A'/$'\n'}"

# If both a file and a message exist, try sending as document with caption
if [ -n "$FILE_PATH" ] && [ -f "$FILE_PATH" ]; then
    if [ -n "$MESSAGE" ]; then
        HTTP_STATUS=$(curl "${CURL_OPTS[@]}" -X POST \
          "https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendDocument" \
          -F chat_id="${TELEGRAM_CHAT_ID}" \
          -F "document=@$FILE_PATH" \
          -F "caption=${MESSAGE_NL}" \
          -F parse_mode="HTML")

        if [ "$HTTP_STATUS" -eq 200 ]; then
            echo "Telegram document with caption sent successfully."
            echo "Telegram notification completed."
            exit 0
        fi

        echo "Warning: sendDocument with caption failed (HTTP $HTTP_STATUS). Falling back to separate messages..."
    fi

    # Fallback: send document without caption
    HTTP_STATUS=$(curl "${CURL_OPTS[@]}" -X POST \
      "https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendDocument" \
      -F chat_id="${TELEGRAM_CHAT_ID}" \
      -F "document=@$FILE_PATH")

    if [ "$HTTP_STATUS" -ne 200 ]; then
        echo "Error: Failed to send Telegram document. HTTP Status: $HTTP_STATUS"
        exit 1
    fi
    echo "Telegram document sent successfully."

    # Fallback: send message separately (if there was a message)
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

    echo "Telegram notification completed."
    exit 0
fi

# No file, send message only
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

echo "Telegram notification completed."
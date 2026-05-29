#!/bin/bash
set -euo pipefail

# Argument 1: The ID of the Trello List (Column) to move the card to
TARGET_LIST_ID="$1"

# Argument 2: (Optional) The message or AI analysis to inject into the card
CARD_COMMENT="${2:-}"

# 1. Define the Card ID
CARD_ID="6a199615fb12369f8e263e23"

if [ -z "$CARD_ID" ]; then
    echo "Error: No Trello card ID found in commit message."
    exit 1
fi

echo "Updating Trello card: $CARD_ID"

# 2. Move the card to the specified list
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" --request PUT \
  --url "https://api.trello.com/1/cards/$CARD_ID" \
  --data "key=$TRELLO_API_KEY" \
  --data "token=$TRELLO_TOKEN" \
  --data "idList=$TARGET_LIST_ID")

if [ "$HTTP_STATUS" -ne 200 ]; then
    echo "Error moving Trello card. HTTP Status: $HTTP_STATUS"
    exit 1
fi

# 3. If a comment was provided (like Gemini analysis), inject it into the card
if [ -n "$CARD_COMMENT" ]; then
    COMMENT_STATUS=$(curl -s -o /dev/null -w "%{http_code}" --request POST \
      --url "https://api.trello.com/1/cards/$CARD_ID/actions/comments" \
      --data "key=$TRELLO_API_KEY" \
      --data "token=$TRELLO_TOKEN" \
      --data-urlencode "text=$CARD_COMMENT")
      
    if [ "$COMMENT_STATUS" -ne 200 ]; then
        echo "Error injecting comment to Trello. HTTP Status: $COMMENT_STATUS"
        exit 1
    fi
    echo "Comment injected successfully."
fi

echo "Trello update completed."
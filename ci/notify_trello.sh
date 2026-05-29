#!/bin/bash
set -euo pipefail

TARGET_LIST_ID="$1"
CARD_COMMENT="${2:-}"
BOARD_ID="6a1995863d95c55fa775c20f"

# 1. Extract the commit message and the tag (e.g., [2DOP-01])
COMMIT_MSG=$(git log -1 --pretty=%B | head -n 1)
CARD_TAG=$(echo "$COMMIT_MSG" | grep -oE '\[[A-Za-z0-9-]+\]' || true)

if [ -z "$CARD_TAG" ]; then
    echo "Warning: No tag found in commit message. Skipping Trello update."
    exit 0
fi

echo "Searching Trello board for card with tag: $CARD_TAG..."

# 2. Search for the card ID using the Trello API
SEARCH_RESPONSE=$(curl -s -G \
  --url "https://api.trello.com/1/search" \
  --data-urlencode "query=$CARD_TAG" \
  --data "idBoards=$BOARD_ID" \
  --data "modelTypes=cards" \
  --data "card_fields=id" \
  --data "key=$TRELLO_API_KEY" \
  --data "token=$TRELLO_TOKEN")

CARD_ID=$(echo "$SEARCH_RESPONSE" | jq -r '.cards[0].id // empty' || true)

if [ "$CARD_ID" == "null" ] || [ -z "$CARD_ID" ]; then
    echo "Error: No card found with tag $CARD_TAG on this board."
    exit 1
fi

echo "Card found (ID: $CARD_ID). Updating location..."

# 3. Move the card to the target list (Doing, Done, or Failed)
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" --request PUT \
  --url "https://api.trello.com/1/cards/$CARD_ID" \
  --data "key=$TRELLO_API_KEY" \
  --data "token=$TRELLO_TOKEN" \
  --data "idList=$TARGET_LIST_ID")

if [ "$HTTP_STATUS" -ne 200 ]; then
    echo "Error: Failed to move Trello card. HTTP Status: $HTTP_STATUS"
    exit 1
fi

# 4. Inject a comment if one was provided (e.g., failure details)
if [ -n "$CARD_COMMENT" ]; then
    COMMENT_STATUS=$(curl -s -o /dev/null -w "%{http_code}" --request POST \
      --url "https://api.trello.com/1/cards/$CARD_ID/actions/comments" \
      --data "key=$TRELLO_API_KEY" \
      --data "token=$TRELLO_TOKEN" \
      --data-urlencode "text=$CARD_COMMENT")
      
    if [ "$COMMENT_STATUS" -ne 200 ]; then
        echo "Error: Failed to add comment. HTTP Status: $COMMENT_STATUS"
        exit 1
    fi
    echo "Comment added successfully."
fi

echo "Trello update completed successfully."
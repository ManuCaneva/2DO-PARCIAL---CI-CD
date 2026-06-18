#!/bin/bash
set -euo pipefail

echo "Starting failure analysis..."

# Check if the error file exists. If not, it means the pipeline failed BEFORE the test.
if [ ! -f "ci/error_output.txt" ]; then
    echo "Warning: Error output file not found. Pipeline crashed before tests ran."
    ERROR_TEXT="Infrastructure or Pre-test failure."
    AI_EXPLANATION="AI analysis unavailable (missing error log)."
else
    ERROR_TEXT=$(cat ci/error_output.txt)
    echo "Requesting AI analysis..."
    # Capture AI response, allowing graceful failure if the API call drops
    AI_EXPLANATION=$(./ci/ask_gemini.sh || echo "AI analysis request failed.")
fi

echo "Error detected: $ERROR_TEXT"
echo "AI Explanation: $AI_EXPLANATION"

FIX_PLAN_FILE="ci/fix-plan.md"
FIX_PLAN_ARGS=""
FIX_PLAN_NOTE=""

if [ -f "$FIX_PLAN_FILE" ]; then
    echo "Fix plan generated at $FIX_PLAN_FILE"
    FIX_PLAN_ARGS="$FIX_PLAN_FILE"
    FIX_PLAN_NOTE="%0A  • <b>Fix plan</b>: <code>fix-plan.md</code> attached"
fi

# Move the card to Failed, inject AI explanation, and optionally attach fix-plan
TRELLO_COMMENT="❌ [BUILD FAILED]

  AI : $AI_EXPLANATION

  • Commit: $SEMAPHORE_GIT_SHA"
if [ -n "$FIX_PLAN_ARGS" ]; then
    TRELLO_COMMENT="$TRELLO_COMMENT

  • Fix plan: fix-plan.md attached"
fi
./ci/notify_trello.sh "$TRELLO_REVIEW_LIST_ID" "$TRELLO_COMMENT" "$FIX_PLAN_ARGS"

# Send formatted alert to Telegram including the AI explanation, and optionally the fix-plan document
SAFE_AI_EXPLANATION=$(echo "$AI_EXPLANATION" | sed 's/</[/g; s/>/]/g')
./ci/notify_telegram.sh " <b>[BUILD FAILED]</b>%0A%0A  <b>Status</b> : Contract violated ❌%0A  <b>AI</b>      : <i>$SAFE_AI_EXPLANATION</i>%0A%0A  • <b>Commit</b>: <code>$SEMAPHORE_GIT_SHA</code>${FIX_PLAN_NOTE}" "$FIX_PLAN_ARGS"

echo "Failure processed and notifications sent."
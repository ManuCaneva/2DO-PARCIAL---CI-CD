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

# Move the card to Failed and inject AI explanation
./ci/notify_trello.sh "$TRELLO_REVIEW_LIST_ID" "Build FAILED. AI Analysis: $AI_EXPLANATION"

# Send formatted alert to Telegram including the AI explanation
SAFE_AI_EXPLANATION=$(echo "$AI_EXPLANATION" | sed 's/</[/g; s/>/]/g')
./ci/notify_telegram.sh "<b>🚨Build FAILED!</b>%0AContract violated in commit: <code>$SEMAPHORE_GIT_SHA</code>%0AAI Analysis: <i>$SAFE_AI_EXPLANATION</i>"

echo "Failure processed and notifications sent."
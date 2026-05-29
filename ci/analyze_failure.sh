#!/bin/bash
set -euo pipefail

echo "Starting failure analysis..."

# Check if the error file exists. If not, it means the pipeline failed BEFORE the test.
if [ ! -f "ci/error_output.txt" ]; then
    echo "Warning: Error output file not found. Pipeline crashed before tests ran."
    ERROR_TEXT="Infrastructure or Pre-test failure."
else
    ERROR_TEXT=$(cat ci/error_output.txt)
fi

echo "Error detected: $ERROR_TEXT"

# Move the card to Failed
./ci/notify_trello.sh "$TRELLO_REVIEW_LIST_ID" "Build FAILED. Error: $ERROR_TEXT"

./ci/notify_telegram.sh "🚨 <b>Build FAILED!</b>%0AContract violated in commit: <code>$SEMAPHORE_GIT_SHA</code>%0AError: <i>$ERROR_TEXT</i>"

echo "Failure processed and Trello updated."
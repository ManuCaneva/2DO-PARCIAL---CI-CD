#!/bin/bash
set -euo pipefail

echo "Starting failure analysis..."

# 1. Retrieve the error output saved by run_spec_kit.sh
if [ ! -f "ci/error_output.txt" ]; then
    echo "Error output file not found. Aborting."
    exit 1
fi
ERROR_TEXT=$(cat ci/error_output.txt)

echo "Error detected: $ERROR_TEXT"

# 2. Move the card to the Failed column using the modular Trello script
# We pass the column ID and the error message as a comment
./ci/notify_trello.sh "$TRELLO_REVIEW_LIST_ID" "Build FAILED. Expected 'MINOLI', but got: $ERROR_TEXT"

echo "Failure processed and Trello updated."
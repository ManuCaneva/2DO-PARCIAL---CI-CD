#!/bin/bash
set -euo pipefail

echo "Starting SDD Audit (Spec Kit)..."

# 1. Define the exact path in the repository root
FILE_PATH="index.html"

# 2. Verify that the output file exists
if [ ! -f "$FILE_PATH" ]; then
    echo "Infrastructure failure: Output file not found at $FILE_PATH"
    exit 1
fi

# 3. Read the content of the file
# - 'sed -n '/<body/,/<\/body>/p'' isolates only the visible content of the body.
# - 'sed -e 's/<[^>]*>//g'' removes the remaining HTML tags.
# - 'xargs' cleans residual whitespaces.
OUTPUT_CONTENT=$(sed -n '/<body/,/<\/body>/p' "$FILE_PATH" | sed -e 's/<[^>]*>//g' | xargs)

echo "Output detected in code: '$OUTPUT_CONTENT'"

# 4. Evaluate the unbreakable contract
if [ "$OUTPUT_CONTENT" == "MINOLI" ]; then
    echo "SDD Contract fulfilled: Output is strictly as expected."
    exit 0
else
    # If it fails, we export the error so the next step (Gemini) can analyze it
    echo "BROKEN CONTRACT: Expected 'MINOLI', but code returned '$OUTPUT_CONTENT'."
    
    # Save the error result in a temporary file for the AI to read later
    echo "$OUTPUT_CONTENT" > ci/error_output.txt
    
    exit 1
fi
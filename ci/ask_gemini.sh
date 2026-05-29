#!/bin/bash
set -euo pipefail

if [ -z "${GEMINI_API_KEY:-}" ]; then
    echo "Error: GEMINI_API_KEY is not set."
    exit 1
fi

# Verify that required files exist
for file in "ci/error_output.txt" "index.html" "ci/run_spec_kit.sh"; do
    if [ ! -f "$file" ]; then
        echo "Error: File $file does not exist."
        exit 1
    fi
done

# Build the JSON safely using jq to escape file contents
JSON_PAYLOAD=$(jq -n \
  --arg prompt "Analyze this CI/CD pipeline failure. Respond VERY CONCISELY (maximum 3 lines of plain text, no complex markdown). Indicate exactly why the test failed and which line or tag in index.html must be corrected to fix it." \
  --arg err "$(cat ci/error_output.txt)" \
  --arg html "$(cat index.html)" \
  --arg test "$(cat ci/run_spec_kit.sh)" \
  '{
    contents: [{
      parts: [{text: ($prompt + "\n\n--- GENERATED ERROR ---\n" + $err + "\n\n--- SOURCE CODE (index.html) ---\n" + $html + "\n\n--- TEST SCRIPT (run_spec_kit.sh) ---\n" + $test)}]
    }],
    generationConfig: {
      temperature: 0.2
    }
  }')

# Request to Gemini API
RESPONSE=$(curl -s -X POST "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${GEMINI_API_KEY}" \
    -H 'Content-Type: application/json' \
    -d "$JSON_PAYLOAD")

# Extract the text from the response
EXPLANATION=$(echo "$RESPONSE" | jq -r '.candidates[0].content.parts[0].text // empty')

if [ -z "$EXPLANATION" ]; then
    echo "Error: Empty response from Gemini."
    exit 1
fi

echo "$EXPLANATION"
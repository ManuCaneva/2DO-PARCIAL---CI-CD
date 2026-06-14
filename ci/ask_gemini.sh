#!/bin/bash
set -euo pipefail

if [ -z "${GEMINI_API_KEY:-}" ]; then
    echo "Error: GEMINI_API_KEY is not set."
    exit 1
fi

# Verify that required files exist
for file in "ci/error_output.txt" "index.html" "ci/run_spec_kit.sh" "docs/requirements.md"; do
    if [ ! -f "$file" ]; then
        echo "Error: File $file does not exist."
        exit 1
    fi
done

# Build the JSON safely using jq to escape file contents
JSON_PAYLOAD=$(jq -n \
  --arg prompt "Analyze this CI/CD pipeline failure. You must respond in TWO parts separated EXACTLY by the delimiter '---FIX_PLAN---' (on its own line).

Part 1 (before delimiter): VERY CONCISE explanation, maximum 3 lines of plain text. Indicate exactly why the test failed and which line or tag in index.html must be corrected.

Part 2 (after delimiter): A complete fix-plan markdown document with the following sections:
- Error Detectado: what the error is
- Causa Raiz: root cause analysis
- Pasos para Solucionar: numbered steps to fix, referencing the quality requirements where relevant
- Verificacion Final: how to verify the fix

Use the project quality requirements as guidance for the fix plan." \
  --arg err "$(cat ci/error_output.txt)" \
  --arg html "$(cat index.html)" \
  --arg test "$(cat ci/run_spec_kit.sh)" \
  --arg reqs "$(cat docs/requirements.md)" \
  '{
    contents: [{
      parts: [{text: ($prompt + "\n\n--- GENERATED ERROR ---\n" + $err + "\n\n--- SOURCE CODE (index.html) ---\n" + $html + "\n\n--- TEST SCRIPT (run_spec_kit.sh) ---\n" + $test + "\n\n--- QUALITY REQUIREMENTS ---\n" + $reqs)}]
    }],
    generationConfig: {
      temperature: 0.2
    }
  }')

# Request to Gemini API
RESPONSE=$(curl -s -X POST "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=${GEMINI_API_KEY}" \
    -H 'Content-Type: application/json' \
    -d "$JSON_PAYLOAD")

# Extract the text from the response
FULL_RESPONSE=$(echo "$RESPONSE" | jq -r '.candidates[0].content.parts[0].text // empty')

if [ -z "$FULL_RESPONSE" ]; then
    echo "Error: Empty response from Gemini."
    exit 1
fi

# Split on the delimiter
CONCISE_TEXT=$(echo "$FULL_RESPONSE" | sed -n '/---FIX_PLAN---/q;p')
FIX_PLAN=$(echo "$FULL_RESPONSE" | sed -n '/---FIX_PLAN---/,//p' | tail -n +2)

echo "$CONCISE_TEXT" | head -3

# Write the fix-plan.md if the plan portion is non-empty
if [ -n "$(echo "$FIX_PLAN" | tr -d '[:space:]')" ]; then
    echo "$FIX_PLAN" > ci/fix-plan.md
fi
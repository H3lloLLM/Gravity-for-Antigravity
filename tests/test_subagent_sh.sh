#!/usr/bin/env bash
# test_subagent_sh.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
SUBAGENT="${ROOT_DIR}/scripts/subagent.sh"

echo "1. Help and usage flag"
"$SUBAGENT" --help > /dev/null

echo "2. Missing argument validation"
if "$SUBAGENT" 2>/dev/null; then
    echo "Expected failure on missing arguments"
    exit 1
fi

echo "3. Missing task file validation"
if "$SUBAGENT" "pi-scout" "nonexistent_file.txt" 2>/dev/null; then
    echo "Expected failure on missing task file"
    exit 1
fi

# Create a temporary task file
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT
TASK_FILE="$TEMP_DIR/task.txt"
echo "Test prompt" > "$TASK_FILE"

echo "4. Role mapping and 5. Mock execution (SUCCESS)"
export MOCK_AGY=1
OUT_JSON="$TEMP_DIR/out.json"

# pi-scout should map to gemini-3.8-flash-low
OUTPUT=$("$SUBAGENT" "pi-scout" "$TASK_FILE" "$OUT_JSON")

if ! echo "$OUTPUT" | grep -q "gemini-3.8-flash-low"; then
    echo "Expected model mapping failed"
    exit 1
fi

if [[ ! -f "$OUT_JSON" ]]; then
    echo "Expected output JSON file was not created"
    exit 1
fi

echo "6. Mock failure case exiting with status 1"
export MOCK_STATUS="FAILED"
if "$SUBAGENT" "pi-scout" "$TASK_FILE" 2>/dev/null; then
    echo "Expected failure on mock status != SUCCESS"
    exit 1
fi

echo "All tests passed."

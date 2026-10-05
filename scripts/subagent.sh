#!/usr/bin/env bash
# subagent.sh - Headless subagent runner

set -e

# Default settings
MOCK_AGY="${MOCK_AGY:-0}"

function show_help {
    local exit_code="${1:-0}"
    echo "Usage: $0 <model-or-role> <task-file> [output-json-file] [extra-agy-flags...]"
    echo "Options:"
    echo "  --help  Show this help"
    exit "$exit_code"
}

if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    show_help 0
fi

if [[ $# -lt 2 ]]; then
    echo "Error: Missing arguments." >&2
    show_help 1
fi

MODEL_OR_ROLE="$1"
TASK_FILE="$2"
OUTPUT_FILE="$3"
shift 3 || true
EXTRA_FLAGS=("$@")

# Resolve role to model slug
MODEL="$MODEL_OR_ROLE"
case "$MODEL_OR_ROLE" in
    pi-scout) MODEL="gemini-3.8-flash-low" ;;
    pi-planner) MODEL="gemini-3.8-flash-high" ;;
    pi-builder) MODEL="gemini-3.8-flash-low" ;;
    pi-reviewer) MODEL="gemini-3.8-flash-medium" ;;
    pi-debugger) MODEL="gemini-3.8-flash-medium" ;;
    pi-investigator) MODEL="gemini-3.8-flash-medium" ;;
esac

if [[ ! -f "$TASK_FILE" ]]; then
    echo "Error: Task file '$TASK_FILE' does not exist." >&2
    exit 1
fi

if [[ ! -r "$TASK_FILE" ]]; then
    echo "Error: Task file '$TASK_FILE' is not readable." >&2
    exit 1
fi

if [[ ! -s "$TASK_FILE" ]]; then
    echo "Error: Task file '$TASK_FILE' is empty." >&2
    exit 1
fi

# Determine if we should mock
if ! command -v agy >/dev/null 2>&1; then
    MOCK_AGY=1
fi

if [[ "$MOCK_AGY" == "1" ]]; then
    MOCK_STATUS="${MOCK_STATUS:-SUCCESS}"
    RAW_JSON='{"status": "'$MOCK_STATUS'", "response": "Mock response for '$MODEL'", "model": "'$MODEL'", "duration_seconds": 0.1}'
else
    # Run actual agy command
    # Capture stderr as well, or just let agy handle it
    PROMPT=$(cat "$TASK_FILE")
    RAW_JSON=$(agy -p "$PROMPT" --model "$MODEL" --output-format json --print-timeout 20m "${EXTRA_FLAGS[@]}" 2>/dev/null || true)
fi

if [[ -n "$OUTPUT_FILE" ]]; then
    echo "$RAW_JSON" > "$OUTPUT_FILE"
fi

# Parse JSON for status
STATUS=""
if command -v jq >/dev/null 2>&1; then
    STATUS=$(echo "$RAW_JSON" | jq -r '.status // empty' 2>/dev/null || true)
else
    # Fallback to python
    STATUS=$(python3 -c "import sys, json; print(json.load(sys.stdin).get('status', ''))" <<< "$RAW_JSON" 2>/dev/null || true)
fi

if [[ "$STATUS" != "SUCCESS" ]]; then
    echo "Error: Subagent execution failed or status was not SUCCESS. Status: $STATUS" >&2
    echo "Raw output: $RAW_JSON" >&2
    exit 1
fi

echo "$RAW_JSON"
exit 0

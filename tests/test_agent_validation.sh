#!/bin/bash
set -e

echo "Running validate-agents.sh..."
if ! bash scripts/validate-agents.sh; then
    echo "Agent validation failed!"
    exit 1
fi
echo "Agent validation passed."

echo "Testing subagent.sh mock execution..."

# Create a dummy task file
DUMMY_TASK=$(mktemp)
echo "Dummy task" > "$DUMMY_TASK"

ROLES=("pi-scout" "pi-planner" "pi-builder" "pi-reviewer" "pi-debugger" "pi-investigator")

for role in "${ROLES[@]}"; do
    echo "Testing role: $role"
    OUTPUT=$(MOCK_AGY=1 bash scripts/subagent.sh "$role" "$DUMMY_TASK")
    
    # Check if output contains SUCCESS
    if ! echo "$OUTPUT" | grep -q '"status": "SUCCESS"'; then
        echo "Role $role failed mock execution. Output: $OUTPUT"
        rm -f "$DUMMY_TASK"
        exit 1
    fi
    echo "Role $role passed."
done

rm -f "$DUMMY_TASK"
echo "All roles passed mock execution."
exit 0

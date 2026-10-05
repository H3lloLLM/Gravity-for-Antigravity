#!/bin/bash
set -e

echo "Running validate-agents.sh..."
if ! bash scripts/validate-agents.sh; then
    echo "Agent validation failed!"
    exit 1
fi
echo "Agent validation passed."

echo "Verifying Pi agent YAML sidecar model slugs..."
EXPECTED_MODELS=(
    "pi-scout:gemini-3.8-flash-low"
    "pi-planner:gemini-3.8-flash-high"
    "pi-builder:gemini-3.8-flash-low"
    "pi-reviewer:gemini-3.8-flash-medium"
    "pi-debugger:gemini-3.8-flash-medium"
    "pi-investigator:gemini-3.8-flash-medium"
)

for pair in "${EXPECTED_MODELS[@]}"; do
    role="${pair%%:*}"
    expected_slug="${pair##*:}"
    sidecar=".agents/agents/${role}.yaml"

    if [ ! -f "$sidecar" ]; then
        echo "Error: Sidecar file '$sidecar' does not exist."
        exit 1
    fi

    if ! grep -qE "^model:[[:space:]]*${expected_slug}[[:space:]]*$" "$sidecar"; then
        echo "Error: $sidecar does not contain expected model slug '$expected_slug'"
        exit 1
    fi
    echo "Sidecar $role matches expected slug: $expected_slug"
done
echo "All YAML sidecars verified."

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

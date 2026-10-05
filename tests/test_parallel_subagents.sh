#!/usr/bin/env bash
# test_parallel_subagents.sh

set -e

# Setup test directory
TEST_DIR=$(mktemp -d)
trap 'rm -rf "$TEST_DIR"' EXIT

echo "Dummy task 1" > "$TEST_DIR/task1.md"
echo "Dummy task 2" > "$TEST_DIR/task2.md"
echo "Dummy task 3" > "$TEST_DIR/task3.md"

OUTPUT_DIR="$TEST_DIR/runs"
REPORT_FILE="$TEST_DIR/report.md"

# Run parallel dispatcher in dry-run mode (mock mode)
python3 scripts/parallel_subagents.py \
    --task pi-scout:"$TEST_DIR/task1.md" \
    --task pi-reviewer:"$TEST_DIR/task2.md" \
    --task gemini-3.8-flash-low:"$TEST_DIR/task3.md" \
    --output-dir "$OUTPUT_DIR" \
    --report "$REPORT_FILE" \
    --dry-run

# Verify directories exist
if [[ ! -d "$OUTPUT_DIR/task_0" ]] || [[ ! -d "$OUTPUT_DIR/task_1" ]] || [[ ! -d "$OUTPUT_DIR/task_2" ]]; then
    echo "Error: Output directories not created properly."
    exit 1
fi

# Verify output.json in each directory
if [[ ! -f "$OUTPUT_DIR/task_0/output.json" ]] || [[ ! -f "$OUTPUT_DIR/task_1/output.json" ]] || [[ ! -f "$OUTPUT_DIR/task_2/output.json" ]]; then
    echo "Error: output.json files missing."
    exit 1
fi

# Verify report file
if [[ ! -f "$REPORT_FILE" ]]; then
    echo "Error: Report file missing."
    exit 1
fi

# Verify report contents
if ! grep -q "Total Tasks\*\*: 3" "$REPORT_FILE"; then
    echo "Error: Report file missing total tasks count."
    exit 1
fi
if ! grep -q "Success\*\*: 3" "$REPORT_FILE"; then
    echo "Error: Report file missing success count."
    exit 1
fi
if ! grep -q "gemini-3.8-flash-low" "$REPORT_FILE"; then
    echo "Error: Report file missing model information."
    exit 1
fi
if ! grep -q "gemini-3.8-flash-medium" "$REPORT_FILE"; then
    echo "Error: Report file missing model information."
    exit 1
fi

echo "Parallel subagents test passed!"

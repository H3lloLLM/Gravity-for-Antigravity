#!/usr/bin/env bash
# workflow_headless.sh - Example headless workflow execution

set -e

echo "Starting headless parallel subagent execution..."
python3 scripts/parallel_subagents.py --tasks examples/parallel_tasks.json --concurrency 2 --report examples/execution_report.md --dry-run
echo "Workflow completed successfully."

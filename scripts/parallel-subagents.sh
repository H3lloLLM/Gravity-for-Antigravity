#!/usr/bin/env bash
# parallel-subagents.sh - Wrapper for parallel_subagents.py

set -e

function show_help {
    python3 scripts/parallel_subagents.py --help
    exit 0
}

if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    show_help
fi

# Forward all arguments to the python script
exec python3 scripts/parallel_subagents.py "$@"

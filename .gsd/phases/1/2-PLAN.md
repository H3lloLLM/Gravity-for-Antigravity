---
phase: 1
plan: 2
wave: 2
gap_closure: false
---

# Plan 1.2: Parallel Multi-Subagent Batch Dispatcher

## Objective
Implement a concurrent batch execution runner (`scripts/parallel_subagents.py` and wrapper `scripts/parallel-subagents.sh`) that takes multiple subagent task definitions, dispatches them in parallel (using `scripts/subagent.sh`), isolates their output directories and files so parallel writers never collide, and aggregates token usage, status, and responses into a structured summary report.

## Context
Load these files for context:
- `.gsd/SPEC.md`
- `.gsd/DECISIONS.md`
- `.gsd/phases/1/1-PLAN.md`
- `PROJECT_RULES.md`

## Tasks

<task type="auto">
  <name>Implement scripts/parallel_subagents.py and shell wrapper</name>
  <files>
    scripts/parallel_subagents.py
    scripts/parallel-subagents.sh
  </files>
  <action>
    Create `scripts/parallel_subagents.py`:
    1. Support CLI flags:
       - `--tasks`: JSON/YAML task specification file OR list of `--task <role-or-model>:<task-file>`
       - `--concurrency`: Max parallel worker processes (default 4)
       - `--output-dir`: Base directory for run artifacts (default `.gsd/runs/<timestamp>`)
       - `--report`: Path to output aggregated markdown or JSON summary report
       - `--dry-run`: Pass dry-run down to subagents
    2. For each task:
       - Create an isolated run directory (`<output-dir>/<task_id>/`)
       - Invoke `scripts/subagent.sh` asynchronously via Python `concurrent.futures` / `subprocess`
       - Capture stdout, stderr, exit code, and JSON envelope
    3. Aggregate results into an execution report showing:
       - Overall success / failure count
       - Per-subagent status, model used, latency/duration, and token count (if reported)
       - Response snippet or artifact link
    4. Create `scripts/parallel-subagents.sh` as an ergonomic bash wrapper.
  </action>
  <verify>
    python3 scripts/parallel_subagents.py --help && bash scripts/parallel-subagents.sh --help
  </verify>
  <done>
    Help commands exit 0 and display complete argument reference.
  </done>
</task>

<task type="auto">
  <name>Test parallel subagent batch execution</name>
  <files>
    tests/test_parallel_subagents.sh
  </files>
  <action>
    Create `tests/test_parallel_subagents.sh` that launches 3 concurrent tasks (e.g. `pi-scout`, `pi-reviewer`, and custom model) using mock mode:
    1. Verifies all 3 subagents run concurrently and finish.
    2. Verifies separate output directories are created and written without collisions.
    3. Verifies aggregated report contains summary data for all 3 tasks.
  </action>
  <verify>
    bash tests/test_parallel_subagents.sh
  </verify>
  <done>
    Batch test succeeds, verifying concurrency, isolation, and report generation.
  </done>
</task>

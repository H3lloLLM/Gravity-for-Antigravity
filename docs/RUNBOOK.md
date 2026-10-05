# Subagent Orchestration Runbook

This runbook covers how to operate the multi-agent orchestration system using both native and headless approaches.

## 1. Native `invoke_subagent` Usage (Antigravity Standard)

The Antigravity ecosystem supports native subagent invocation via the `invoke_subagent` action or the `send_message` tool for peer communication.

- **Definition:** Agents are defined in `.agents/agents/*.md` with YAML frontmatter specifying their `name`, `description`, `tools`, and `subagent` status.
- **Tools:** Valid tools (e.g., `view_file`, `list_dir`, `grep_search`, `send_message`) are granted in the frontmatter.
- **Prompts:** The markdown body serves as the system prompt (e.g., `pi-scout.md` explains the scout's role).
- **Execution:** Orchestrators can spawn these subagents and delegate specific tasks. Subagents must use the `send_message` tool to return their findings to the parent.

Example frontmatter for a Pi subagent:
```yaml
---
name: pi-scout
description: Reconnaissance subagent
tools:
  - view_file
  - list_dir
  - find_by_name
  - grep_search
  - send_message
subagent: true
---
```

## 2. Headless CLI Usage (`subagent.sh`)

For headless execution outside the native Antigravity environment (e.g., CI pipelines or isolated parallel execution), use the bash wrapper `scripts/subagent.sh`.

This script invokes the `agy` CLI with precise model pinning and task files, returning structured JSON envelopes.

**Usage:**
```bash
bash scripts/subagent.sh <model-or-role> <task-file> [output-json-file] [extra-agy-flags...]
```

**Parameters:**
- `<model-or-role>`: Either a direct model slug (e.g., `gemini-3.8-flash-high`) or a mapped role (`pi-scout`, `pi-planner`, `pi-builder`, etc.).
- `<task-file>`: Path to a file containing the prompt/task description.
- `[output-json-file]`: Optional file to write the JSON response.

**Example:**
```bash
echo "List the contents of src/." > task.txt
bash scripts/subagent.sh pi-scout task.txt output.json
```

**Features:**
- Timeouts: Enforced automatically via `--print-timeout 20m`.
- Output: Always requests JSON output format from `agy`.
- Mocking: If `agy` is unavailable or `MOCK_AGY=1` is set in the environment, it returns a mock SUCCESS envelope.

## 3. Parallel Batch Dispatch (`parallel_subagents.py`)

To run multiple subagents concurrently across different models, use the `scripts/parallel_subagents.py` orchestrator.

**Usage:**
```bash
python3 scripts/parallel_subagents.py --tasks <manifest-file>
```
OR
```bash
python3 scripts/parallel_subagents.py --task <role>:<file> --task <role>:<file>
```

**Task Manifest (JSON):**
Create a manifest file containing an array of tasks.
```json
[
  { "id": "task1", "role": "pi-scout", "file": "scout_task.txt" },
  { "id": "task2", "role": "pi-planner", "prompt": "Create a roadmap." }
]
```

**Features:**
- Concurrency: Defaults to 4 worker processes (`--concurrency 4`).
- Artifacts: Creates isolated run directories per task (`.gsd/runs/<timestamp>/<task_id>/`) to prevent output clobbering.
- Model Mapping: Automatically resolves roles to model slugs based on `model_capabilities.yaml` if available.
- Reporting: Can generate a markdown or JSON execution report using the `--report <file>` flag.

## 4. Troubleshooting & Parsing

- **JSON Parsing**: `subagent.sh` attempts to use `jq` to parse the `status` from the JSON envelope. If `jq` is not found, it gracefully falls back to a short `python3` inline script. Ensure either `jq` or `python3` is available.
- **Failures**: If a subagent does not return `"status": "SUCCESS"`, the script outputs the raw JSON envelope and exits with code 1.
- **Dry Runs**: Use `--dry-run` with `parallel_subagents.py` or set `MOCK_AGY=1` for testing the orchestration logic without invoking real LLMs.

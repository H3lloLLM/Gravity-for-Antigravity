# DECISIONS.md — Architecture Decision Records

> **Purpose**: Log significant technical decisions and their rationale.

## Decisions

### [DECISION-001] Dual-Layer Subagent Architecture (PDF Headless Runner + Antigravity Agents)

**Date**: 2026-10-06
**Status**: Accepted

### Context
The user requested implementing subagents using the method shown in the provided PDF and creating the subagents from the Pi Harness (https://github.com/earendil-works/pi). The PDF describes using headless `agy` CLI calls (`agy -p "$(cat taskfile)" --model "$model" --output-format json --print-timeout 20m`) to achieve model-pinned parallel subagents without Ultra plan restrictions. In addition, Antigravity 2.0 supports native `.agents/agents/*.md` definitions for `invoke_subagent`.

### Decision
Support both mechanisms seamlessly:
1. Provide the headless CLI runner (`scripts/subagent.sh` and a Python parallel orchestrator `scripts/parallel_subagents.py`) that shells out to `agy` with exact model pinning, task files, and JSON envelopes as detailed in the PDF.
2. Provide the canonical Pi Harness subagents (`pi-scout`, `pi-planner`, `pi-builder`, `pi-reviewer`, `pi-debugger`, `pi-investigator`) defined in `.agents/agents/*.md` so they can be invoked natively via `invoke_subagent` or targeted by the CLI runner.

### Rationale
This gives the user the best of both worlds: full CLI control over any specific model slug (avoiding tier limitations) while maintaining full IDE compatibility with Antigravity subagent discovery and validation.

### Consequences
- Subagent markdown definitions must conform to `validate-agents.sh`.
- The CLI runner must support robust error detection, JSON parsing (with fallback if `jq` is absent), and timeout controls.

---

## Phase 1 Decisions & Model Matrix

**Date:** 2026-10-06

### Scope & Role Model Mappings
The user explicitly specified the model configurations for each Pi Harness subagent role:

| Subagent Role | Model Selection | Model Slug / Tier | Purpose & Characteristics |
|---|---|---|---|
| `pi-scout` | Gemini 3.8 Flash (Low) | `gemini-3.8-flash-low` / `flash` | Rapid codebase reconnaissance, low latency, token-efficient summary |
| `pi-planner` | Gemini 3.8 Flash (High) | `gemini-3.8-flash-high` / `pro` | Deep reasoning for step decomposition, dependency graphs, risk analysis |
| `pi-builder` | Gemini 3.8 Flash (Low) | `gemini-3.8-flash-low` / `flash` | Code implementations, targeted editing, fast iteration |
| `pi-reviewer` | Gemini 3.8 Flash (Medium) | `gemini-3.8-flash-medium` / `inherit` | Balanced evaluation, quality audits, diff inspection, empirical proof |
| `pi-debugger` | Gemini 3.8 Flash (Medium) | `gemini-3.8-flash-medium` / `inherit` | Hypothesis testing, reproduction checks, log analysis |
| `pi-investigator` | Gemini 3.8 Flash (Medium) | `gemini-3.8-flash-medium` / `inherit` | Deep root-cause isolation, trace tracking, architectural inquiries |

### Approach for Headless Runner (Phase 1)
- **Primary Script**: `scripts/subagent.sh <model-slug> <task-file> [output-json-file]`
  - Runs headless `agy -p "$(cat "$taskfile")" --model "$model" --output-format json --print-timeout 20m`.
  - Fallback/mock mode: detects whether `agy` is present; if not or if in test mode, provides descriptive diagnostics.
  - Robust JSON parsing: handles `jq` if present, with python/grep fallback so missing dependencies don't crash the script.
- **Concurrent Batch Dispatcher**: `scripts/parallel_subagents.py` (and bash wrapper `scripts/parallel-subagents.sh`)
  - Takes a JSON/YAML batch manifest (or CLI arguments mapping tasks to agent roles and models).
  - Executes subagents concurrently using a process pool (`ThreadPoolExecutor` or `subprocess.Popen`).
  - Creates isolated per-task run directories/artifacts so parallel writes never clobber each other.
  - Generates an aggregated execution summary report with duration and token counts.

---

*Last updated: 2026-10-06*


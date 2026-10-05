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

*Last updated: 2026-10-06*

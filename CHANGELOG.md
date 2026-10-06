# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-10-06

### Added

#### Phase 1: Headless Subagent CLI Runner
- **Core CLI Runner (`scripts/subagent.sh`)**: Non-interactive wrapper for `agy` execution supporting explicit model pinning, task files, structured JSON envelope extraction, automated timeout enforcement (`--print-timeout 20m`), error propagation, and mock testing mode (`MOCK_AGY=1`).
- **Parallel Batch Dispatcher (`scripts/parallel_subagents.py` & `scripts/parallel-subagents.sh`)**: Multi-process worker pool dispatcher supporting concurrency limits (`--concurrency`), task manifest files, isolated run directories (`.gsd/runs/<timestamp>/<task_id>/`), and automated Markdown execution report generation.
- **Verification Tests**: Comprehensive test scripts (`tests/test_subagent_sh.sh`, `tests/test_parallel_subagents.sh`) verifying single-task and concurrent headless runs.

#### Phase 2: Gravity for Antigravity Subagent Suite Definitions
- **6 Pi Specialist Subagents** registered in `.agents/agents/` with single-shot prompts and granular tool grants:
  - `pi-scout`: Codebase reconnaissance and file structure discovery (`gemini-3.8-flash-low`).
  - `pi-planner`: Architectural step decomposition and dependency analysis (`gemini-3.8-flash-high`).
  - `pi-builder`: Isolated implementation and test verification (`gemini-3.8-flash-low`).
  - `pi-reviewer`: Code diff inspection, security audit, and empirical proof (`gemini-3.8-flash-medium`).
  - `pi-debugger`: Hypothesis-driven diagnostic tracing and root cause reproduction (`gemini-3.8-flash-medium`).
  - `pi-investigator`: Web search, URL inspection, and external documentation lookup (`gemini-3.8-flash-medium`).
- **Handoff Protocol**: Standardized subagent return contract utilizing `send_message` to pass compact summaries back to orchestrator.

#### Phase 3: Model Routing Configuration & Validation Suite
- **Model Capabilities Registry (`model_capabilities.yaml`)**: Centralized capability matrix mapping Pi subagent roles to model tiers and explicit slugs.
- **YAML Sidecars**: Paired YAML sidecars for all Pi subagents pinning designated model slugs.
- **Automated Validation Suite (`tests/test_agent_validation.sh`)**: Automated test runner validating frontmatter schema, tool permissions, sidecar model declarations, and mock CLI execution.
- **Agent Utilities (`scripts/agent_utils.py` & `tests/test_agent_utils.py`)**: Python utilities for programmatic role-to-model resolution.

#### Phase 4: Integration, Documentation & Runbook
- **Operational Runbook (`docs/RUNBOOK.md`)**: Complete operating instructions for both native Antigravity `invoke_subagent` workflows and headless CLI parallel fan-out.
- **Runnable Examples (`examples/`)**: Sample workflows including `workflow_headless.sh`, `parallel_tasks.json`, and generated `execution_report.md`.
- **Cross-Platform Adapters (`adapters/`)**: Optional model-specific enhancements for Claude (`CLAUDE.md`), Gemini (`GEMINI.md`), and GPT/OSS (`GPT_OSS.md`).
- **Global Plugin Deployment**: Deployed Gravity for Antigravity subagent definitions and skill modules directly into global Antigravity plugin storage (`~/.gemini/config/plugins/gravity-for-antigravity/`).
- **Orchestrator-Only Discipline (`AGENTS.md`)**: Single Source of Truth rule enforcing strict delegation discipline for Antigravity orchestrators.

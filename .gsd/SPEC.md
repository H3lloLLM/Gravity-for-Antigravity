# SPEC.md — Project Specification

> **Status**: `FINALIZED`
>
> ⚠️ **Planning Lock**: Requirements defined and finalized for initialization.

## Vision
Build a dual-layer subagent orchestration system for Antigravity and terminal coding environments:
1. **Headless CLI Subagent Runner (`subagent.sh` / Python CLI runner)**: An external orchestration mechanism inspired by the headless `agy` CLI pattern documented in the project briefing (invoking `agy -p "<prompt>" --model <slug> --output-format json`), allowing arbitrary model pinning (e.g., `gemini-3.8-flash-high`, `claude-sonnet-4-6`), parallel execution via task files, JSON envelope extraction, timeout management, and retry fallbacks.
2. **Pi Harness Subagent Suite**: A complete suite of specialized subagent roles adapted from the Pi harness ecosystem (`scout`, `planner`, `builder`, `reviewer`, `debugger`, `investigator`) integrated into `.agents/agents/*.md` and script runners with strict tool grants, single-shot isolation, prompt contract formats, and GSD compatibility.

## Goals
1. **Headless Subagent CLI Runner**: Implement a robust, configurable CLI tool (`subagent.sh` and python orchestration equivalent) capable of spawning one-shot non-interactive `agy` instances in parallel, passing prompts via isolated temp files, collecting structured JSON/status envelopes, handling timeouts, and reporting aggregated results back to the orchestrator.
2. **Pi Harness Subagent Suite Integration**: Implement and register the full set of Pi harness subagent roles (`pi-scout`, `pi-planner`, `pi-builder`, `pi-reviewer`, `pi-debugger`, `pi-investigator`) with explicit YAML frontmatter, valid Antigravity tool mappings, system prompts, and task contracts matching GSD and Pi standards.
3. **Multi-Model Routing & Configuration**: Create an ergonomic model mapping configuration linking subagent roles to recommended model slugs/tiers (fast/flash for reconnaissance and scouting, deep reasoning/pro for architecture and planning, coding specialists for building/reviewing).
4. **Validation & Verification Suite**: Ensure all subagent definitions pass `validate-agents.sh` and provide an end-to-end execution test suite proving parallel execution, model pinning, and structured envelope parsing.

## Non-Goals (Out of Scope)
- Relying on or requiring Antigravity Ultra plan-gated Agent Teams features (`/teamwork-preview`).
- Modifying the closed-source binary of Antigravity or Pi coding agent.
- Interactive multi-user terminal multiplexers (e.g. interactive tmux UI panes), focusing instead on headless scriptable subagent execution.

## Users
- Developers and orchestrator agents operating within Antigravity or terminal CLI environments wanting parallel subagents across diverse models without subscription tier lockouts.

## Constraints
- Must run cleanly on macOS (Darwin) with zsh/bash and Python 3 / Node.js.
- Headless execution must be non-interactive with strict timeouts to prevent orphaned background processes.
- Tool grants in `.agents/agents/*.md` must conform strictly to valid Antigravity tools recognised by `validate-agents.sh`.
- File writes by parallel subagents must be sandboxed to avoid clobbering each other's outputs.

## Success Criteria
- [ ] `subagent.sh` (and Python parallel orchestrator) implemented with support for model slug, task file/prompt, JSON output formatting, error handling, and timeout safeguards.
- [ ] Pi Harness subagent specifications created in `.agents/agents/` (`pi-scout.md`, `pi-planner.md`, `pi-builder.md`, `pi-reviewer.md`, `pi-debugger.md`, `pi-investigator.md`) and verified by `validate-agents.sh`.
- [ ] Model routing configuration defined for Pi subagent roles (mapping roles to optimal models).
- [ ] Comprehensive documentation and runbooks created explaining how the orchestrator invokes subagents via both native `invoke_subagent` and external headless CLI commands.
- [ ] Automated validation passes with 0 errors across all subagent definitions.

---

*Last updated: 2026-10-06*

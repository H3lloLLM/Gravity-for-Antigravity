---
milestone: v1.0
version: 1.0.0
updated: 2026-10-06T00:19:00Z
---

# Roadmap

> **Current Phase:** 1 - Headless Subagent CLI Runner
> **Status:** complete
> **Progress:** 4/4 phases complete (100%)

## Must-Haves (from SPEC)

- [x] Headless Subagent CLI runner (`subagent.sh`) supporting model pinning, task files, and JSON envelopes
- [x] Concurrent batch runner for parallel multi-model subagent dispatch
- [x] Pi Harness subagent role suite (`pi-scout`, `pi-planner`, `pi-builder`, `pi-reviewer`, `pi-debugger`, `pi-investigator`)
- [x] Subagent model routing matrix & capability configuration
- [x] Automated validation passing with 0 errors via `validate-agents.sh`

---

## Phases

### Phase 1: Headless Subagent CLI Runner
**Status:** ✅ Complete
**Objective:** Implement the core CLI wrapper scripts (`subagent.sh` and parallel batch runner `scripts/parallel-subagents.py` / `parallel-subagents.sh`) following the PDF architecture (headless `agy` invocation, `--model` pinning, `--output-format json`, timeout management, error propagation, temp file prompt passing).
**Requirements:** REQ-01, REQ-02

**Plans:**
- [x] Plan 1.1: Core `subagent.sh` runner and JSON envelope extractor
- [x] Plan 1.2: Parallel multi-subagent batch dispatcher with isolated output dirs

---

### Phase 2: Pi Harness Subagent Suite Definitions
**Status:** ✅ Complete
**Objective:** Create the complete suite of specialized Pi harness subagents in `.agents/agents/` (`pi-scout.md`, `pi-planner.md`, `pi-builder.md`, `pi-reviewer.md`, `pi-debugger.md`, `pi-investigator.md`) with explicit YAML frontmatter, valid Antigravity tools, single-shot prompts, and invocation contracts.
**Requirements:** REQ-03, REQ-04, REQ-05, REQ-06, REQ-07, REQ-08
**Depends on:** Phase 1

**Plans:**
- [x] Plan 2.1: Reconnaissance and Planning roles (`pi-scout.md`, `pi-planner.md`, `pi-investigator.md`)
- [x] Plan 2.2: Execution and Quality roles (`pi-builder.md`, `pi-reviewer.md`, `pi-debugger.md`)

---

### Phase 3: Model Routing Configuration & Validation Suite
**Status:** ✅ Complete
**Objective:** Update `model_capabilities.yaml` and create role routing maps linking each Pi subagent to model tiers/slugs. Verify all subagents with `validate-agents.sh` and validate script functionality.
**Requirements:** REQ-09, REQ-10
**Depends on:** Phase 2

**Plans:**
- [x] Plan 3.1: Model capability mappings & configuration for Pi harness agents
- [x] Plan 3.2: Automated agent validation and execution tests

---

### Phase 4: Integration, Documentation & Runbook
**Status:** ✅ Complete
**Objective:** Document the usage patterns for both native `invoke_subagent` and headless CLI parallel fan-out with complete examples and operational runbooks.
**Requirements:** REQ-11
**Depends on:** Phase 3

**Plans:**
- [x] Plan 4.1: Documentation, runbook, and example workflows

---

## Progress Summary

| Phase | Status | Plans | Complete |
|-------|--------|-------|----------|
| 1 | ✅ | 2/2 | 100% |
| 2 | ✅ | 2/2 | 100% |
| 3 | ✅ | 2/2 | 100% |
| 4 | ✅ | 1/1 | 100% |

---

## Timeline

| Phase | Started | Completed | Duration |
|-------|---------|-----------|----------|
| 1 | — | — | — |
| 2 | — | — | — |
| 3 | — | — | — |
| 4 | — | — | — |

---

*Last updated: 2026-10-06*

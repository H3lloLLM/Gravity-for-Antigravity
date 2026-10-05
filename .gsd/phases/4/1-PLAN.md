---
phase: 4
plan: 1
wave: 1
gap_closure: false
---

# Plan 4.1: Documentation, runbook, and example workflows

## Objective
Create comprehensive operational documentation and runnable workflow examples to demonstrate how to use both native `invoke_subagent` and headless CLI parallel fan-out methods for orchestrating the Pi harness subagents.

## Context
Load these files for context:
- .gsd/SPEC.md
- .gsd/DECISIONS.md
- scripts/subagent.sh
- scripts/parallel_subagents.py
- .agents/agents/pi-scout.md

## Tasks

<task type="auto">
  <name>Create RUNBOOK.md for subagent orchestration</name>
  <files>
    docs/RUNBOOK.md
  </files>
  <action>
    Create `docs/RUNBOOK.md` containing detailed instructions on operating the multi-agent system.
    
    Steps:
    1. Document native `invoke_subagent` usage (Antigravity standard approach), including how tools are granted and prompts are structured.
    2. Document Headless CLI usage: how to run `scripts/subagent.sh` directly, passing task files, JSON format expectation, and timeouts.
    3. Document Parallel Batch Dispatch: how to construct a manifest or run `scripts/parallel_subagents.py` to trigger multiple Pi roles (`pi-scout`, `pi-planner`, etc.) simultaneously.
    4. Provide troubleshooting and JSON parsing tips (e.g. jq).
    
    USE: Markdown formatting with clear section headers and code blocks.
  </action>
  <verify>
    test -f docs/RUNBOOK.md && grep -q "invoke_subagent" docs/RUNBOOK.md && grep -q "parallel_subagents" docs/RUNBOOK.md
  </verify>
  <done>
    `docs/RUNBOOK.md` exists and covers native IDE usage, CLI runner, and parallel dispatcher mechanisms.
  </done>
</task>

<task type="auto">
  <name>Create runnable examples directory and workflows</name>
  <files>
    examples/workflow_headless.sh
    examples/parallel_tasks.json
  </files>
  <action>
    Create a practical, runnable example showing headless parallel execution.
    
    Steps:
    1. Create `examples/parallel_tasks.json` formatted as a manifest expected by `parallel_subagents.py` (e.g., listing tasks that trigger `pi-scout` and `pi-planner`).
    2. Create `examples/workflow_headless.sh`, a bash script that invokes `python3 scripts/parallel_subagents.py --manifest examples/parallel_tasks.json`.
    3. Ensure `workflow_headless.sh` has executable permissions.
    
    USE: Bash and JSON format. Design the examples to be run from the project root.
  </action>
  <verify>
    test -f examples/workflow_headless.sh && test -f examples/parallel_tasks.json && bash -n examples/workflow_headless.sh
  </verify>
  <done>
    Runnable examples exist and the bash script has valid syntax.
  </done>
</task>

## Must-Haves
After all tasks complete, verify:
- [ ] Runbook thoroughly documents both CLI and native invocation methods.
- [ ] Runnable examples for headless multi-agent workflows exist in `examples/`.

## Success Criteria
- [ ] All tasks verified passing
- [ ] Must-haves confirmed
- [ ] No regressions in tests

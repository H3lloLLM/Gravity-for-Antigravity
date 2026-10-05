---
phase: 3
plan: 2
wave: 2
gap_closure: false
depends_on: ["1"]
---

# Plan 3.2: Automated Validation & Execution Test Suite

## Objective
Create an automated test suite to validate all agent definitions and verify that `subagent.sh` correctly executes each Pi role under mock mode (REQ-10).

## Context
Load these files for context:
- .gsd/SPEC.md
- scripts/validate-agents.sh
- scripts/subagent.sh

## Tasks

<task type="auto">
  <name>Create Agent Validation Test Script</name>
  <files>
    tests/test_agent_validation.sh
  </files>
  <action>
    Create a new test script that runs `validate-agents.sh` and tests `subagent.sh` for all 6 Pi Harness roles in mock mode.
    
    Steps:
    1. Create `tests/test_agent_validation.sh` with execution permissions.
    2. Add a step to run `scripts/validate-agents.sh` to ensure all 6 Pi agent definitions & sidecars are valid. Assert exit code 0.
    3. Add a step to iterate over the 6 roles (`pi-scout`, `pi-planner`, `pi-builder`, `pi-reviewer`, `pi-debugger`, `pi-investigator`).
    4. For each role, set `MOCK_AGY=1` and execute `scripts/subagent.sh` with a dummy task file.
    5. Assert that `subagent.sh` exits successfully and outputs the expected mock JSON envelope.
  </action>
  <verify>
    bash -n tests/test_agent_validation.sh
  </verify>
  <done>
    Test script correctly validates agents and verifies mock execution of all 6 roles.
  </done>
</task>

<task type="auto">
  <name>Run and verify the automated validation suite</name>
  <files>
    tests/test_agent_validation.sh
  </files>
  <action>
    Run the newly created test suite to ensure all assertions pass and 0 errors are encountered.
    
    Steps:
    1. Execute `bash tests/test_agent_validation.sh`.
    2. If there are errors (e.g. invalid tools in agent definitions), fix the agent definitions in `.agents/agents/pi-*.md` to ensure `validate-agents.sh` passes.
  </action>
  <verify>
    bash tests/test_agent_validation.sh
  </verify>
  <done>
    The script exits with code 0 and outputs success messages for all agents.
  </done>
</task>

## Must-Haves
After all tasks complete, verify:
- [ ] Automated validation script test passing all agent definitions with 0 errors.

## Success Criteria
- [ ] All tasks verified passing
- [ ] Must-haves confirmed
- [ ] No regressions in tests

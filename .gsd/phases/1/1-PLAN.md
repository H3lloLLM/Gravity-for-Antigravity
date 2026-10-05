---
phase: 1
plan: 1
wave: 1
gap_closure: false
---

# Plan 1.1: Core `subagent.sh` Runner & Envelope Extractor

## Objective
Implement the standalone `scripts/subagent.sh` script adhering strictly to the PDF architecture: execute one-shot non-interactive `agy` commands with pinned models, pass task files to avoid shell escaping issues, configure `--output-format json` and timeout settings, extract status envelopes, and provide graceful fallbacks (e.g. `jq` / Python JSON parsing) and mock verification modes.

## Context
Load these files for context:
- `.gsd/SPEC.md`
- `.gsd/DECISIONS.md`
- `PROJECT_RULES.md`

## Tasks

<task type="auto">
  <name>Implement scripts/subagent.sh</name>
  <files>
    scripts/subagent.sh
  </files>
  <action>
    Create executable bash script `scripts/subagent.sh`:
    1. Accept arguments: `subagent.sh <model-or-role> <task-file> [output-json-file] [extra-agy-flags...]`
    2. Support role resolution: map Pi roles (`pi-scout`, `pi-planner`, `pi-builder`, `pi-reviewer`, `pi-debugger`, `pi-investigator`) to respective model slugs (`gemini-3.8-flash-low`, `gemini-3.8-flash-high`, `gemini-3.8-flash-medium`) as defined in DECISIONS.md, or accept any direct model slug.
    3. Verify task file existence, readability, and non-emptiness.
    4. Implement robust JSON parsing using `jq` if available, falling back to `python3 -c "import sys, json; ..."` so no hard dependency breaks execution.
    5. Handle `--dry-run` or mock mode when `MOCK_AGY=1` or `agy` is missing from the environment, returning a mock JSON envelope with `{status: "SUCCESS", response: "...", model: "...", duration_seconds: 0.1}` to permit offline tests.
    6. Ensure non-zero exit code (1) and stderr output if `.status != "SUCCESS"`.
  </action>
  <verify>
    chmod +x scripts/subagent.sh && ./scripts/subagent.sh --help
  </verify>
  <done>
    Script returns usage and exits 0 on --help, passes syntax check (`bash -n scripts/subagent.sh`).
  </done>
</task>

<task type="auto">
  <name>Test subagent.sh with mock and role resolution</name>
  <files>
    scripts/subagent.sh
    tests/test_subagent_sh.sh
  </files>
  <action>
    Create a test script `tests/test_subagent_sh.sh` that exercises:
    1. Help and usage flag
    2. Missing argument validation
    3. Missing task file validation
    4. Role mapping (`pi-scout` -> `gemini-3.8-flash-low`)
    5. Mock execution (`MOCK_AGY=1`) returning SUCCESS and response payload
    6. Mock failure case exiting with status 1
  </action>
  <verify>
    bash tests/test_subagent_sh.sh
  </verify>
  <done>
    All tests in test_subagent_sh.sh pass with exit code 0.
  </done>
</task>

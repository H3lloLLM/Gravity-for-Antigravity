---
phase: 2
plan: 2
wave: 2
depends_on: ["1"]
gap_closure: false
---

# Plan 2.2: Execution and Quality Roles

## Objective
Implement the execution and quality subagent roles (`pi-builder`, `pi-reviewer`, and `pi-debugger`) with their sidecars, completing the Pi Harness suite and ensuring automated validation.

## Context
Load these files for context:
- .gsd/SPEC.md
- .gsd/ROADMAP.md
- scripts/validate-agents.sh

## Tasks

<task type="auto">
  <name>Create pi-builder and pi-reviewer definitions</name>
  <files>
    .agents/agents/pi-builder.md
    .agents/agents/pi-builder.yaml
    .agents/agents/pi-reviewer.md
    .agents/agents/pi-reviewer.yaml
  </files>
  <action>
    Create the `pi-builder` and `pi-reviewer` subagent profiles in `.agents/agents/`.
    
    Steps:
    1. Ensure both `.md` files have proper YAML frontmatter (`name` matching filename, `description`, `subagent: true`).
    2. Define valid `tools` (e.g., `write_to_file`, `replace_file_content`, `run_command` for builder; `run_command`, `view_file` for reviewer).
    3. Include explicit `Return Contract` sections.
    4. Create corresponding `.yaml` sidecars.
    
    AVOID: Using invalid tools in the frontmatter.
    USE: Correct valid tool list from `scripts/validate-agents.sh`.
  </action>
  <verify>
    bash scripts/validate-agents.sh
  </verify>
  <done>
    Both agents pass validation without errors.
  </done>
</task>

<task type="auto">
  <name>Create pi-debugger definition</name>
  <files>
    .agents/agents/pi-debugger.md
    .agents/agents/pi-debugger.yaml
  </files>
  <action>
    Create the `pi-debugger` subagent profile in `.agents/agents/`.
    
    Steps:
    1. Create the `.md` file with `name: pi-debugger`, `description`, `subagent: true`, and relevant tools (e.g., `run_command`, `view_file`, `grep_search`).
    2. Include `Return Contract` section.
    3. Create the corresponding `.yaml` sidecar.
  </action>
  <verify>
    bash scripts/validate-agents.sh
  </verify>
  <done>
    `pi-debugger.md` passes validation with zero errors.
  </done>
</task>

## Must-Haves
After all tasks complete, verify:
- [ ] Execution and Quality roles (`pi-builder`, `pi-reviewer`, `pi-debugger`) created.
- [ ] Automated validation passing with 0 errors via `validate-agents.sh`.

## Success Criteria
- [ ] All tasks verified passing
- [ ] Must-haves confirmed
- [ ] No regressions in tests

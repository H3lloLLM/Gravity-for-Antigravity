---
phase: 2
plan: 1
wave: 1
depends_on: []
gap_closure: false
---

# Plan 2.1: Reconnaissance and Planning Roles

## Objective
Implement the reconnaissance and planning subagent roles (`pi-scout`, `pi-planner`, and `pi-investigator`) along with their YAML sidecars to establish the foundation of the Pi Harness Subagent Suite.

## Context
Load these files for context:
- .gsd/SPEC.md
- .gsd/ROADMAP.md
- scripts/validate-agents.sh

## Tasks

<task type="auto">
  <name>Create pi-scout and pi-planner definitions</name>
  <files>
    .agents/agents/pi-scout.md
    .agents/agents/pi-scout.yaml
    .agents/agents/pi-planner.md
    .agents/agents/pi-planner.yaml
  </files>
  <action>
    Create the `pi-scout` and `pi-planner` subagent profiles in `.agents/agents/`.
    
    Steps:
    1. For both agents, create a `.md` file with strict YAML frontmatter.
    2. Ensure `name` exactly matches the filename, `subagent: true`, and `description` is provided.
    3. Include a subset of valid tools (e.g., `view_file`, `list_dir`, `find_by_name`, `grep_search` for scout).
    4. Provide a `Return Contract` section guiding how the agent communicates completion.
    5. Create corresponding empty or minimal YAML sidecar files (`.yaml`).
    
    AVOID: Including non-existent tools like `cat` or `grep`.
    USE: Only valid Antigravity tools recognised by `scripts/validate-agents.sh`.
  </action>
  <verify>
    bash scripts/validate-agents.sh
  </verify>
  <done>
    Both agents pass validation without errors.
  </done>
</task>

<task type="auto">
  <name>Create pi-investigator definition</name>
  <files>
    .agents/agents/pi-investigator.md
    .agents/agents/pi-investigator.yaml
  </files>
  <action>
    Create the `pi-investigator` subagent profile in `.agents/agents/`.
    
    Steps:
    1. Create the `.md` file with `name: pi-investigator`, `subagent: true`, `description`, and valid `tools` like `search_web`, `read_url_content`, `view_file`.
    2. Add the `Return Contract` section.
    3. Create the corresponding `.yaml` sidecar.
    
    AVOID: Omitting the Return Contract section.
    USE: Strict adherence to `scripts/validate-agents.sh` rules.
  </action>
  <verify>
    bash scripts/validate-agents.sh
  </verify>
  <done>
    `pi-investigator.md` passes validation without errors.
  </done>
</task>

## Must-Haves
After all tasks complete, verify:
- [ ] Reconnaissance and Planning roles (`pi-scout`, `pi-planner`, `pi-investigator`) created.
- [ ] YAML frontmatter rules strictly adhered to.

## Success Criteria
- [ ] All tasks verified passing
- [ ] Must-haves confirmed
- [ ] No regressions in tests

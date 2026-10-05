---
phase: 3
plan: 1
wave: 1
gap_closure: false
depends_on: []
---

# Plan 3.1: Model Capability Routing Configuration

## Objective
Update the model capabilities configuration to explicitly map the Pi Harness subagent roles to their appropriate model tiers, and ensure the execution scripts can read and respect these configurations per REQ-09.

## Context
Load these files for context:
- .gsd/SPEC.md
- .gsd/DECISIONS.md
- model_capabilities.yaml
- scripts/parallel_subagents.py

## Tasks

<task type="auto">
  <name>Update model_capabilities.yaml with Pi agent mappings</name>
  <files>
    model_capabilities.yaml
  </files>
  <action>
    Add a new section mapping the 6 Pi Harness subagent roles to their assigned models as specified in DECISIONS.md:
    - pi-scout -> gemini-3.8-flash-low
    - pi-planner -> gemini-3.8-flash-high
    - pi-builder -> gemini-3.8-flash-low
    - pi-reviewer -> gemini-3.8-flash-medium
    - pi-debugger -> gemini-3.8-flash-medium
    - pi-investigator -> gemini-3.8-flash-medium
    
    Steps:
    1. Open model_capabilities.yaml.
    2. Add a `role_mappings` dictionary (or append to existing model configurations) mapping the 6 Pi roles to their models.
    
    AVOID: Modifying existing base model definitions unnecessarily.
    USE: Exact slug names matching DECISIONS.md.
  </action>
  <verify>
    grep "pi-scout" model_capabilities.yaml
  </verify>
  <done>
    model_capabilities.yaml contains the 6 pi-* agent roles mapped to their gemini-3.8-flash-* models.
  </done>
</task>

<task type="auto">
  <name>Ensure execution scripts use model mappings</name>
  <files>
    scripts/parallel_subagents.py
  </files>
  <action>
    Update the parallel batch runner script to parse `model_capabilities.yaml` and resolve a subagent's role to its specified model if a model is not explicitly passed.
    
    Steps:
    1. Import `yaml` in `scripts/parallel_subagents.py`.
    2. Read `model_capabilities.yaml` and extract the role mapping.
    3. If a task manifest assigns a role (e.g. `pi-scout`) but no explicit model, default to the one in the mapping.
    4. Pass this resolved model to the `subagent.sh` invocation.
  </action>
  <verify>
    python3 -c "import yaml"
  </verify>
  <done>
    Script correctly parses model mappings and falls back to them when no explicit model is provided.
  </done>
</task>

## Must-Haves
After all tasks complete, verify:
- [ ] Model capability routing configuration defined for Pi subagent roles (mapping roles to optimal models).

## Success Criteria
- [ ] All tasks verified passing
- [ ] Must-haves confirmed
- [ ] No regressions in tests

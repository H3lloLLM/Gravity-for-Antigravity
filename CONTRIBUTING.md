# Contributing to Pi Harness

Thank you for helping build Pi Harness! We welcome contributions that improve multi-agent efficiency, enhance context hygiene, or add new specialist capabilities.

Please follow these guidelines to keep the codebase consistent, lean, and reliable.

---

## Code of Conduct & Core Philosophy

Pi Harness follows the principles defined in [PROJECT_RULES.md](PROJECT_RULES.md) and [GSD-STYLE.md](GSD-STYLE.md):
- **Orchestrate, don't cogitate:** The orchestrator coordinates and synthesizes; subagents do the heavy lifting in disposable contexts.
- **Empirical proof over trust:** Every change requires verifiable evidence before being marked complete.
- **Strict context hygiene:** Avoid polluting parent conversations; always pass file paths instead of dumping contents.
- **No enterprise theater:** Keep workflows concise, direct, and practical.

---

## Adding a New Subagent

To add a new subagent role:

1. **Create the subagent prompt definition:**
   Create `.agents/agents/<agent-name>.md` with valid YAML frontmatter and an imperative, single-shot system prompt:
   ```markdown
   ---
   name: <agent-name>
   description: <One-line purpose description>
   tools:
     - view_file
     - run_command
     - send_message
   subagent: true
   ---

   You are <agent-name>...
   ```
   > ⚠️ **Note:** All declared tools must be recognised by Google Antigravity and pass `scripts/validate-agents.sh`.

2. **Create the model sidecar:**
   Create `.agents/agents/<agent-name>.yaml` declaring the pinned model tier or slug:
   ```yaml
   model: gemini-3.8-flash-medium
   ```

3. **Update model routing registry:**
   Add the role mapping in [model_capabilities.yaml](model_capabilities.yaml):
   ```yaml
   role_mappings:
     <agent-name>: gemini-3.8-flash-medium
   ```

4. **Copy to local plugin cache (if testing locally):**
   ```bash
   cp .agents/agents/<agent-name>.* ~/.gemini/config/plugins/pi-harness/agents/
   ```

---

## Code Style & Conventions

- **Prompts & Workflows:** Follow the XML tagging and imperative conventions documented in [GSD-STYLE.md](GSD-STYLE.md).
- **Shell Scripts:** Maintain cross-platform portability.
  - Never chain commands with `&&` or `||` in workflows; execute commands individually.
  - Provide both `.sh` (POSIX/Bash) and `.ps1` (PowerShell 5.1/7+) implementations for developer-facing scripts.
- **Brevity with Substance:** Remove filler phrases and sycophancy from prompts and documentation.

---

## Commit Message Conventions

We use conventional commit messages:

```
type(scope): description
```

### Types
| Type | Usage |
|---|---|
| `feat` | New feature or subagent |
| `fix` | Bug fix or regex adjustment |
| `docs` | Documentation changes |
| `refactor` | Code restructuring without behavior changes |
| `test` | Adding or updating tests |
| `chore` | Maintenance or release tasks |

### Examples
- `feat(agents): add pi-architect subagent and yaml sidecar`
- `fix(scripts): handle spaces in paths within subagent.sh`
- `docs(runbook): add troubleshooting note for parallel dispatcher`

---

## Local Validation Suite

Before opening a pull request, run the test suites locally to ensure zero errors:

### POSIX (Linux / macOS)
```bash
# 1. Validate all subagents and skills
bash scripts/validate-agents.sh

# 2. Run sidecar slug and mock execution tests
bash tests/test_agent_validation.sh

# 3. (Optional) Run the full validation suite
bash scripts/validate-all.sh
```

### Windows (PowerShell)
```powershell
# 1. Validate all subagents
.\scripts\validate-agents.ps1

# 2. Run all validation checks
.\scripts\validate-all.ps1
```

---

## Pull Request Checklist

Before submitting your pull request, verify that:

- [ ] `bash scripts/validate-agents.sh` passes with 0 errors.
- [ ] `bash tests/test_agent_validation.sh` passes with 0 errors.
- [ ] Any new subagent includes both `.md` specification and `.yaml` model sidecar.
- [ ] Role mappings in `model_capabilities.yaml` are updated if applicable.
- [ ] Documentation ([README.md](README.md), [docs/RUNBOOK.md](docs/RUNBOOK.md)) is updated to reflect new roles or flags.
- [ ] Commit history is atomic and follows `type(scope): description`.

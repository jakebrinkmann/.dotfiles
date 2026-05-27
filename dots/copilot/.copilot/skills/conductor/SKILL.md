---
name: conductor
description: "Best practices, schema constraints, and hard-won patterns for authoring Microsoft Conductor workflows (YAML). Covers agent types, routing, for_each, parallel, human_gate, Jinja2 templating, and script agent contracts."
---

# Skill: Microsoft Conductor Workflow Best Practices

## 1. Agent Types — Constraints Matrix

| `type` | `output:` block | Inside `parallel:` | Notes |
|---|---|---|---|
| `agent` (LLM) | ✅ required | ✅ allowed | Default for LLM calls |
| `script` | ❌ **forbidden** | ❌ **forbidden** | Output captured from stdout JSON |
| `workflow` | ✅ optional | ✅ allowed | Sub-workflow call |
| `human_gate` | ❌ | ✅ allowed | Options use `route:` (singular) |

**`type: script` output contract:**
- Print a single JSON object on stdout: `print(json.dumps({...}))`
- Fields accessible downstream as `agent_name.output.<field>`
- Also exposes `agent_name.output.exit_code`, `.stdout`, `.stderr`
- Never use `output:` block on a script agent — validation error

---

## 2. `for_each` — Syntax

`for_each:` is a **top-level YAML key**, not an agent type:

```yaml
for_each:
  - name: my_loop
    source: prior_agent.output.items   # array of objects
    as: item                            # loop variable
    agent:
      name: per_item_agent             # name: required!
      type: agent
      prompt: "Process {{ item.id }}"
    routes:
      - to: next_after_loop            # post-loop routing
```

- `source` must be an array of objects (not strings) if you use `{{ item.field }}`
- `routes:` on the `for_each` block fires **after all iterations complete**
- Never put `routes:` on the inline `agent:` inside `for_each`

---

## 3. `parallel:` — Syntax

```yaml
parallel:
  - name: group_a
    agents: [agent_one, agent_two]     # name references to top-level agents
    routes:
      - to: after_parallel
```

- Agents inside `parallel:` groups **must not have their own `routes:`**
- `type: script` agents **cannot** appear inside `parallel:` groups
- Each group item is prefixed with `-` (it's a list, not a mapping)

---

## 4. `human_gate` — Options Syntax

```yaml
- name: review_gate
  type: human_gate
  prompt: "Approve or reject?"
  options:
    - label: Approve
      route: next_step          # route: singular, string — NOT routes:
    - label: Reject
      route: $end
```

- `route:` is **singular** inside each option object
- Do **not** use `routes:` list with `when:` conditions for human gates

---

## 5. Context Modes

| Mode | Behaviour |
|---|---|
| `accumulate` | All agent outputs shared automatically (default — use this) |
| `explicit` | Agents must declare `input:` to access prior outputs |

```yaml
workflow:
  context:
    mode: accumulate
```

---

## 6. Jinja2 in Script Args — Gotchas

Script `args:` content is **Jinja2-rendered before the shell/Python runs**:

```yaml
args:
  - -c
  - |
    workspace_root = "{{ workflow.input.workspace_root }}"
    # ❌ Cannot use bash variables inside Jinja2: {{ $MYVAR }}
    # ✅ Use Python for file manipulation, not bash variable expansion
```

**Conditional output (handle optional agents):**
```python
revise_raw = """{{ revise_agent.output.patch if revise_agent is defined else '' }}"""
original   = """{{ original_agent.output.patch }}"""
patch = revise_raw.strip() if revise_raw.strip() else original
```

**`if agent is defined`** guards undefined agent names but does NOT guard missing attributes.
Add `output: { field: type }` to every LLM agent or `agent.output.field` will throw.

---

## 7. Script Agent — Standard Template

```yaml
- name: my_script
  type: script
  description: "What this does"
  command: python3
  working_dir: "{{ workflow.dir }}"
  timeout: 60
  args:
    - "{{ workflow.dir }}/../scripts/my_script.py"
    - "{{ workflow.input.workspace_root }}"
  routes:
    - when: "exit_code == 0"
      to: success_agent
    - when: "exit_code != 0"
      to: error_agent
```

> ⚠️ **Never use a bare `- to: <node>` fallthrough on script nodes.**
> A bare fallthrough (no `when:` condition) is treated as **always-true** and
> is evaluated top-to-bottom — it will fire even when `exit_code == 0`, causing
> the conditional route above it to be skipped entirely.
> **Always use explicit `when: "exit_code != 0"` for the failure path.**
>
> ```yaml
> # ❌ WRONG — fallthrough fires unconditionally, conditional is never reached
> routes:
>   - when: "exit_code == 0"
>     to: human_steering_gate
>   - to: $end            # ← always fires; human_steering_gate never reached
>
> # ✅ CORRECT — both branches are explicit
> routes:
>   - when: "exit_code == 0"
>     to: human_steering_gate
>   - when: "exit_code != 0"
>     to: $end
> ```

---

## 8. Input Naming Convention (this repo)

| Input | Value example | Usage |
|---|---|---|
| `workspace_root` | `.artifacts/dealer-portal` | Path to Stage 1 artifacts dir |
| `ear_path` | `../architecture/ear` | Path to EAR model-as-is topology |
| `reqs` | `/path/to/requirements/` | Raw requirements directory |

Always use `workspace_root` (not `slug`). Derive slug inside scripts:
```python
slug = pathlib.Path(workspace_root).name
```

---

## 9. `conductor validate` Warnings — Safe to Ignore

> "Output template may not run on all paths"

This warning fires when `$output` references a script/agent that can be skipped via a human gate reject path. It is a **warning, not an error**. The workflow is valid.

---

## 10. Operational Rules

- **Run `conductor validate <workflow.yaml>` before every commit** that touches a workflow file — catches schema errors, missing output declarations, and bad route references before they break a live run
- **Never pipe `conductor run` through `head` or any truncating command** — sends SIGPIPE, kills the workflow mid-run
- **Always use `--no-interactive --provider copilot` when launching from a script or sub-workflow**:
  ```bash
  conductor run workflows/<name>.yaml --no-interactive --provider copilot
  ```
  Omitting `--no-interactive` blocks on a TTY prompt in non-interactive environments; omitting `--provider copilot` may fall back to the wrong model.
- Use `conductor resume` to continue from a checkpoint after interruption
- Use `conductor run --web` to open the browser-based progress UI
- Event logs: `/var/folders/.../conductor/conductor-<name>-<timestamp>.events.jsonl`

---

## 11. Output Schema — LLM Agents

Every LLM agent that produces data used downstream **must** declare `output:`:

```yaml
- name: adr_generator
  type: agent
  output:
    adr_count:
      type: number
    decomposition_path:
      type: string
```

Without this, `adr_generator.output.adr_count` throws `'dict object' has no attribute 'adr_count'`.

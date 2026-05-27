---
name: conductor
description: "Best practices, schema constraints, and hard-won patterns for authoring Microsoft Conductor workflows (YAML). Covers agent types, routing, for_each, parallel, human_gate, Jinja2 templating, and script agent contracts."
---

# Skill: Microsoft Conductor Workflow Best Practices

## 1. Agent Types — Constraints Matrix

| `type` | `output:` block | Inside `parallel:` | `input_mapping:` | Notes |
|---|---|---|---|---|
| `agent` (LLM) | ✅ required | ✅ allowed | ❌ | Default for LLM calls |
| `script` | ❌ **forbidden** | ❌ **forbidden** | ❌ | Output captured from stdout JSON |
| `workflow` | ✅ optional | ✅ allowed | ✅ **required for sub-workflow inputs** | Sub-workflow call |
| `human_gate` | ❌ | ✅ allowed | ❌ | Options use `route:` (singular) |

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

**Sub-workflow inside `for_each` — use `input_mapping:`** (not `input:`):

```yaml
for_each:
  - name: per_epic_arch
    source: select_epic.output.epics
    as: epic_data
    agent:
      name: run_per_epic
      type: workflow
      workflow: "per-epic.yaml"
      input_mapping:                       # ← dict, NOT a list!
        epic_data: "{{ epic_data }}"       # loop var → named sub-workflow input
        ear_path: "{{ workflow.input.ear_path }}"
    routes:
      - to: $end
```

> ⚠️ **`input:` (list) ≠ `input_mapping:` (dict).**
> - `input:` is for declaring LLM context dependencies (list of dotpath strings).
> - `input_mapping:` is for passing **named inputs to sub-workflows** (dict of name → Jinja2 expr).
> - Without `input_mapping`, the runtime forwards the **parent's** `workflow.input.*` as-is —
>   it does NOT pass the loop variable. This causes:
>   `TemplateError: 'dict object' has no attribute '<expected_key>'`

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

## 12. `human_gate` — When to Use (Anti-pattern Guide)

**Only add a `human_gate` for one of these two reasons:**

### ✅ A — Fan-out blast radius protection
The gate sits immediately before a `for_each` loop that fans into many
parallel LLM agents (each expensive in time + tokens). A bad upstream
assumption would otherwise waste minutes and API budget across every iteration.

```yaml
# ✅ CORRECT: gate before wildcard for_each fan-out
- name: architect_review         # gate sits before 6-epic Opus loop
  type: human_gate
  ...
for_each:
  - name: per_epic_arch
    source: epics.output.items   # N concurrent Opus agents
```

### ✅ B — IDE injection point
The gate pauses the workflow so the Architect can **open the generated file
in their editor, make manual corrections, and then approve**. The next agent
reads the edited file off disk and treats it as ground truth.

```yaml
# ✅ CORRECT: gate so architect can edit decomposition.json before fan-out
- name: architect_review
  type: human_gate
  prompt: |
    Open {{ workspace_root }}/decomposition.json and edit as needed.
    Press Approve when the file reflects your intent.
```

### ✅ C — Irreversible remote mutation
The gate sits immediately before a step that **writes to an external system**
(Git remote, ADO, Slack, etc.). These side-effects cannot be undone by
re-running the pipeline.

```yaml
# ✅ CORRECT: gate before MCP write to ADO / EAR repo
- name: ado_blast_radius_gate
  type: human_gate
  ...
- name: ado_writer           # creates real work items — irreversible
```

### ❌ Anti-pattern: safety gate for local `.artifacts/` writes
**Never add a `human_gate` solely to "check" output before it is written
to `.artifacts/`.** `.artifacts/` is an ephemeral, `.gitignore`d scratch
space — bad output there has zero consequences. The Architect can always
open the file in their IDE, fix it, and re-run (or just move on to 3x
publisher which is the real gate).

```yaml
# ❌ WRONG — pure safety gate with only $end routes
- name: human_review
  type: human_gate
  prompt: "Review the Trinity files. Approve when satisfied."
  options:
    - label: "Approve"
      route: $end         # only route is $end — adds friction, no value
```

**Decision rule:**
> If removing the gate would cause the pipeline to write the SAME files to
> the SAME place (`.artifacts/`) — remove it. The 3x Publisher series owns
> the real gates before remote mutations.

---


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

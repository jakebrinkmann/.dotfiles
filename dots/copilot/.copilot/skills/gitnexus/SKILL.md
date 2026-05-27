---
name: gitnexus
description: "GitNexus code intelligence workflow — impact analysis before edits, detect_changes before commits, safe rename, and query-first exploration. Applies to any GitNexus-indexed repository."
---

# Skill: GitNexus Code Intelligence

## Always Do

- **Before editing any symbol** — run impact analysis and report the blast radius:
  ```
  gitnexus_impact({ target: "symbolName", direction: "upstream" })
  ```
  Report: direct callers (d=1), affected processes, risk level. Stop and warn if HIGH or CRITICAL.

- **Before committing** — verify scope of changes:
  ```
  gitnexus_detect_changes()
  ```
  Confirm only expected symbols and execution flows are affected.

- **Exploring unfamiliar code** — use query first, not grep:
  ```
  gitnexus_query({ query: "concept or feature" })
  ```
  Returns process-grouped results ranked by relevance.

- **Full symbol context** (callers, callees, execution flows):
  ```
  gitnexus_context({ name: "symbolName" })
  ```

## Never Do

- Never edit a function, class, or method without first running `gitnexus_impact`.
- Never ignore HIGH or CRITICAL risk warnings — surface them to the user before proceeding.
- Never rename with find-and-replace — use `gitnexus_rename` which understands the call graph.
- Never commit without running `gitnexus_detect_changes()`.

## Key Resources (substitute `{repo}` with the indexed repo name)

| Resource | Use for |
|---|---|
| `gitnexus://repo/{repo}/context` | Codebase overview, index freshness |
| `gitnexus://repo/{repo}/clusters` | All functional areas |
| `gitnexus://repo/{repo}/processes` | All execution flows |
| `gitnexus://repo/{repo}/process/{name}` | Step-by-step execution trace |

If any GitNexus tool warns the index is stale, run `npx gitnexus analyze` first.

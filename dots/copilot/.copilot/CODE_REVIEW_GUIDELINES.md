# Lightweight Code Review Guidelines

## 📜 The Philosophy: Pragmatism Over Perfection

Our goal is to merge code efficiently and safely. We use linters to enforce style. This review process is designed to catch high-level issues, not to debate stylistic preferences.

**The Golden Rule:** If the linter passed, **DO NOT** comment on formatting, variable naming, or other stylistic "nit-picks" unless you use the `suggestion (non-blocking)` format.

---

## 💬 Comment Format: Conventional Comments

All feedback **MUST** follow the [Conventional Comments](https://conventionalcomments.org/) standard. This helps us (and AI reviewers like Copilot) categorize feedback clearly.

**Format:** `<label> (decoration): <subject>`

### Labels to Use:

- `issue`: A clear bug, security flaw, or architectural problem.
- `suggestion`: An improvement or a better way to do something.
- `question`: A query to understand the code.

### Decorations to Use:

- `(blocking)`: **This MUST be fixed.** Use this for all "Egregious Issues" found in the checklist below.
- `(non-blocking)`: **This is optional.** Use this for stylistic nitpicks, refactoring ideas, or minor suggestions.

### Examples:

- **Blocking Issue:** `issue (blocking): This query is N+1 and will crash the server under load.`
- **Security Issue:** `issue (blocking, security): This endpoint is vulnerable to SQL injection.`
- **Optional Suggestion:** `suggestion (non-blocking): We could simplify this logic using a 'switch' statement.`
- **Nitpick (formerly `[Nitpick]:`):** `suggestion (non-blocking): Minor typo in this variable name.`

---

## Reviewer's Checklist: Focus Only on "Egregious" Issues

Your review should be a quick check for the following "Egregious Issues." If found, they **MUST** be commented on using the `issue (blocking)` format.

If you don't see any, approve the PR.

### 1. 🎯 Logic & Intent

- Does this code fail to accomplish the stated goal of the PR/Task?
- Is there a clear and obvious bug or logic error?

### 2. 🛡️ Security & Safety

- Does this introduce any obvious, critical vulnerabilities?
- Is user-provided input being trusted without proper sanitization (e.g., potential for SQL injection, XSS)?
- Are secrets, API keys, or connection strings being hard-coded?
- Does this introduce any insecure direct object references or expose unnecessary data?

### 3. 🚀 Performance

- Is there a clear, high-impact performance trap?
  - An $N+1$ query (e.g., looping and running a query inside the loop).
  - Fetching or processing a massive, un-paginated dataset unnecessarily.

### 4. 🏛️ Architecture

- Does this code commit a major architectural violation (e.g., modifying core framework files, bypassing established patterns)?
- Is business logic being incorrectly placed (e.g., complex logic in a view/UI component instead of a service, controller, or model)?
- Does this introduce code that violates core principles (e.g., a function that is not idempotent, a component that is dangerously long-running, or use of an anti-pattern)?

### 5. 💣 Error Handling

- Does this code lack _any_ error handling for a critical operation (e.g., an API call, database write, or file transaction)?
- Does it "swallow" exceptions silently (`catch (e) {}`)?

---

## ✅ How to Approve

If the PR passes the linter and you cannot find any of the "egregious" issues listed above:

1. Approve the Pull Request.
2. A simple "LGTM" (Looks Good To Me) comment is sufficient.

If you leave any optional, non-blocking feedback, you **MUST** use the `suggestion (non-blocking)` format.

#!/usr/bin/env bash

#
# CORE GEMINI AGENT
# This is the internal function that all other helpers will call.
#
function _ai_gemini_agent() {
  # 1. Check for API key. Fail early if it's not set. [cite: 2]
  if [[ -z "$GEMINI_API_KEY" ]]; then
    echo "Error: GEMINI_API_KEY environment variable is not set." >&2 [cite: 3]
    return 1
  fi

  # 2. Get the prompt from the first argument. [cite: 4]
  local PROMPT
  PROMPT="$1"
  if [[ -z "$PROMPT" ]]; then
    echo "Usage: [cat context |] _ai_gemini_agent \"Your prompt\"" >&2 [cite: 5]
    return 1
  fi

  # 3. Get the context from stdin (if it's being piped in). [cite: 6]
  local CONTEXT
  if [ ! -t 0 ]; then
    CONTEXT=$(cat)
  fi

  # 4. Build the combined text payload. [cite: 7]
  local PAYLOAD_TEXT
  if [[ -n "$CONTEXT" ]]; then
    # \n is a separator.
    PAYLOAD_TEXT="CONTEXT:\n${CONTEXT}\n\nTASK:\n${PROMPT}"
  else
    PAYLOAD_TEXT="${PROMPT}"
  fi

  # 5. Build the JSON payload using jq for safety. [cite: 9]
  local JSON_PAYLOAD
  JSON_PAYLOAD=$(jq -n \
    --arg text "$PAYLOAD_TEXT" \
    '{contents: [{parts: [{text: $text}]}]}')

  # 6. Call the Gemini API and parse the response. [cite: 10, 11]
  curl -s \
    -H "Content-Type: application/json" \
    -H "x-goog-api-key: $GEMINI_API_KEY" \
    -X POST \
    "https://generativelen.googleapis.com/v1beta/models/gemini-1.5-pro-latest:generateContent" \
    -d "$JSON_PAYLOAD" |
    jq -r '.candidates[0].content.parts[0].text' [cite: 12]
}

#
# HELPER FUNCTIONS
# All 50 functions, corrected to call _ai_gemini_agent
#

# Git & Version Control
# 1. Review staged changes for code review
function review-diff() {
  git diff --cached | _ai_gemini_agent "You are a pragmatic code reviewer. Review this diff, focusing on our rules:
  1. YAGNI: Is this code necessary?
  2. Simplicity: Is it readable and maintainable?
  3. Naming: Do names describe purpose, not implementation? (NO 'New', 'Legacy', 'Wrapper').
  4. TDD: Are there corresponding tests?
  5. Comments: Are comments 'what' or 'why', not 'how'?
  Provide a list of concise, actionable feedback." [cite: 13, 14]
}

# 2. Review a specific commit
function review-commit() {
  git show $1 | _ai_gemini_agent "You are a code reviewer. Analyze this commit ($1) for bugs, style issues, or bad naming." [cite: 15, 16]
}

# 3. Write a commit message for staged changes
function write-commit-msg() {
  git diff --cached | _ai_gemini_agent "You are a git expert. Write an imperative, 50-character-max subject line for this diff.
  After a blank line, write a concise body explaining 'what' and 'why'.
  Do NOT explain the 'how'.
  Format:
  Subject line

  Body...
  " [cite: 17]
}

# 4. Suggest a branch name for a task
function name-branch() {
  cat - | _ai_gemini_agent "Read this task description or user story.
  Suggest 3 short, descriptive git branch names using 'type/description' format (e.g., 'feature/user-login', 'bugfix/payment-crash')." [cite: 18, 19]
}

# 5. Review a diff specifically for breaking changes
function find-breaking-change() {
  git diff --cached | _ai_gemini_agent "You are an API stability expert.
  Analyze this diff. Identify ANY change that would break a downstream consumer:
  - Changed function signatures
  - Removed or renamed JSON fields
  - Changed API routes
  - Database schema modifications
  If no breaking changes are found, respond with 'No breaking changes detected.'
  If found, list them clearly." [cite: 20, 21]
}

# Code Review & Quality
# 6. Check for security vulnerabilities
function review-security() {
  git diff --cached | _ai_gemini_agent "You are a security auditor.
  Review this diff for common vulnerabilities (OWASP Top 10):
  - SQL Injection
  - Cross-Site Scripting (XSS)
  - Insecure Deserialization
  - Hardcoded secrets or API keys
  - Broken Access Control
  - Unsafe use of 'exec' or 'eval'
  List any potential issues and suggest a fix." [cite: 22, 23]
}

# 7. Check for performance bottlenecks
function review-performance() {
  git diff --cached | _ai_gemini_agent "You are a performance engineer.
  Review this diff for common performance anti-patterns:
  - N+1 queries (loops making DB calls)
  - Inefficient loops
  - Unnecessary full table scans
  - Lack of caching for expensive operations
  - Blocking I/O in an async context
  List any potential issues and suggest a fix." [cite: 24, 25]
}

# 8. Check for bad naming conventions (Our Rule)
function check-naming() {
  cat $1 | _ai_gemini_agent "You are a naming convention expert.
  Read this file and identify ANY names (variables, functions, classes) that violate our rules:
  - NO implementation details (e.g., 'ZodValidator', 'JsonParser')
  - NO temporal context (e.g., 'NewAPI', 'LegacyHandler', 'ImprovedInterface')
  - NO pattern names (e.g., 'ToolFactory', 'RegistryManager')
  For each bad name, suggest a better one that describes its domain purpose." [cite: 26, 27]
}

# 9. Critique a file's overall readability
function refactor-readability() {
  cat $1 | _ai_gemini_agent "You are a clean code expert.
  Read this file and suggest 5-10 refactoring opportunities to improve readability, maintainability, and simplicity.
  Focus on:
  - Simplifying complex conditionals
  - Extracting long methods
  - Renaming variables for clarity
  - Reducing nesting depth
  Provide 'before' and 'after' snippets for your suggestions." [cite: 28, 29]
}

# 10. Check a PR description
function check-pr-description() {
  cat $1 | _ai_gemini_agent "You are a technical writer.
  Review this Pull Request description text.
  Does it clearly explain 'what' the change is and 'why' it's being made?
  Is it missing a 'How to test' section?
  Rewrite it to be a perfect PR description." [cite: 30, 31]
}

# Testing (TDD & QA)
# 11. Write human-readable test scenarios
function write-test-scenarios() {
  cat $1 | _ai_gemini_agent "Read this code file.
  Generate a list of human-readable test scenarios (Given/When/Then format) needed to fully test it.
  Include:
  - Happy path scenarios
  - Edge cases (e.g., null inputs, empty lists)
  - Error handling (e.g., bad input, exceptions)
  " [cite: 32]
}

# 12. Write a failing unit test (TDD)
function write-failing-test() {
  local FEATURE_DESC=$1
  local FRAMEWORK=$2
  cat - | _ai_gemini_agent "You are a TDD expert. Read this code.
  I need to add a new feature: '$FEATURE_DESC'.
  Write a new, complete, self-contained '$FRAMEWORK' test file that fails *because* this feature is not yet implemented.
  The test MUST:
  1. Correctly validate the desired functionality.
  2. Fail until the new code is written.
  3. Include all necessary imports and mocks.
  Return only the complete, new contents of the test file." [cite: 34, 35]
}

# 13. Write unit tests for an existing file
function write-unit-tests() {
  cat - | _ai_gemini_agent "You are a $1 testing expert. Read this code.
  Write a complete, robust unit test suite for this file.
  - Mock ALL external dependencies (DBs, APIs, other modules).
  - Aim for 100% line and branch coverage.
  - Follow best practices for $1.
  - Return only the complete contents of the test file." [cite: 37]
}

# 14. Write an integration test for two files
function write-integration-test() {
  cat - | _ai_gemini_agent "Read these code files.
  Write a '$1' integration test that verifies they work together correctly.
  - Do NOT mock the interaction between these files.
  - Mock any *other* external dependencies (DBs, APIs).
  - Focus on the data flow and contracts between the provided files." [cite: 39]
}

# 15. Fix a failing test (The "Red-Green" step)
function fix-failing-test() {
  cat - | _ai_gemini_agent "You are a TDD expert. The piped-in context contains:
  1. The implementation file(s).
  2. The test file(s).
  3. The 'pytest' output showing a failure.
  Your task is to fix the *implementation code* (NOT the test) to make the failing test pass.
  Write ONLY the complete, new contents of the modified implementation file." [cite: 41]
}

# 16. Add edge cases to a test file
function harden-tests() {
  cat $1 | _ai_gemini_agent "Read this test file. It's too focused on the happy path.
  Rewrite it, adding more robust test cases:
  - Parameterize tests for different inputs.
  - Add tests for edge cases (null, 0, empty strings, large numbers).
  - Add tests for expected exceptions (e.g., 'pytest.raises')." [cite: 42, 43]
}

# 17. Write a mock patch
function write-mock-patch() {
  cat - | _ai_gemini_agent "Read this Python file. I need to write a '$2' test for it.
  Show me the exact 'unittest.mock.patch' or 'monkeypatch' syntax needed to mock the function '$1' within this file.
  Provide a brief example of its use in a test function." [cite: 45]
}

# 18. Write an E2E test script
function write-e2e-script() {
  cat - | _ai_gemini_agent "Read this user story.
  Write a complete '$1' end-to-end test script that validates this story.
  - Include selectors (e.g., 'cy.get(...)').
  - Include assertions (e.g., 'should('have.text', ...)')
  - Make it robust and readable." [cite: 47]
}

# Code Generation & Scaffolding
# 19. Scaffold a new class/module
function scaffold-module() {
  _ai_gemini_agent "You are a pragmatic software architect.
  Generate the complete, single-file boilerplate for a '$2' in '$1'.
  - Follow all our naming and style rules.
  - Include the 'ABOUTME' comment at the top.
  - Include docstrings and 'TODO' comments for implementation.
  - Do not over-engineer; keep it simple." [cite: 48, 49]
}

# 20. Implement a function from a stub
function implement-function() {
  cat - | _ai_gemini_agent "Read this file containing a function stub (with a docstring and signature).
  Write the simple, pragmatic, and correct implementation for the function.
  Return the complete file content, with the function implemented." [cite: 51]
}

# 21. Write a Dockerfile for a project
function write-dockerfile() {
  cat - | _ai_gemini_agent "Read this file listing (from 'ls -R').
  Based on the file list, write an optimized, multi-stage Dockerfile for a '$1' application.
  - Use a minimal base image.
  - Copy dependencies (e.g., requirements.txt) and install them in a separate layer.
  - Copy the application code.
  - Set a non-root user.
  - Define the correct 'CMD' or 'ENTRYPOINT'." [cite: 53]
}

# 22. Write a GitHub Actions workflow
function write-github-action() {
  cat - | _ai_gemini_agent "Read this file listing (from 'ls -R').
  I need a GitHub Actions workflow that will '$2'.
  Write the complete YAML file (e.g., '.github/workflows/ci.yml').
  - Give it a clear name.
  - Set the 'on' trigger correctly.
  - Define the jobs, steps, and required 'uses' actions (e.g., 'actions/checkout@v3')." [cite: 55, 56]
}

# 23. Write a script
function write-bash-script() {
  _ai_gemini_agent "You are a shell scripting expert.
  Write a complete, robust bash script that: '$1'.
  - Use 'set -euo pipefail'.
  - Include argument parsing (e.g., 'getopts') if needed.
  - Include a 'usage()' function.
  - Add comments explaining complex logic." [cite: 57]
}

# 24. Implement a regex
function write-regex() {
  _ai_gemini_agent "You are a regex expert.
  I need to match: '$1'.
  It should NOT match: '$2'.
  Provide the regex, an explanation of its parts, and examples in Python." [cite: 58]
}

# 25. Generate boilerplate from a spec
function implement-spec() {
  cat $1 | _ai_gemini_agent "Read this API spec (e.g., OpenAPI yaml or just text).
  Generate the boilerplate server-side code for it in '$2' (e.g., 'FastAPI').
  - Create the models (e.g., Pydantic).
  - Create the route stubs.
  - Return the complete, single file." [cite: 59, 60]
}

# Refactoring
# 26. Find and refactor duplicated code (DRY)
function refactor-dry() {
  cat $1 | _ai_gemini_agent "Read this file.
  Identify the most obvious violation of 'Don't Repeat Yourself' (DRY).
  Rewrite the file, extracting the duplicated logic into a new, private helper function.
  Return the complete, refactored file." [cite: 61, 62]
}

# 27. Extract a method
function refactor-to-function() {
  cat - | _ai_gemini_agent "This piped-in code snippet was extracted from a larger function.
  It needs to become a new, standalone function.
  Your task:
  1. Infer the correct function signature (arguments and return value).
  2. Give it a good, descriptive name (e.g., 'calculate_user_permissions').
  3. Write the complete function definition.
  The new function name should be: '$1'." [cite: 63, 64]
}

# 28. Convert a script to a class
function refactor-to-class() {
  cat $1 | _ai_gemini_agent "Read this procedural script. It's getting messy.
  Refactor it into a single, well-named class.
  - State should become class properties.
  - Logic should become class methods.
  - The main execution flow should be a 'run()' or 'execute()' method.
  - The class name should be: '$2'." [cite: 65, 66]
}

# 29. Simplify a complex conditional
function refactor-conditional() {
  cat - | _ai_gemini_agent "This piped-in code contains a complex 'if/elif/else' block or 'match' statement.
  Rewrite it to be simpler and more readable.
  Consider using:
  - Guard clauses (early returns)
  - Polymorphism (e.g., a dictionary lookup)
  - De Morgan's Law
  Return just the refactored code block." [cite: 67, 68]
}

# 30. Convert a file to be async
function refactor-to-async() {
  cat $1 | _ai_gemini_agent "Read this synchronous '$2' (e.g., 'Python Flask') file.
  Rewrite it to be asynchronous (e.g., 'async/await', 'FastAPI').
  - Update function definitions with 'async def'.
  - Use 'await' for blocking I/O.
  - Update any 'return' statements to be compatible.
  Return the complete, new file." [cite: 69, 70]
}

# Documentation & Comments
# 31. Write the ABOUTME header (Our Rule)
function write-aboutme() {
  cat $1 | _ai_gemini_agent "Read this file.
  Write a perfect 2-line 'ABOUTME' comment for the very top.
  // ABOUTME: [What this file does]
  // ABOUTME: [Its primary responsibility in the system]
  " [cite: 71]
}

# 32. Write docstrings for a file
function write-docstrings() {
  cat - | _ai_gemini_agent "Read this file.
  Rewrite the entire file, adding complete docstrings for every class and function.
  Use '$1' style (e.g., 'google', 'numpy', 'reST').
  - Describe what the function does.
  - List all 'Args:'.
  - List the 'Returns:' value.
  - Raise any 'Raises:' exceptions.
  Return the complete, new file." [cite: 73]
}

# 33. Explain a block of code
function explain-code() {
  cat - | _ai_gemini_agent "You are a senior engineer mentoring a junior.
  Explain this piped-in code block in simple, clear terms.
  - What is its purpose?
  - How does it work, step-by-step?
  - Why might it be written this way?
  - Is there a 'gotcha' or hidden complexity?" [cite: 74, 75]
}

# 34. Generate a README section
function write-readme-section() {
  cat - | _ai_gemini_agent "The piped-in context contains a README.md and a new code file.
  Write a new '$1' section for the README that explains how to use this new code.
  - Include code blocks for examples.
  - Keep it concise.
  - Match the existing README's markdown style." [cite: 77]
}

# 35. Update a comment that is out of date
function fix-comment() {
  cat $1 | _ai_gemini_agent "Read this file.
  Find one comment that seems incorrect or out of sync with the code it describes.
  Rewrite the comment to be accurate and useful.
  Return the complete, new file." [cite: 78, 79]
}

# Debugging & Error Analysis
# 36. Explain a stack trace
function explain-error() {
  cat - | _ai_gemini_agent "You are a master debugger. Read this stack trace.
  Explain the error in plain English:
  1. What is the root cause of the error? (e.g., 'TypeError', 'KeyError')
  2. Where did it happen? (File and line number)
  3. What is the most likely reason this error occurred?
  4. Suggest 3 possible ways to fix it." [cite: 80, 81]
}

# 37. Analyze a log file
function analyze-log() {
  cat - | _ai_gemini_agent "You are a log analysis tool.
  Read this large log file.
  Perform the following task: '$1'.
  Provide a concise summary of your findings." [cite: 83, 84]
}

# 38. Suggest debugging steps
function debug-this() {
  cat - | _ai_gemini_agent "I have a bug. The context contains the code file and a user's report.
  I don't know where to start.
  Give me a pragmatic, step-by-step debugging plan:
  1. What is your first hypothesis?
  2. What 'print' statement or log should I add first, and where?
  3. What test case should I write to reproduce this?
  4. What is the most likely file/function causing the issue?" [cite: 85, 86]
}

# 39. Find the commit that introduced a bug
function find-bug-commit() {
  cat - | _ai_gemini_agent "The context contains a 'git log -p' (diffs) and an error log.
  Read the diffs and the error.
  Which commit in the log is the most likely to have introduced this bug?
  State the commit hash and your reasoning." [cite: 88]
}

# 40. Write a gdb/pdb command
function write-debugger-command() {
  cat - | _ai_gemini_agent "Read this code. I want to debug it with '$1'.
  Tell me the *exact* command(s) I need to run to '$2'." [cite: 90, 91]
}

# System Design & Architecture
# 41. Critique a design document
function critique-design() {
  cat $1 | _ai_gemini_agent "You are a pragmatic solutions architect.
  Read this design document.
  Critique it based on our rules (YAGNI, simplicity, maintainability).
  - Is it over-engineered?
  - Does it introduce unnecessary complexity?
  - What is the simplest alternative approach?
  - What 3 questions should I ask the author?" [cite: 92, 93]
}

# 42. Compare two technologies
function compare-tech() {
  _ai_gemini_agent "Give me a pragmatic, 80/20 comparison of '$1' vs '$2' for this use case: '$3'.
  - Do NOT give me a generic marketing list.
  - Focus on the real-world trade-offs for a small, pragmatic team.
  - Which one is simpler to operate and maintain?
  - What is the one 'gotcha' for each?
  Conclude with a recommendation." [cite: 94]
}

# 43. Generate system diagrams
function draw-diagram() {
  cat - | _ai_gemini_agent "Read this system specification.
  Generate a '$1' (e.g., 'mermaid', 'plantuml') diagram to visualize it.
  - Keep it high-level (boxes and arrows).
  - Focus on components and data flow.
  Return *only* the complete, valid diagram syntax." [cite: 95, 96]
}

# 44. Define an API contract
function define-api() {
  _ai_gemini_agent "Define a simple, pragmatic JSON REST API contract for this action: '$1'.
  Provide:
  1. The HTTP method and path (e.g., 'POST /users').
  2. A 'curl' example.
  3. An example JSON request body.
  4. An example JSON 200 OK response.
  5. An example JSON 400 Error response." [cite: 97]
}

# Database & Data
# 45. Write a SQL query
function write-sql() {
  cat - | _ai_gemini_agent "Read this SQL schema.
  Write a single, efficient SQL query to: '$1'.
  - Use joins correctly.
  - Use 'EXPLAIN' to optimize if necessary.
  - The dialect is '$2' (e.g., 'PostgreSQL')." [cite: 99, 100]
}

# 46. Optimize a SQL query
function optimize-sql() {
  cat - | _ai_gemini_agent "I have a slow SQL query. The context contains:
  1. The DB schema.
  2. The slow query.
  3. The 'EXPLAIN ANALYZE' query plan.
  Your task:
  1. Identify the bottleneck from the plan (e.g., 'Sequential Scan').
  2. Suggest the 'CREATE INDEX' command to fix it.
  3. Rewrite the query if an index isn't enough." [cite: 102]
}

# 47. Write a database migration
function write-migration() {
  cat - | _ai_gemini_agent "The context shows the 'before' and 'after' state of my DB models.
  Write the '$1' (e.g., 'alembic', 'django') migration file to apply this change.
  - Include both the 'upgrade()' and 'downgrade()' functions.
  - Pay close attention to data types and constraints." [cite: 104]
}

# 48. Generate mock data
function generate-mock-data() {
  cat - | _ai_gemini_agent "Read this JSON schema.
  Generate '$2' rows of realistic-looking mock data in '$1' format (e.g., 'csv', 'json').
  Return *only* the data." [cite: 105, 106]
}

# Shell & Utilities
# 49. Explain a shell command
function explain-shell() {
  _ai_gemini_agent "You are a Linux shell expert.
  Explain this command: '$@'.
  - Break down each pipe and flag.
  - What does it do?
  - Is there a simpler or more modern alternative (e.g., using 'rg' instead of 'grep')?" [cite: 107]
}

# 50. Find a file or code snippet
function find-code() {
  cat - | _ai_gemini_agent "Read this file tree from 'ls -R'.
  I need to find: '$1'.
  Give me the *exact* 'grep' or 'rg' (ripgrep) command to find this.
  - Make the regex precise.
  - Include file-type filters if helpful.
  - Explain why the command works." [cite: 109, 110]
}

#
# --- MAIN _ai ROUTER FUNCTION ---
#
# This is the single entry point you will interact with.
# It checks your first argument and routes to the correct helper function.
#

# Internal helper to show help for a single command
function _ai_show_single_help() {
  local CMD="$1"
  echo "Usage:"
  case "$CMD" in
    "review-diff") echo "  _ai review-diff" && echo "  Reviews staged git changes." ;;
    "review-commit") echo "  _ai review-commit <commit-hash>" && echo "  Reviews a specific commit." ;;
    "write-commit-msg") echo "  _ai write-commit-msg" && echo "  Writes a commit message for staged changes." ;;
    "name-branch") echo "  cat task.txt | _ai name-branch" && echo "  Suggests branch names from a task description." ;;
    "find-breaking-change") echo "  _ai find-breaking-change" && echo "  Reviews staged diff for breaking API changes." ;;
    "review-security") echo "  _ai review-security" && echo "  Reviews staged diff for security vulnerabilities." ;;
    "review-performance") echo "  _ai review-performance" && echo "  Reviews staged diff for performance anti-patterns." ;;
    "check-naming") echo "  _ai check-naming <file-path>" && echo "  Checks a file for bad naming conventions." ;; [cite: 26]
    "refactor-readability") echo "  _ai refactor-readability <file-path>" && echo "  Critiques a file's overall readability." ;; [cite: 28]
    "check-pr-description") echo "  _ai check-pr-description <pr-desc.txt>" && echo "  Reviews a PR description text file." ;; [cite: 30]
    "write-test-scenarios") echo "  cat code.py | _ai write-test-scenarios" && echo "  Generates human-readable test scenarios for a file." ;; [cite: 32]
    "write-failing-test") echo "  cat code.py | _ai write-failing-test \"feature\" \"pytest\"" && echo "  Writes a new failing TDD test." ;; [cite: 33]
    "write-unit-tests") echo "  cat code.py | _ai write-unit-tests \"pytest\"" && echo "  Writes a full unit test suite for a file." ;; [cite: 36]
    "write-integration-test") echo "  (cat f1.py; cat f2.py) | _ai write-integration-test \"pytest\"" && echo "  Writes an integration test for multiple files." ;; [cite: 38]
    "fix-failing-test") echo "  (cat code.py; cat test.py; pytest) | _ai fix-failing-test" && echo "  Fixes implementation code to pass a failing test." ;; [cite: 40]
    "harden-tests") echo "  _ai harden-tests <test_file.py>" && echo "  Adds edge cases to a test file." ;; [cite: 42]
    "write-mock-patch") echo "  cat module.py | _ai write-mock-patch \"func_name\" \"pytest\"" && echo "  Shows how to mock a function in a file." ;; [cite: 44]
    "write-e2e-script") echo "  cat story.txt | _ai write-e2e-script \"Cypress\"" && echo "  Writes an E2E script from a user story." ;; [cite: 46]
    "scaffold-module") echo "  _ai scaffold-module \"Python\" \"UserService class\"" && echo "  Scaffolds a new class or module." ;;
    "implement-function") echo "  cat stub.py | _ai implement-function" && echo "  Implements a function from a stub." ;; [cite: 50]
    "write-dockerfile") echo "  ls -R | _ai write-dockerfile \"python-flask\"" && echo "  Writes a Dockerfile based on file tree." ;; [cite: 52]
    "write-github-action") echo "  ls -R | _ai write-github-action \"run pytest\"" && echo "  Writes a GitHub Actions workflow YAML." ;; [cite: 54]
    "write-bash-script") echo "  _ai write-bash-script \"prompt for script\"" && echo "  Writes a robust bash script from a prompt." ;;
    "write-regex") echo "  _ai write-regex \"what to match\" \"what not to match\"" && echo "  Implements and explains a regex." ;;
    "implement-spec") echo "  _ai implement-spec <api-spec.yml> \"FastAPI\"" && echo "  Generates server boilerplate from a spec." ;; [cite: 59]
    "refactor-dry") echo "  _ai refactor-dry <file.py>" && echo "  Refactors a file to remove duplicated code." ;; [cite: 61]
    "refactor-to-function") echo "  cat code.txt | _ai refactor-to-function \"new_func_name\"" && echo "  Extracts a piped-in snippet into a new function." ;;
    "refactor-to-class") echo "  _ai refactor-to-class <script.py> \"NewClassName\"" && echo "  Converts a procedural script to a class." ;; [cite: 65]
    "refactor-conditional") echo "  cat code.txt | _ai refactor-conditional" && echo "  Simplifies a complex conditional snippet." ;;
    "refactor-to-async") echo "  _ai refactor-to-async <file.py> \"Python Flask\"" && echo "  Converts a synchronous file to async." ;; [cite: 69]
    "write-aboutme") echo "  _ai write-aboutme <file.py>" && echo "  Writes the 2-line ABOUTME header for a file." ;; [cite: 71]
    "write-docstrings") echo "  cat file.py | _ai write-docstrings \"google\"" && echo "  Adds docstrings to all functions in a file." ;; [cite: 72]
    "explain-code") echo "  cat code.txt | _ai explain-code" && echo "  Explains a piped-in block of code." ;;
    "write-readme-section") echo "  (cat README.md; cat f.py) | _ai write-readme-section \"Usage\"" && echo "  Generates a new README section." ;; [cite: 76]
    "fix-comment") echo "  _ai fix-comment <file.py>" && echo "  Finds and fixes an incorrect comment in a file." ;; [cite: 78]
    "explain-error") echo "  cat error.log | _ai explain-error" && echo "  Explains a piped-in stack trace." ;;
    "analyze-log") echo "  cat server.log | _ai analyze-log \"find 500 errors\"" && echo "  Analyzes a large log file for a prompt." ;; [cite: 82]
    "debug-this") echo "  (cat code.py; cat report.txt) | _ai debug-this" && echo "  Suggests debugging steps for a bug." ;;
    "find-bug-commit") echo "  (git log -p; cat err.log) | _ai find-bug-commit" && echo "  Finds the bug-introducing commit from a log." ;; [cite: 87]
    "write-debugger-command") echo "  cat code.py | _ai write-debugger-command \"pdb\" \"break on 42\"" && echo "  Writes the exact debugger commands." ;; [cite: 89]
    "critique-design") echo "  _ai critique-design <design.md>" && echo "  Critiques a design document for pragmatism." ;; [cite: 92]
    "compare-tech") echo "  _ai compare-tech \"React\" \"Vue\" \"e-commerce site\"" && echo "  Gives a pragmatic comparison for a use case." ;;
    "draw-diagram") echo "  cat spec.txt | _ai draw-diagram \"mermaid\"" && echo "  Generates a system diagram from a spec." ;;
    "define-api") echo "  _ai define-api \"action to define\"" && echo "  Defines a simple JSON REST API contract." ;;
    "write-sql") echo "  cat schema.sql | _ai write-sql \"prompt\" \"PostgreSQL\"" && echo "  Writes a SQL query from a schema and prompt." ;; [cite: 98]
    "optimize-sql") echo "  (cat s.sql; cat q.sql; cat p.txt) | _ai optimize-sql" && echo "  Optimizes a slow SQL query using its query plan." ;; [cite: 101]
    "write-migration") echo "  (cat before.py; cat after.py) | _ai write-migration \"alembic\"" && echo "  Writes a DB migration script." ;; [cite: 103]
    "generate-mock-data") echo "  cat schema.json | _ai generate-mock-data \"csv\" \"100\"" && echo "  Generates mock data from a JSON schema." ;;
    "explain-shell") echo "  _ai explain-shell 'ls -l | grep .py'" && echo "  Explains a shell command." ;;
    "find-code") echo "  ls -R | _ai find-code \"prompt\"" && echo "  Generates a 'grep' command to find code." ;; [cite: 108]
    *) echo "Unknown command: $CMD" ;;
  esac
}

# Internal helper to show the main help screen
function _ai_show_all_help() {
  echo "Usage: _ai <command> [arguments...]"
  echo "       _ai <command> help"
  echo "       _ai [raw prompt text...]"
  echo ""
  echo "Available Commands:"
  echo ""
  echo "  Git & Version Control:"
  echo "    review-diff, review-commit, write-commit-msg, name-branch, find-breaking-change"
  echo ""
  echo "  Code Review & Quality:"
  echo "    review-security, review-performance, check-naming, refactor-readability, check-pr-description"
  echo ""
  echo "  Testing (TDD & QA):"
  echo "    write-test-scenarios, write-failing-test, write-unit-tests, write-integration-test,"
  echo "    fix-failing-test, harden-tests, write-mock-patch, write-e2e-script"
  echo ""
  echo "  Code Generation & Scaffolding:"
  echo "    scaffold-module, implement-function, write-dockerfile, write-github-action,"
  echo "    write-bash-script, write-regex, implement-spec"
  echo ""
  echo "  Refactoring:"
  echo "    refactor-dry, refactor-to-function, refactor-to-class, refactor-conditional, refactor-to-async"
  echo ""
  echo "  Documentation & Comments:"
  echo "    write-aboutme, write-docstrings, explain-code, write-readme-section, fix-comment"
  echo ""
  echo "  Debugging & Error Analysis:"
  echo "    explain-error, analyze-log, debug-this, find-bug-commit, write-debugger-command"
  echo ""
  echo "  System Design & Architecture:"
  echo "    critique-design, compare-tech, draw-diagram, define-api"
  echo ""
  echo "  Database & Data:"
  echo "    write-sql, optimize-sql, write-migration, generate-mock-data"
  echo ""
  echo "  Shell & Utilities:"
  echo "    explain-shell, find-code"
  echo ""
}

#
# Main _ai() entry point
#
function _ai() {
  # No arguments: Show main help
  if [[ -z "$1" ]]; then
    _ai_show_all_help
    return 0
  fi

  local COMMAND="$1"

  # Check for main help flags
  if [[ "$COMMAND" == "help" || "$COMMAND" == "--help" ]]; then
    _ai_show_all_help
    return 0
  fi

  # Check if the command is a known function
  if type -t "$COMMAND" &>/dev/null && [[ "$(type -t "$COMMAND")" == "function" ]] && \
     [[ "$COMMAND" != "_ai" && "$COMMAND" != "_ai_gemini_agent" && \
     "$COMMAND" != "_ai_show_all_help" && "$COMMAND" != "_ai_show_single_help" ]]; then

    shift # Remove the command from $@

    # Check if the *next* argument is help
    if [[ "$1" == "help" || "$1" == "--help" ]]; then
      _ai_show_single_help "$COMMAND"
      return 0
    fi

    # Not help, so execute the command with the rest of the arguments
    "$COMMAND" "$@"
    return 0
  fi

  # If the first argument is NOT a known command, treat the
  # entire line as a raw prompt to the Gemini agent.
  _ai_gemini_agent "$@"
}

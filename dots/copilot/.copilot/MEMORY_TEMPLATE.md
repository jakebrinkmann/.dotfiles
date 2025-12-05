---
applyTo: "**"
description: Long-term project memory, architectural patterns, and failed attempts.
---

# Project Memory & Operating Context

## 1. Architectural Patterns & Decisions

_These are the "Laws of the Land". Code must strictly adhere to these patterns._

- [ ] **State Management:** (e.g., "Use Redux Toolkit for global state; React Context for theming only.")
- [ ] **Styling:** (e.g., "Use Tailwind utility classes; do not write custom CSS files.")
- [ ] **Testing:** (e.g., "Prioritize Integration tests over Unit tests for UI components.")

## 2. The Graveyard (Failed Hypotheses)

_Things we tried that failed. DO NOT ATTEMPT THESE AGAIN._

- [2024-05-20] Task: Fix scrolling bug -> Tried: `overflow: scroll` on body -> Failed Because: Broke sticky headers on mobile. Use `overflow-y: auto` on the main container instead.

## 3. Technical Insights & Gotchas

_Non-obvious API behaviors or dependency quirks discovered during research._

- [LIFX API] The `Set State` endpoint returns a 207 Multi-Status, not a 200 OK. You must parse the `results` array to check for success.
- [Next.js] Middleware cannot use Node.js runtime APIs (like `fs`).

## 4. User Preferences & Tone

_Specific instructions from the user about style or workflow._

- Prefer terse code over "clever" code.
- Always add `// ABOUTME:` headers to new files.
- Never delete comments unless they are factually incorrect.

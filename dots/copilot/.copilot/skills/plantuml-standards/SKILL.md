---
name: plantuml-standards
description: "Enforces clean, readable PlantUML diagram output by banning directional arrows, HTML formatting, and package grouping."
---

# Skill: PlantUML Diagram Standards

When generating PlantUML (`.puml`) diagrams for Azure DevOps attachments, you MUST adhere to these rules:

1. **Vanilla Syntax**: No HTML tags (`<b>`, `<size>`), no custom colors, no `skinparam`.
2. **Global Axis (CRITICAL)**: For multi-system component diagrams or integration flows, you MUST include `left to right direction` directly under the `@startuml` tag.
3. **Arrow Rules**: Default to standard undirected arrows (`-->` or `..>`). You MAY use directional arrows (e.g., `-down->` or `-up->`) *only* to manage bi-directional loops (e.g., if A --> B, use A -up-> B for the return path) or to stack related components, but do not overuse them.
4. **Grouping**: Prefer `rectangle` over `package` to give the layout engine more internal routing flexibility.

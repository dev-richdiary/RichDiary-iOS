---
name: richdiary-api-design
description: Standard API and interface design guidelines for RichDiary-iOS. Use when creating new UseCases, Repositories, or defining naming conventions for functions, variables, and types.
---

# RichDiary API Design Skill

This skill provides the standard naming and interface design principles for the RichDiary-iOS project.

## Standard Reference Materials

Load these files as needed:

- **Naming**: [naming-convention.md](references/naming-convention.md) - Clarity and Brevity rules.
- **Interfaces**: [domain-interface.md](references/domain-interface.md) - Domain and Repository protocol standards.

## Quick Start

1.  **Clarity over Brevity**: Prefer `fetchMonthlySummary` over `getSum`.
2.  **Model Suffix**: Use `Model` for entities (e.g., `GoalModel`).
3.  **Domain decoupling**: Repositories should return `Single` or `Observable` of Domain models.
4.  **Enums**: Prefer `enums` for states like `DiaryType`.

---
name: richdiary-standard
description: Standard development practices and templates for RichDiary-iOS. Use when creating new ViewControllers, ViewModels, or implementing business logic using Clean Architecture, MVVM, and RxSwift.
---

# RichDiary Standard Skill

This skill provides the standard development patterns and templates for the **RichDiary-iOS** project.

## Standard Reference Materials

Load these files as needed based on the task:

- **Architecture**: [architecture.md](references/architecture.md) - Clean Architecture + MVVM details.
- **Workflow**: [workflow.md](references/workflow.md) - Step-by-step feature implementation guide.
- **UI Standard**: [ui-standard.md](references/ui-standard.md) - UIKit, SnapKit, Then usage.
- **Reactive**: [reactive-standard.md](references/reactive-standard.md) - RxSwift, Relays, Binding patterns.
- **Persistence**: [persistence.md](references/persistence.md) - Realm usage and notification tokens.
- **Project**: [project-management.md](references/project-management.md) - Tuist and Dependency Injection.
- **Style**: [coding-style.md](references/coding-style.md) - Naming, StyleShare guide, organization.

## Quick Start

1.  **Workflow**: Always follow the [Step-by-Step Workflow](references/workflow.md).
2.  **Templates**: Use the templates in `assets/` to create new files:
    - `ViewModel.swift`: Template for a new ViewModel with Input/Output.
    - `ViewController.swift`: Template for a new ViewController.
    - `View.swift`: Template for a new View.
3.  **Sync**: Run `tuist generate` after adding files.

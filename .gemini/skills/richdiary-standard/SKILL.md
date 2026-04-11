---
name: richdiary-standard
description: Standard development practices and templates for RichDiary-iOS. Use when creating new ViewControllers, ViewModels, or implementing business logic using Clean Architecture, MVVM, and RxSwift.
---

# RichDiary Standard Skill

This skill provides the standard development patterns and templates for the **RichDiary-iOS** project.

## Core Principles

- **Architecture**: Follow Clean Architecture and MVVM (Input/Output).
- **Reactive Logic**: Use `RxSwift`, `RxCocoa`, and `RxRelay`.
- **UI Framework**: UIKit with `SnapKit` (layout) and `Then` (styling).
- **Data Layer**: Realm for persistence.
- **Project Structure**: Managed by `Tuist`.

## Quick Start

### 1. Architectural Guidance
Read [coding-standard.md](references/coding-standard.md) for detailed rules on architecture, naming, and dependency management.

### 2. Using Templates
When creating a new feature, use the templates in `assets/`:
- `ViewModel.swift`: Template for a new ViewModel with Input/Output.
- `ViewController.swift`: Template for a new ViewController inheriting from `BaseUIViewController`.
- `View.swift`: Template for a new View inheriting from `BaseUIView`.

### 3. Procedure for adding a new feature

1.  **Analyze requirements** and identify the Entities/UseCases needed.
2.  **Define the Domain Layer** (Entity, UseCase, Repository Protocol).
3.  **Implement the Data Layer** (Realm model, Repository Implementation).
4.  **Implement the Presentation Layer**:
    - Create a ViewModel using the `ViewModel.swift` template.
    - Create a ViewController using the `ViewController.swift` template.
    - Set up the UI and binding.
5.  **Register dependencies** in `AppDIContainer`.
6.  **Update the project** by running `tuist generate`.

## Best Practices

- **ViewModel**: Keep it purely reactive. All logic should happen in the `bind()` method or other private reactive pipelines.
- **UI**: Keep UI components `private`. Use `MARK: -` for grouping properties, life cycle, and functions.
- **Testing**: Add unit tests for UseCases and ViewModels.

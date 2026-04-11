---
name: richdiary-testing
description: Standard unit testing practices for RichDiary-iOS. Provides guidance on RxTest for ViewModels, Mocking strategies for Clean Architecture, and test templates.
---

# RichDiary Testing Skill

This skill provides patterns and templates for unit testing in the RichDiary-iOS project using RxTest and Mocking.

## Standard Reference Materials

Load these files as needed:

- **VM Testing**: [viewmodel-testing.md](references/viewmodel-testing.md) - Testing Input/Output with TestScheduler.
- **Mocking Strategy**: [mocking-strategy.md](references/mocking-strategy.md) - Creating Mock Repositories and UseCases.

## Quick Start

1.  **Templates**: Use `assets/ViewModelTestsTemplate.swift` for new ViewModel tests.
2.  **Given-When-Then**: Follow this structure for every test case.
3.  **Virtual Time**: Always use `TestScheduler` to control timing in RxSwift.
4.  **No Side Effects**: Use Mock objects instead of real Realm or Network.
5.  **Target**: Ensure files are added to the `RichDiaryTests` target in `Project.swift`.

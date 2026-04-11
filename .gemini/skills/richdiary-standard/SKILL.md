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

## 작업 순서 (Step-by-Step Execution)

새로운 기능을 구현하라는 지시를 받으면 즉시 코드를 짜지 말고, 아래 순서대로 터미널에 로그를 남기며 작업하세요.

1. **[요구사항 분석]**: 사용자의 지시를 분석하여 입력과 예상 출력을 정의한다.
2. **[사전 검색]**: 전역 모듈 중에 이 기능을 구현하는 데 사용할 수 있는 기존 사내 유틸리티 함수가 있는지 먼저 프로젝트 내에서 검색(Search)한다.
3. **[설계 승인]**: 코드를 작성하기 전에 어떤 방식으로 구현할 것인지 간단한 계획을 텍스트로 출력하고 사용자의 승인(Yes/No)을 기다린다.
4. **[구현 및 테스트]**: 승인받은 후 코드를 작성하고, 반드시 동일한 폴더에 테스트코드를 만들어 유닛 테스트를 포함시킨다.

## Procedure for adding a new feature


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

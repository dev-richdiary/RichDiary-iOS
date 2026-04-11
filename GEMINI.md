# RichDiary (부자가계부) - Project Context

## Persona & Tone
- **Role**: 당신은 부자가계부의 10년차 iOS 시니어 개발자입니다.
- **Goal**: 우리 팀의 주니어 개발자가 사내 표준과 베스트 프랙티스에 맞춰 안전하고 확장 가능한 코드를 작성하도록 돕는 것입니다.
- **Style**: 설명은 간결하게 하고, 반드시 실제 동작하는 코드 위주로 답변하세요.

## Project Overview

**RichDiary** is an iOS application designed to help users manage their spending and build wealth by categorizing expenditures into three categories: "Necessary", "Needed", and "Nice to have/Unnecessary".

- **Primary Purpose:** Financial management and expense tracking.
- **Target Platform:** iOS (Min Deployment Target: 16.0).
- **Key Technologies:**
  - **Language:** Swift
  - **UI Framework:** UIKit (Imperative UI with SnapKit for AutoLayout and Then for configuration).
  - **Reactive Programming:** RxSwift, RxCocoa, RxRelay (Input/Output ViewModel pattern).
  - **Data Persistence:** Realm (Local database for diary entries).
  - **Project Management:** Tuist (Generates Xcode project and manages dependencies).
  - **Design System:** Pretendard font, custom color assets (gray1-13).

## Architecture & Patterns

The project follows a **Clean Architecture** structure combined with **MVVM**:

- **Presentation Layer:** Located in `RichDiary/Sources/Presentation/`. Each feature (Calendar, Diary, Goal, Home, Help) typically contains ViewControllers and ViewModels. ViewModels strictly follow the `Input`/`Output` pattern using RxSwift.
- **Domain Layer:** Located in `RichDiary/Sources/Domain/`. Contains `Entities`, `UseCases`, and `Interfaces` for Repositories.
- **Data Layer:** Located in `RichDiary/Sources/Data/`. Contains `Repositories` (implementations) and `PersistentStorages` (Realm configurations).
- **Application Layer:** Located in `RichDiary/Sources/Application/`. Handles app lifecycle and Dependency Injection via `AppDIContainer`.

## Building and Running

This project uses **Tuist** to manage the Xcode workspace. Do not modify `.xcodeproj` or `.xcworkspace` files directly as they are generated.

1.  **Prerequisites:** Install Tuist (v4.0.0 or later recommended).
2.  **Install Dependencies:**
    ```bash
    tuist install
    ```
3.  **Generate & Open Project:**
    ```bash
    tuist generate
    ```
4.  **Run:** Select the `RichDiary` scheme in Xcode and run (Cmd + R) on an iOS 16.0+ simulator or device.

## Development Conventions

- **Style Guide:** Follows the [StyleShare Swift Style Guide](https://github.com/StyleShare/swift-style-guide).
- **Commit Messages:**
  - Format: `[Type] #IssueNumber - Description` (e.g., `[Feat] #1 - Add home screen UI`)
  - Types: `[Style]`, `[Feat]`, `[Fix]`, `[Chore]`, `[Add]`, `[Del]`, `[Docs]`, `[Refactor]`, `[Setting]`.
- **UI Code:** Prefers SnapKit for layout and Then for initializing UI components.
- **Reactive Logic:** Use `DisposeBag` for memory management and prefer `Relay` types for UI-related streams to avoid error terminations.

## Key Files & Directories

- `Project.swift`: The Tuist project definition file.
- `Tuist/Package.swift`: Swift Package Manager dependencies.
- `RichDiary/Sources/Application/DIContainer/AppDIContainer.swift`: Central location for dependency injection.
- `RichDiary/Sources/Presentation/Home/ViewModel/HomeViewModel.swift`: A representative example of the project's VM pattern.
- `RichDiary/Resources/`: Contains custom fonts (Pretendard) and assets.

## AI Agent Guidance

- **Core Skills**: 
- Use the `richdiary-standard` skill when creating new features or files. It contains project-specific templates (ViewModel, ViewController, View) and coding standards.
- Use the `richdiary-commit` skill when saving progress or wrapping up tasks to automatically generate standard-compliant commit messages and execute commits.
- Use the `richdiary-pr` skill when the user asks "PR 만들어줘" to generate a Pull Request body based on the branch history and the project's PR template.
- Use the `richdiary-concurrency` skill when implementing asynchronous tasks or Realm thread handling to ensure safety and Rx-Async interoperability.
- Use the `richdiary-api-design` skill when creating new interfaces or naming entities to follow Apple's API Design Guidelines.
- Use the `richdiary-testing` skill when writing unit tests for ViewModels, UseCases, or Repositories using RxTest and Mocking strategies.
- Use the `richdiary-memory` skill to summarize and compress conversation history every 20 turns or upon request to maintain performance and save costs.
- Use the `richdiary-review` skill to perform a self-review of code changes against the project's standards before committing.

- **Standard Workflow**:
  1. Activate `richdiary-standard` skill.
  2. Reference `coding-standard.md` for architectural rules.
  3. Use provided templates in `assets/` when creating new features.
  4. Run `tuist generate` after adding files to keep the Xcode project in sync.
  5. Use `richdiary-commit` workflow rules to automatically generate `[Type] #IssueNumber - Description` commits.

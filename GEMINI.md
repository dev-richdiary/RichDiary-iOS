# RichDiary (부자가계부) - Project Context

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

- **Core Skill**: Use the `richdiary-standard` skill for all development tasks. It contains project-specific templates (ViewModel, ViewController, View) and coding standards (`references/coding-standard.md`).
- **Standard Workflow**:
  1. Activate `richdiary-standard` skill.
  2. Reference `coding-standard.md` for architectural rules.
  3. Use provided templates in `assets/` when creating new features.
  4. Run `tuist generate` after adding files to keep the Xcode project in sync.

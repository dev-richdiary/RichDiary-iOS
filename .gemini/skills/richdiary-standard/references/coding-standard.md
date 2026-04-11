# RichDiary Coding Standards

## Architecture: Clean Architecture + MVVM

1.  **Presentation Layer**:
    - **ViewControllers**: Inherit from `BaseUIViewController`. Overload `setUI`, `setStyle`, `setLayout`. Use private `bind()` for RxSwift.
    - **ViewModels**: Conforms to `ViewModelType`. Use `Input`/`Output` pattern. Logic should be reactive and inside the ViewModel.
    - **Views**: Inherit from `BaseUIView`.
    - **UI**: Use `SnapKit` for constraints and `Then` for property configuration.
    - **Reactive**: Use `RxSwift`, `RxCocoa`, `RxRelay`. Prefer `Relay` over `Subject` for UI bindings.

2.  **Domain Layer**:
    - **Entities**: Simple data models (not Realm objects if possible, or decoupled).
    - **UseCases**: Business logic, independent of UI and Data layers.
    - **Interfaces**: Repository protocols.

3.  **Data Layer**:
    - **Repositories**: Implementations of Domain interfaces.
    - **PersistentStorages**: Realm configurations and CRUD operations.

## Dependency Injection
- Use `AppDIContainer` for managing dependencies.

## Naming & Style
- Follow StyleShare Swift Style Guide.
- Use `// MARK: -` for code organization.
- Keep UI components private.

## Realm Usage
- Use `Thread-safe` access or ensure Realm is accessed on the correct thread.
- Use `NotificationToken` for observing changes.

## Tuist
- Run `tuist generate` after adding new files to update the project.

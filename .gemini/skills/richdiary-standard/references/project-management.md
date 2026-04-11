# Project Management

## Tuist
- The project structure is managed by Tuist.
- **Command**: Run `tuist generate` after adding or removing files to update the `.xcodeproj`.
- Do not modify `.xcodeproj` or `.xcworkspace` directly.

## Dependency Injection (DI)
- Use `AppDIContainer` as the central location for managing dependencies.
- Register all new Repositories, UseCases, and ViewModels here.

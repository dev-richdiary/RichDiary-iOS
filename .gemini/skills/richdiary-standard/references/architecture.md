# Architecture: Clean Architecture + MVVM

## Layers
1. **Presentation Layer**:
   - **ViewControllers**: Inherit from `BaseUIViewController`. Overload `setUI`, `setStyle`, `setLayout`. Use private `bind()` for RxSwift.
   - **ViewModels**: Conforms to `ViewModelType`. Use `Input`/`Output` pattern. Logic should be reactive and inside the ViewModel.
   - **Views**: Inherit from `BaseUIView`.
2. **Domain Layer**:
   - **Entities**: Simple data models (not Realm objects if possible, or decoupled).
   - **UseCases**: Business logic, independent of UI and Data layers.
   - **Interfaces**: Repository protocols.
3. **Data Layer**:
   - **Repositories**: Implementations of Domain interfaces.
   - **PersistentStorages**: Realm configurations and CRUD operations.

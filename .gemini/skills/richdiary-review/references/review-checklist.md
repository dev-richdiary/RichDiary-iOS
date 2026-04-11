# Code Review Checklist for RichDiary

## Architecture & Logic
- [ ] Does it follow Clean Architecture (Layers correctly separated)?
- [ ] Is the ViewModel using the `Input/Output` pattern via `ViewModelType`?
- [ ] Is business logic inside the UseCase or ViewModel (not ViewController)?

## Reactive & Concurrency
- [ ] Are UI bindings using `Relay` instead of `Subject`?
- [ ] Is `DisposeBag` properly managed?
- [ ] Are ViewModels marked with `@MainActor` if they update UI?
- [ ] Is Realm access thread-safe (no objects passed between threads)?

## UI & Style
- [ ] Does it inherit from `BaseUIViewController` or `BaseUIView`?
- [ ] Are UI components `private`?
- [ ] Are constraints defined in `setLayout()`?
- [ ] Is `Then` used for property initialization?

## Testing
- [ ] Are there unit tests for the new logic?
- [ ] Do tests use `RxTest` and `TestScheduler`?
- [ ] Are dependencies mocked correctly?

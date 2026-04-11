# RxSwift & Swift Concurrency Interoperability

## Principles
- Use `async/await` for clean, sequential code in UseCases.
- Use `RxSwift` for UI-related streams and data binding.

## Conversion Patterns
1. **RxSwift to Async**:
   - `Single<T>` to `async`: Use `.value` or `.asSingle().value`.
   - `Observable<T>` to `AsyncSequence`: Use `.values` (Swift 5.5+).
2. **Async to RxSwift**:
   - `async` to `Single<T>`: Use `Single.create { ... }` and call `Task { ... }`.
   - `async` to `Observable<T>`: Use `Observable.create { ... }`.

## Best Practices
- Avoid `DisposeBag` in `async` functions; use `Task` cancellation instead.
- Prefer `async` for one-off network or database operations.
- Prefer `RxSwift` for persistent data streams or UI event handling.

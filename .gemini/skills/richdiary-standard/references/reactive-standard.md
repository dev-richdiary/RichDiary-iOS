# Reactive Standard

## Principles
- **Library**: `RxSwift`, `RxCocoa`, `RxRelay`.
- **Pattern**: Input/Output in ViewModels.
- **Memory Management**: Use `DisposeBag`.

## Best Practices
- Prefer `Relay` types (`PublishRelay`, `BehaviorRelay`) for UI-related streams to avoid error terminations.
- Keep ViewModels purely reactive; logic should reside in `bind()` or other reactive pipelines.
- Bind View -> ViewModel (Input) and ViewModel -> View (Output) in the ViewController's `bind()` method.

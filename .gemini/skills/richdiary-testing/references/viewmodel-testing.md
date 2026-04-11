# ViewModel Testing with RxTest

## Principles
- Use `TestScheduler` to control virtual time.
- Follow the `Given-When-Then` pattern.
- Test only the `Output` based on the `Input`.

## Pattern: TestScheduler Usage
```swift
func test_onTapButton_updatesState() {
    // Given
    let scheduler = TestScheduler(initialClock: 0)
    let disposeBag = DisposeBag()
    let viewModel = MyViewModel()
    
    let buttonTapped = scheduler.createHotObservable([
        .next(10, ()) // Tap at 10ms
    ])
    
    buttonTapped.bind(to: viewModel.input.buttonTapped).disposed(by: disposeBag)
    
    let observer = scheduler.createObserver(String.self)
    viewModel.output.state.bind(to: observer).disposed(by: disposeBag)
    
    // When
    scheduler.start()
    
    // Then
    XCTAssertEqual(observer.events, [
        .next(0, "Initial"),
        .next(10, "Updated")
    ])
}
```

## Best Practices
- Mock dependencies (Repositories/UseCases) to avoid side effects.
- Use `scheduler.createHotObservable` for persistent UI events.
- Use `scheduler.createColdObservable` for one-off data fetching.

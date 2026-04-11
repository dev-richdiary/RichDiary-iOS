# Mocking Strategy for Clean Architecture

## Principles
- Mock Repositories to isolate the Presentation layer.
- Ensure Mocks behave consistently and support error state testing.

## Patterns
1. **Mock Repository**:
```swift
final class MockDiaryRepository: DiaryRepository {
    var diariesResult: Single<[DiaryModel]> = .just([])
    var saveCalledCount = 0
    var lastSavedDiary: DiaryModel?
    
    func fetchDiaries(byMonth date: Date) -> Single<[DiaryModel]> {
        return diariesResult
    }
    
    func saveDiary(_ diary: DiaryModel) -> Single<Void> {
        saveCalledCount += 1
        lastSavedDiary = diary
        return .just(())
    }
}
```
2. **Mock UseCase**:
```swift
final class MockFetchDiariesUseCase: FetchDiariesUseCase {
    var result: Single<[DiaryModel]> = .just([])
    
    func execute(date: Date) -> Single<[DiaryModel]> {
        return result
    }
}
```

## Best Practices
- Use `var` for result properties to inject successes or failures in tests.
- Verify method calls using call counts (e.g., `var saveCalledCount = 0`).

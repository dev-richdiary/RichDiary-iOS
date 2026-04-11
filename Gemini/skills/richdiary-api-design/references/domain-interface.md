# Domain & API Interface Standards

## Principles
- **Loose Coupling**: Domain interfaces (Repositories) must be decoupled from Data layer (Realm) or Network implementations.
- **Strong Typing**: Use `enums` or `structs` instead of strings for states or types (e.g., `DiaryType`).

## Standard Patterns
1. **Repository Protocols**:
   ```swift
   protocol DiaryRepository {
       func fetchDiaries(byMonth date: Date) -> Single<[DiaryModel]>
       func saveDiary(_ diary: DiaryModel) -> Single<Void>
   }
   ```
2. **UseCase Protocols**:
   ```swift
   protocol FetchDiariesUseCase {
       func execute(date: Date) -> Single<[DiaryModel]>
   }
   ```
3. **Error Handling**:
   - Use custom `Error` enums for domain-specific errors (e.g., `DiaryError.persistenceFailed`).

## Best Practices
- Pass domain models, not database models, across layer boundaries.
- Keep interface protocols small and focused (Interface Segregation).

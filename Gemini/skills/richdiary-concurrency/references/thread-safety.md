# Thread Safety in RichDiary

## Actors
- **MainActor**: Ensure UI-related state updates and ViewModels are marked with `@MainActor`.
- **Custom Actors**: Use for non-UI, computationally expensive, or data-sensitive tasks like complex 가계부 calculations.

## Realm & Concurrency
- **Realm Objects**: Never pass Realm objects across threads. Use `ThreadSafeReference` or re-fetch on the target thread using the ID.
- **Realm Instances**: Each thread must have its own Realm instance.
- **NotificationToken**: Always invalidate on the same thread it was created, or ensure proper thread handling.

## Best Practices
- Prefer `@MainActor` for ViewModels to guarantee safe UI updates via RxSwift.
- Use `Task { @MainActor in ... }` when escaping from non-UI contexts to update the UI.

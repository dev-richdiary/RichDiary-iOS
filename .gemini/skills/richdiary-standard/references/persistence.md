# Persistence: Realm

## Principles
- Use Realm for local data storage.

## Best Practices
- Realm objects are thread-confined — use only on the creating thread.
- For cross-thread transfer use `ThreadSafeReference` or `freeze()`.
- Keep a strong reference to `NotificationToken` and call `invalidate()` to stop observing.

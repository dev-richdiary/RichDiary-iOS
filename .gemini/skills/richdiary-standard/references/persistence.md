# Persistence: Realm

## Principles
- Use Realm for local data storage.

## Best Practices
- Use `Thread-safe` access or ensure Realm is accessed on the correct thread.
- Use `NotificationToken` for observing changes in real-time.
- Handle Realm errors gracefully using relays (e.g., `alertMessage`).

---
name: richdiary-concurrency
description: Expert guidance on combining RxSwift and Swift Concurrency (async/await) within the RichDiary architecture. Use when implementing asynchronous tasks, thread-safe Realm operations, or interoperability between Rx and Async.
---

# RichDiary Concurrency Skill

This skill provides patterns and standards for asynchronous and concurrent programming in the RichDiary-iOS project.

## Standard Reference Materials

Load these files as needed:

- **Rx-Async Interop**: [rx-concurrency-interop.md](references/rx-concurrency-interop.md) - Converting between Rx and Async.
- **Thread Safety**: [thread-safety.md](references/thread-safety.md) - Using Actors and safe Realm thread handling.

## Quick Start

1.  **Prefer `async` for single-shot** data fetching in UseCases.
2.  **Prefer `RxSwift` for streaming** data from Realm to UI.
3.  **ViewModel** should be `@MainActor`.
4.  Use `Single.value` to bridge Rx to Async contexts.

# Summarization Rules for Context Compression

## Principles
- **Engineering State First**: Prioritize technical decisions and current status over conversation flow.
- **Concise & Actionable**: Use bullet points. Each point should be clear and descriptive.

## Mandatory Elements (The Big 5)
1. **Context**: Current Branch, Issue Number (#N).
2. **Decisions**: Technical choices made (e.g., "Skipping Phase 2", "Using RxTest").
3. **Completed**: Key tasks finished in this session.
4. **Blockers**: Any unresolved errors or pending user decisions.
5. **Next Step**: The very next task to be performed.

## Best Practices
- Remove redundant logs and error traces. Keep the root cause and solution.
- Use `save_memory` for permanent engineering facts (e.g., "The app's bundle ID is io.tuist.RichDiary").

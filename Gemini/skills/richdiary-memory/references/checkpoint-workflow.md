# Checkpoint Workflow

Follow these steps when compressing context (triggered every 20 turns or upon request):

1. **Analyze**: Review the conversation history since the last checkpoint.
2. **Draft Report**: Create a report based on `summarization-rules.md`.
3. **Save Persistence**:
   - Use `save_memory` for core facts that must persist across sessions.
   - Update `CHECKPOINT.md` in the project root if it exists.
4. **Context Reset Guide**: Provide a single-paragraph "Context Restoration Prompt" that the user can use to kickstart a new session.
5. **Output**: Present the summary and the restoration prompt to the user.

## Triggering Condition
- **Branch Change**: Automatically triggered when you detect a checkout to a different branch.
- Conversation turns > 20.
- After `PR 만들어줘` or `commit` is completed (as a wrap-up).
- User explicitly says "요약해줘" or "압축해줘".

## Branch Switch Workflow
1. **Detect**: Recognize that the current branch is different from the last recorded branch.
2. **Finalize**: Generate a final Engineering Checkpoint for the *previous* branch.
3. **Cleanse**: Reset transient session context (errors, temporary logs) to focus on the new task.
4. **Init**: Read the `CHECKPOINT.md` (if exists) or analyze the new branch to establish fresh context.

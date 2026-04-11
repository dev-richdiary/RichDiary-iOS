---
name: richdiary-commit
description: Triggers automatically when instructed to save work, finish a task, or commit changes. Generates and executes a git commit using the RichDiary convention. Use this to maintain a clean git history.
---

# Auto-Commit for RichDiary

This skill guides the AI agent to automatically construct and execute `git commit` commands following the project's strict convention.

## Triggering Condition
- User requests to "commit", "save", or "finish".
- Workspace is stable after a logical change.

## Reference Materials
- **Convention**: [commit-convention.md](references/commit-convention.md) - Types, Issue numbers, and Description rules.
- **Workflow**: [commit-workflow.md](references/commit-workflow.md) - Step-by-step execution.

## Quick Start
1. Run `git status` and `git diff`.
2. Extract metadata from branch name.
3. Commit using the `[Type] #IssueNumber - Description` format.

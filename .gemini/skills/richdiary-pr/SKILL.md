---
name: richdiary-pr
description: Generates a detailed Pull Request body focused solely on "Work Done" based on the current branch's changes. Triggers when the user says "PR 만들어줘".
---

# PR Helper (Detailed Summary)

This skill creates a highly detailed summary of your work for a Pull Request, following a streamlined 1-person project template.

## Triggering Condition
- The user asks: "PR 만들어줘".

## Reference Materials
- **Workflow**: [pr-workflow.md](references/pr-workflow.md) - Deep analysis of changes.
- **Template**: [pr-template.md](references/pr-template.md) - Simplified PR format.

## Core Tasks
1. **Analyze Commit History**: Use `git log` to see the work sequence.
2. **Analyze Code Changes**: Use `git diff` with file paths to understand actual logic.
3. **Draft Detailed Summary**: Categorize and expand on each logical change.
4. **Format for PR**: Provide only the "작업한 내용" section with the detailed summary. (Note: Metadata like Branch name, Issue numbers, and PR Titles are handled automatically via the instructions in [pr-workflow.md](references/pr-workflow.md)).

*Note: Skip metadata like branch name, issue numbers, PR points, or screenshots. Focus on the code changes.*

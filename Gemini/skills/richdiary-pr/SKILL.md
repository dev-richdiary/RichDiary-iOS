---
name: richdiary-pr
description: Generates a Pull Request body based on the current branch's changes and the project's PR template. Triggers when the user says "PR 만들어줘" or asks to prepare a pull request.
---

# PR Helper for RichDiary

This skill assists in creating high-quality Pull Requests by summarizing branch work and following the project's PR template.

## Triggering Condition
- The user asks: "PR 만들어줘" (Make a PR).
- The user requests to summarize changes for a PR.

## Reference Materials
- **Workflow**: [pr-workflow.md](references/pr-workflow.md) - Step-by-step PR generation.
- **Template**: [pr-template.md](references/pr-template.md) - The standard PR body format.

## Core Tasks
1. **Summarize Work**: Analyze `git log` and `git diff` against `main` to understand what was done.
2. **Extract Metadata**:
   - Current Branch: `git branch --show-current`.
   - Issue Number: Extracted from branch name (e.g., `#47` from `feat/#47`).
3. **Format PR**: 
   - Use the [PR Template](references/pr-template.md).
   - Summarize changes into logical bullet points.
   - Mention key architectural or logic "PR Points".
   - Include code snippets if requested or for major changes.
4. **Output**: Display the complete PR content for the user to copy or use.

*Note: The agent should always look at the current branch's commit history to generate the most accurate summary.*

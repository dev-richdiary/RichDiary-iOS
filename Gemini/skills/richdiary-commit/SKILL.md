---
name: richdiary-commit
description: Triggers automatically when instructed to save work, finish a task, or commit changes. Generates and executes a git commit using the RichDiary convention. Use this to maintain a clean git history.
---

# Auto-Commit for RichDiary

This skill guides the AI agent to automatically construct and execute `git commit` commands following the project's strict convention.

## Triggering Condition
- The user requests to "commit changes", "save work", or "wrap up the task".
- You finish implementing a distinct logical feature, bug fix, or refactor and the workspace is stable (it compiles and works).

## Commit Convention

The mandatory format is: `[Type] #IssueNumber - Description`

**Types:**
- `[Feat]`: A new feature
- `[Fix]`: A bug fix
- `[Refactor]`: Code change that neither fixes a bug nor adds a feature
- `[Style]`: Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
- `[Chore]`: Updating build tasks, package manager configs, etc; no production code change
- `[Add]`: Adding new files, assets, or dependencies
- `[Del]`: Removing unused files or code
- `[Docs]`: Documentation only changes
- `[Setting]`: Project settings, Tuist config, Info.plist updates

**Issue Number:**
- **Extract from Branch**: First, check the current branch name using `git branch --show-current`.
- If the branch name follows the `Type/#IssueNumber-Description` format (e.g., `feat/#12-add-home`), extract the number after the `#` (e.g., `#12`).
- If the user explicitly provided an issue number (e.g., "#12"), use that instead.
- If no issue number is found in the branch name or provided by the user, default to `#-`.

**Description:**
- Write a concise, imperative description (e.g., "Add home screen UI", not "Added home screen UI").

## Execution Workflow

When committing, execute the following steps in sequence using shell commands:
1. **Analyze**: Run `git status`, `git diff`, and `git branch --show-current` to understand changes and extract metadata.
2. **Determine Metadata**:
   - Choose the correct `[Type]`.
   - Determine the `#IssueNumber` (preferring the number from the branch name).
   - Write the `Description`.
3. **Stage**: Run `git add <files>` for the relevant changes.
4. **Commit**: Run `git commit -m "[Type] #IssueNumber - Description"`.
5. **Verify**: Run `git status` to ensure the work tree is clean.

*Note: Never push changes unless explicitly asked.*

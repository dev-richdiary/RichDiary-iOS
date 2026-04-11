# Commit Convention

The mandatory format is: `[Type] #IssueNumber - Description`

## Types
- `[Feat]`: A new feature
- `[Fix]`: A bug fix
- `[Refactor]`: Code change that neither fixes a bug nor adds a feature
- `[Style]`: Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
- `[Chore]`: Updating build tasks, package manager configs, etc; no production code change
- `[Add]`: Adding new files, assets, or dependencies
- `[Del]`: Removing unused files or code
- `[Docs]`: Documentation only changes
- `[Setting]`: Project settings, Tuist config, Info.plist updates

## Issue Number Extraction
1. **From Branch**: Check current branch name with `git branch --show-current`.
2. Extract the number after `#` from formats like `type/#12-desc`.
3. If no number is found or provided, default to `#-`.

## Description
- Write a concise, imperative description (e.g., "Add home screen UI").

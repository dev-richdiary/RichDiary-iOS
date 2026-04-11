# Commit Workflow

Execute these steps in sequence using shell commands:

1. **Analyze**: Run `git status`, `git diff`, and `git branch --show-current`.
2. **Metadata**: Determine `[Type]`, `#IssueNumber`, and `Description`.
3. **Stage**: Run `git add <files>` for relevant changes.
4. **Commit**: Run `git commit -m "[Type] #IssueNumber - Description"`.
5. **Verify**: Run `git status` to ensure a clean work tree.

*Note: Do not push unless explicitly asked.*

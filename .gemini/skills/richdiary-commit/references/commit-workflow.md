# Commit Workflow (Micro-commit Principle)

**EVERY ATOMIC CHANGE MUST BE COMMITTED SEPARATELY.**

1. **Analyze**: `git status` & `git diff`. Ensure only ONE logical sub-task is modified.
2. **Metadata**: Determine `[Type] #Issue - Description`.
3. **Stage**: `git add <specific_file>`.
4. **Commit**: `git commit -m "[Type] #Issue - Description"`.

*Example: Creating one test file = one commit. Updating one protocol = one commit.*

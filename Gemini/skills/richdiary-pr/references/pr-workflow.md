# PR Creation Workflow (Detailed Focus)

Follow these steps when the user asks to "Make a PR" (`PR 만들어줘`):

1. **Summarize Work (Deep Analysis)**: 
   - Identify the base branch (default to `origin/develop`).
   - Run `git log origin/develop..HEAD --oneline` to see the commit history.
   - Run `git diff origin/develop..HEAD --stat` to see modified files.
   - For major files, run `git diff origin/develop..HEAD [file_path]` to analyze logic changes.
   - Summarize the work by categorizing changes (e.g., UI, Logic, Configuration, Data Layer).
   - Provide as much detail as possible for each category.
2. **Generate Template**: 
   - Populate only the "작업한 내용" section of the template.
   - Avoid adding Branch info, PR Points, Screenshots, or Issue Numbers.
3. **Output**: Present the detailed work summary in the PR template format.

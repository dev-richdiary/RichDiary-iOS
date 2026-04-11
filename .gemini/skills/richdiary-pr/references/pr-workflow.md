# PR Creation Workflow

Follow these steps when the user asks to "Make a PR" (`PR 만들어줘`):

1. **Analyze Branch**: Run `git branch --show-current` to identify the branch.
2. **Extract Issue**: Parse the issue number (e.g., `#47` from `setting/#47-gemini`).
3. **Summarize Work**: 
   - Run `git log origin/main..HEAD --oneline` to see the commit history.
   - Run `git diff origin/main..HEAD --stat` to see modified files.
   - Summarize the key changes, prioritizing new features, important refactors, or fixes.
4. **Identify "PR Point"**: Look for significant architectural decisions or complex logic in the diff that might need reviewer's attention.
5. **Generate Template**: Populate the `.github/pull_request_template.md` format with the extracted data.
6. **Output**: Present the filled template to the user.

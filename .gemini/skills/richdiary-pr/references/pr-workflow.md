# PR Creation Workflow (GitHub CLI Enhanced)

Follow these steps when the user asks to "Make a PR" (`PR 만들어줘`):

1. **Summarize Work**: 
   - Analyze changes compared to `origin/develop`.
   - Categorize and detail the technical work done.
2. **Extract Metadata**:
   - **Type**: Determine the PR type (e.g., Setting, Feat, Refactor).
   - **IssueNumber**: Extract from the current branch name.
   - **Description**: Generate a concise summary for the title.
3. **Generate PR Title**:
   - Format: `[Type] #IssueNumber - Description`
4. **Generate PR Body**: 
   - Use `pr-template.md`.
   - Ensure the `Closes #IssueNumber` line is correctly populated to auto-close issues on merge.
5. **Execute/Prepare Command**:
   - Prepare the command: `gh pr create --title "[Title]" --body "[Body]"`
   - If `gh` is installed, ask the user: "Would you like me to execute this command to create the PR on GitHub?"
   - If `gh` is missing, provide the full command for manual execution after installation.

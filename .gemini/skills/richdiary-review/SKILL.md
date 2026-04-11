---
name: richdiary-review
description: Performs a comprehensive self-review of code changes based on RichDiary's engineering standards. Use before committing or when requested to analyze code quality.
---

# RichDiary Review Skill

This skill acts as an automated senior developer peer reviewer, ensuring all code follows the project's strict standards.

## Triggering Condition
- User says: "리뷰해줘", "코드 분석해줘", "체크해줘".
- Recommended before executing `richdiary-commit` or `richdiary-pr`.

## Reference Materials
- **Checklist**: [review-checklist.md](references/review-checklist.md) - Points to verify.
- **Workflow**: [self-review-workflow.md](references/self-review-workflow.md) - How to perform the review.

## Core Tasks
1. **Analyze Diff**: Run `git diff origin/develop..HEAD` to see changes.
2. **Verify Standards**: Cross-reference changes with `richdiary-standard` and `richdiary-review` checklist.
3. **Report**: provide a detailed summary of findings.
4. **Suggest Fixes**: Propose specific code improvements.

*Note: Be strict but constructive, as a 10-year senior developer would be.*

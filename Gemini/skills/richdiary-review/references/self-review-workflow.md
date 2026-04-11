# Self-Review Workflow

Follow these steps before committing or creating a PR:

1. **Static Analysis**: 
   - Scan modified files for common anti-patterns (e.g., public UI components, missing `Base` class).
   - Check if `bind()` method is used for reactive logic.
2. **Standard Check**: Open the `review-checklist.md` and verify each item against the diff.
3. **Draft Review**: Output a concise "Self-Review Report" listing:
   - ✅ Standards Met
   - ⚠️ Suggestions for improvement
   - ❌ Critical violations (must fix before commit)
4. **Fix & Verify**: Apply suggested fixes and run tests.

# Naming Conventions for RichDiary

## Principles
- **Clarity (명확성)**: Names should clearly describe what the item is or does. Avoid abbreviations.
- **Brevity (간결성)**: Use only the minimum number of words necessary to achieve clarity.

## Standard Patterns
1. **Functions**:
   - `fetchDiary(id:)` (not `getDiaryDataById`)
   - `saveGoal(_:)` (not `updateGoalInDatabase`)
   - `onTapPreviousMonth()` (for UI events)
2. **Variables**:
   - `diaryID` (not `idString`)
   - `monthlySummary` (not `summaryData`)
3. **Types**:
   - Use `Model` suffix for Domain entities (e.g., `DiaryModel`).
   - Use `ViewModel` suffix for ViewModels.

## Best Practices
- Follow the [StyleShare Swift Style Guide](https://github.com/StyleShare/swift-style-guide).
- Use `is` or `has` prefixes for boolean variables (e.g., `isEmpty`, `hasError`).
- Use `MARK: -` for grouping properties and methods.

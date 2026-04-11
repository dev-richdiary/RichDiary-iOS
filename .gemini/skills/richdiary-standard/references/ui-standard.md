# UI Standard

## Principles
- **Framework**: UIKit (Imperative).
- **Layout**: Use `SnapKit` for AutoLayout.
- **Styling**: Use `Then` for property configuration.
- **Base Classes**:
  - `BaseUIViewController`: Standard lifecycle methods (`setUI`, `setStyle`, `setLayout`, `addTarget`).
  - `BaseUIView`: Standard initialization methods.

## Best Practices
- Keep UI components `private`.
- Define layout in `setLayout()`.
- Use custom color assets (`gray1-13`) and `Pretendard` font.

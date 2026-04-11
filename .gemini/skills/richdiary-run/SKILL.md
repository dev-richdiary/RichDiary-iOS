---
name: richdiary-run
description: Triggers when the user says "실행해줘" or "앱 띄워줘". Automatically builds and runs the RichDiary app on the specified iPhone 13 mini simulator.
---

# RichDiary Run Skill

This skill allows the agent to control the iOS Simulator and launch the RichDiary app for testing and verification.

## Triggering Condition
- User says: "실행해줘", "앱 실행해줘", "시뮬레이터로 보여줘".

## Reference Materials
- **Workflow**: [run-workflow.md](references/run-workflow.md) - Step-by-step app execution.
- **Config**: [simulator-config.md](references/simulator-config.md) - Target device and simctl commands.

## Core Tasks
1.  **Identify Device**: Dynamically resolve the UDID for **iPhone 13 mini** using `simctl list`.
2.  **Verify Build**: Ensure a fresh build is available in `DerivedData`.
3.  **Boot & Launch**: Use `simctl` to boot the simulator, install the app, and launch it.
4.  **Display**: Ensure the Simulator application is visible.

*Note: Always use the iPhone 13 mini unless the user specifies otherwise.*

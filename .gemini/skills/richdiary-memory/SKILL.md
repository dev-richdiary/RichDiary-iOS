---
name: richdiary-memory
description: Manages context compression and memory persistence. Triggers every 20 turns or upon request to summarize technical status and save core facts to project memory.
---

# RichDiary Memory Skill

This skill ensures optimal performance and cost efficiency by compressing long conversation histories into essential engineering checkpoints.

## Standard Reference Materials

- **Rules**: [summarization-rules.md](references/summarization-rules.md) - What to keep and what to discard.
- **Workflow**: [checkpoint-workflow.md](references/checkpoint-workflow.md) - How to execute context compression.

## Triggering Condition
- The conversation reaches 20 turns.
- After finishing a significant task (Commit/PR).
- User requests: "요약해줘", "압축해줘", "상태 보고해줘".

## Core Tasks
1. **Engineering Status Summary**: Summarize Branch, Issues, Decisions, and Completed work.
2. **Persistent Memory**: Use `save_memory` for project-wide facts. (CRITICAL: Always sanitize data by removing passwords, API tokens, or personal identifiers before saving).
3. **Session Handoff**: Generate a prompt for the next session to restore context quickly.

*Note: Focus on maintaining the "State" of the project, not the "Story" of the conversation.*

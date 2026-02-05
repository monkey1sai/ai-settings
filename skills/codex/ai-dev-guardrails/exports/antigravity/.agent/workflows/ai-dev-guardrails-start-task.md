---
description: Initialize docs/current_task.md for a new multi-step task (with optional backup).
---

# Start Task (AI Dev Guardrails)

Fill in a task title and (optionally) objectives/plans, then run:

`python .agent/skills/ai-dev-guardrails/scripts/ai_journal.py start-task --title "<title>" --objective "<obj>" --plan "<step>" --backup`

If `docs/current_task.md` already exists and you want to overwrite it:

`python .agent/skills/ai-dev-guardrails/scripts/ai_journal.py start-task --title "<title>" --force --backup`


---
description: Append a durable change journal entry to docs/ai_journal/changes.jsonl (and capture a patch snapshot if possible).
---

# Record Change (AI Dev Guardrails)

After every meaningful change, run:

`python .agent/skills/ai-dev-guardrails/scripts/ai_journal.py record --summary "<what>" --why "<why>" --verify "<how to verify>"`

If you want to capture the staged diff:

`python .agent/skills/ai-dev-guardrails/scripts/ai_journal.py record --staged --summary "<what>" --why "<why>" --verify "<how to verify>"`


# AI Dev Guardrails (Gemini CLI)

You MUST:
- Discover and follow repo rules first (`AGENTS.md`, `CONTRIBUTING.md`, `README.md`, etc.).
- Maintain `docs/current_task.md` (objective/plan/progress/context/handoff) for any multi-step work.
- For every meaningful code change, append a machine-readable journal entry to `docs/ai_journal/changes.jsonl` and (if possible) capture a patch snapshot under `docs/ai_journal/patches/`.

Optional: use the bundled tool `tools/ai_journal.py` to create/update:
- `docs/current_task.md`
- `docs/ai_journal/changes.jsonl`
- `docs/ai_journal/patches/*.patch`

Example (run from the extension folder, or with an absolute path):
- `python tools/ai_journal.py start-task --title "..." [--force --backup]`
- `python tools/ai_journal.py record --summary "..." --why "..." --verify "..." [--staged] [--no-patch]`
- `python tools/ai_journal.py handoff --note "..." --note "..."`

Prefer writing in 繁體中文 unless the user requests otherwise.

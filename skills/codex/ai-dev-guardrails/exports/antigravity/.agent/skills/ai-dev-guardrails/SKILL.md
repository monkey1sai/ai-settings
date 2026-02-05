---
name: ai-dev-guardrails
description: Enforce shared AI-assisted engineering guardrails in Antigravity IDE. Always read and follow repository rules (AGENTS.md/CONTRIBUTING), keep docs/current_task.md updated (objective/plan/progress/context/handoff), and journal meaningful code changes to docs/ai_journal (JSONL + optional patch snapshot) so other sessions/agents can resume consistently.
---

# AI Dev Guardrails（Antigravity IDE）

## 必做

1. 先找規範：`AGENTS.md` / `CONTRIBUTING.md` / `README.md`
2. 持續維護：`docs/current_task.md`
3. 變更留痕：`docs/ai_journal/changes.jsonl` + `docs/ai_journal/patches/`
4. 驗證可重現：journal 必填 `verify`
5. 避免敏感資訊：不寫 token / 密碼 / 個資

## 建議搭配工具

同目錄的 `scripts/ai_journal.py` 提供：
- `start-task`：初始化 `docs/current_task.md`（可 `--backup` 封存）
- `record`：追加一筆 JSONL（可選存 patch）
- `handoff`：輸出 handoff markdown（含 git 狀態）


---
name: ai-dev-guardrails
description: Enforce shared AI-assisted engineering guardrails. Always read and follow repository rules (AGENTS.md/CONTRIBUTING), keep docs/current_task.md up to date (objective/plan/progress/context/handoff), and write a durable change journal (what/why/verify + optional patch snapshot) to docs/ai_journal so another session or AI can resume consistently.
---

# AI Dev Guardrails（共同規範 + 交接 + 變更紀錄）

## 必做清單

1. **先讀規範再動手**：找並遵守 `AGENTS.md` / `CONTRIBUTING.md` / `README.md`。
2. **持續更新 `docs/current_task.md`**：任務開始先寫 Objective/Plan；每完成一步就打勾；遇到卡點寫在 Context；結束前寫 Handoff。
3. **每個有意義的變更都要留痕**：
   - `docs/ai_journal/changes.jsonl`（JSONL，一行一筆）
   - 盡可能同時保存 patch snapshot 到 `docs/ai_journal/patches/`
4. **驗證要可重現**：journal 的 `verify` 欄位必須能讓別人照指令重跑。
5. **不要寫入敏感資訊**：token/密碼/個資一律不要進 journal 或 patch。

## 建議工作流（可複製）

- Start: 建立/更新 `docs/current_task.md`
- Iterate: 每完成一個可驗收 chunk，就寫一筆 journal（What/Why/Verify）
- End: 補 `docs/current_task.md` 的 Handoff +（可選）輸出 handoff 檔

## Journal（JSONL）範例

```json
{"ts":"2026-02-02T06:12:34Z","summary":"Fix race in audio gateway","why":"Prevent double-close and ghost sessions","files":["backend/gateways/audio_ws.py"],"verify":[".venv\\\\Scripts\\\\python.exe -m compileall backend"],"patch":"docs/ai_journal/patches/20260202-061234Z_ab12cd34.patch"}
```


# AI Journal schema（`docs/ai_journal/changes.jsonl`）

每行一個 JSON 物件（JSONL），建議保持欄位穩定，方便跨 session / 跨系統解析與索引。

## 建議欄位

- `ts`：ISO-8601 UTC 時間（字串）
- `summary`：一句話摘要（字串，必填）
- `why`：動機/原因（字串，可空）
- `files`：相關檔案路徑（字串陣列）
- `verify`：驗證方式（字串陣列）
- `patch`：patch 檔路徑（字串，可空）
- `git`：git 資訊（物件，可空）
  - `branch`：分支名
  - `head`：HEAD commit（短或長皆可）
  - `dirty`：是否有未提交變更（布林）

## 範例

```json
{"ts":"2026-02-02T06:12:34Z","summary":"Add ai-dev-guardrails skill skeleton","why":"Provide shared guardrails + journaling for cross-session continuity","files":["skills/ai-dev-guardrails/SKILL.md","skills/ai-dev-guardrails/scripts/ai_journal.py"],"verify":["python -m py_compile skills/ai-dev-guardrails/scripts/ai_journal.py"],"patch":"docs/ai_journal/patches/20260202-061234Z_ab12cd34.patch","git":{"branch":"main","head":"abc1234","dirty":true}}
```


# AI Journal schema（`docs/ai_journal/changes.jsonl`）

每行一個 JSON 物件（JSONL）。

## 建議欄位

- `ts`：ISO-8601 UTC 時間（字串）
- `summary`：一句話摘要（必填）
- `why`：動機/原因（可空）
- `files`：相關檔案路徑（字串陣列）
- `verify`：驗證方式（字串陣列）
- `patch`：patch 檔路徑（字串，可空）
- `git`：git 資訊（物件，可空）
  - `branch`：分支名
  - `head`：HEAD commit
  - `dirty`：是否 dirty


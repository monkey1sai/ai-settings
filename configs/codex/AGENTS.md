# AGENTS.md — Global Engineering Guardrails

## 0. 溝通與輸出
- 預設使用 **繁體中文** 回覆（必要時可中英混用）。

## Added Memories
- Handoff Protocol (AI 交接協議):
當執行複雜或多階段任務時，必須維護 `docs/current_task.md` 以確保進度可追蹤。
操作守則：
1. **Init**: 任務開始前，寫入標題、目標 (Objective) 與執行計畫 (Plan)。
2. **Update**: 每完成一個關鍵步驟，將 Plan 中的項目打勾 `[x]`。
3. **Note**: 在思考轉折或遇到困難時，於 `Context & Thoughts` 區塊記錄上下文。
4. **Handoff**: 若任務中斷，於 `Handoff Note` 留下給下一個 Agent 的具體指令。
格式參照 `docs/current_task.md` 內的範本。

## Python 環境（Hard Rules）
- 專案 Python 環境一律使用 **`uv` + `.venv/`**。
- 禁止使用全域 `pip` 或系統 Python。
- 所有 Python / Pytest 指令，**必須明確使用虛擬環境路徑**：
  - Windows：`.venv\Scripts\python.exe`

## Codex CLI 啟動警告（Memory / 排除方式）
若進入 Codex CLI 時看到下列訊息，多半是 **`C:\Users\IOT\.codex\config.toml` 設定觸發的提示**，不是程式壞掉：

### 1) `⚠ [features].web_search_request is deprecated...`
- 原因：`[features].web_search_request = true` 已棄用。
- 解法：刪除 `features.web_search_request`，改用頂層 `web_search`：
  - `web_search = "live"`（或依需求用 `"cached"` / `"disabled"`）

### 2) `⚠ Under-development features enabled...`
- 原因：啟用了尚在開發中的 feature flags（例如 `child_agents_md`、`elevated_windows_sandbox`、`experimental_windows_sandbox`），Codex 會提醒可能不穩定。
- 解法 A（保留功能、隱藏提示）：在 `config.toml` 加上：
  - `suppress_unstable_features_warning = true`
- 解法 B（真正停用不穩定功能）：在 `[features]` 將對應旗標改成 `false`。

### 驗證
- 修改 `config.toml` 後需重啟 Codex CLI；可用 `codex --help` 快速確認不再印出上述警告。

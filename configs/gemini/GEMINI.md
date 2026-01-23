# Global Development Rules

## Added Memories
- Handoff Protocol (AI 交接協議):
當執行複雜或多階段任務時，必須維護 `docs/current_task.md` 以確保進度可追蹤。
操作守則：
1. **Init**: 任務開始前，寫入標題、目標 (Objective) 與執行計畫 (Plan)。
2. **Update**: 每完成一個關鍵步驟，將 Plan 中的項目打勾 `[x]`。
3. **Note**: 在思考轉折或遇到困難時，於 `Context & Thoughts` 區塊記錄上下文。
4. **Handoff**: 若任務中斷，於 `Handoff Note` 留下給下一個 Agent 的具體指令。
格式參照 `docs/current_task.md` 內的範本。

## 0. 溝通與輸出
- 預設使用 **繁體中文** 回覆（必要時可中英混用）。

## 1. Python 環境（Hard Rules）
- 專案 Python 環境一律使用 **`uv` + `.venv/`**。
- 禁止使用全域 `pip` 或系統 Python。
- 所有 Python / Pytest 指令，**必須明確使用虛擬環境路徑**：
  - Windows：`.venv\Scripts\python.exe`

## 3. 驗證責任
- 每次修改後，必須提供 **一條可直接複製執行的驗證指令**。
- 驗證指令需可在 Windows 環境直接執行。
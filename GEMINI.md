# Global Development Rules

## 0. 溝通與輸出
- 預設使用 **繁體中文** 回覆（必要時可中英混用）。
- 說明到「可直接執行或驗證」即可，不需長篇推理說明。
- 若指令或上下文不明確，先提出最少量澄清問題。

## 1. Python 環境（Hard Rules）
- 專案 Python 環境一律使用 **`uv` + `.venv/`**。
- 禁止使用全域 `pip` 或系統 Python。
- 所有 Python / Pytest 指令，**必須明確使用虛擬環境路徑**：
  - Windows：`.venv\Scripts\python.exe`
  
## 2. 系統相容性與 Shell 安全 (Windows Safety)
> **注意：此區塊是防止 IDE/CLI 崩潰的關鍵規則**
- **強制 `cmd /c`**：所有 `run_command` 操作必須以 `cmd /c` 開頭 (e.g., `cmd /c dir`, `cmd /c .venv\Scripts\python ...`)，防止終端機卡死。
- **路徑引號**：路徑一律使用**單引號** (e.g., `'C:\Project'`) 以避免轉義錯誤。
- **避免巢狀引號**：若指令過於複雜，請先 `cd` 進入目錄再執行，**嚴禁**在單行指令中使用巢狀雙引號。

## 3. 驗證責任
- 每次修改後，必須提供 **一條可直接複製執行的驗證指令**。
- 驗證指令需可在 Windows 環境直接執行。

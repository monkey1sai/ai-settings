# Global Development Rules

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
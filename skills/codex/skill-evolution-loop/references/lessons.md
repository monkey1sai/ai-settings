# Skill Evolution Loop — Lessons Learned

> 規則：最新條目放最上方；每則條目要能「快速定位、快速重跑、快速驗證」。

## 2026-02-04 — quick_validate 缺 PyYAML（yaml）→ 安裝依賴後通過驗證

- **觸發語 / 關鍵字**：`quick_validate.py`、`ModuleNotFoundError: No module named 'yaml'`
- **症狀**：執行 `quick_validate.py` 時，因缺少 `yaml` 套件而直接中斷。
- **環境**：Windows；執行驗證腳本 `C:\Users\IOT\.codex\skills\.system\skill-creator\scripts\quick_validate.py`
- **根因**：驗證腳本依賴 PyYAML（提供 `yaml` module），但當前 Python 環境未安裝。
- **修復步驟**：
  1. 建立虛擬環境：`uv venv .venv`
  2. 安裝依賴：`uv pip install --python .venv\Scripts\python.exe pyyaml`
  3. 以虛擬環境執行：`.venv\Scripts\python.exe ...\quick_validate.py <skill-path>`
- **驗證方式**：輸出 `Skill is valid!`
- **防再犯 / Guardrails**：凡執行 `.codex/skills/.system/*/scripts/*.py` 前，先確認使用的是專案/工作區的 `.venv\Scripts\python.exe` 且依賴齊全。
- **變更檔案/指令**：`uv venv .venv`、`uv pip install --python .venv\Scripts\python.exe pyyaml`

---
name: codex-plugin-dev-create-command
description: Use when the user asks to create reusable commands for a Codex workflow (scripts, one-liners, shortcuts, task runners), or wants plugin-dev-like /commands to start, validate, or scaffold work.
---

# Codex Plugin-Dev：建立 Commands（腳本/快捷）

## 目標
把常用操作做成可重用的指令入口（PowerShell / .bat / Make-like scripts），用來取代「slash commands」的體驗。

## 建議做法
- 在 repo 的 `scripts/` 放可執行腳本（與專案一起版本控管）
- 在 skill 的 `scripts/` 放「skill 專用工具」（例如產生 skeleton、驗證）

## 常見 commands 類型
- `start`: 啟動/安裝環境
- `lint`: 格式化/靜態檢查
- `test`: 跑測試
- `validate`: 驗證 skill frontmatter/結構
- `scaffold`: 產生模板

## Quick start（建議先問）
1) 目標平台（Windows-only 還是 cross-platform）  
2) 要不要寫到 repo（給團隊用）還是寫到 `.codex/skills`（個人用）  
3) 驗收指令是什麼（成功/失敗可立刻判斷）


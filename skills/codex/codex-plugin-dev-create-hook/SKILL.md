---
name: codex-plugin-dev-create-hook
description: Use when the user wants automation hooks around a Codex workflow (git hooks like pre-commit/commit-msg, local validation, CI helpers), or wants plugin-dev-like hooks behavior.
---

# Codex Plugin-Dev：建立 Hooks / Automation

## 定位
用 git hooks 或輔助腳本把「流程規範」自動化（例如提交前跑格式化/測試/敏感資訊掃描），讓工作流更接近 plugin-dev 的 hooks 體驗。

## 推薦最小集合
- `.githooks/pre-commit`：快速驗證（lint/format/fast tests）
- `.githooks/commit-msg`：commit message 規範（可選）
- `scripts/install-githooks.ps1`：一鍵安裝 hooks（把 core.hooksPath 指到 `.githooks`）

## 重要注意
hooks 必須：
- 快（避免讓每次 commit 都很痛苦）
- 可跳過（例如用環境變數或 `--no-verify`，並在 CI 再做一次完整檢查）


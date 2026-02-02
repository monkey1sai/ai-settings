---
name: codex-plugin-dev-create-mcp
description: Use when the user wants to add MCP support as part of a Codex CLI workflow (create an MCP server, integrate tools into an agent flow, or package MCP + skills together), especially when they mention Model Context Protocol or tool servers.
---

# Codex Plugin-Dev：建立/整合 MCP（工具層）

## 何時用這個 skill
當需求不只是「寫 MCP server」，而是：
- 要把 MCP server 變成一個可重用的工作流（搭配 skills / scripts）
- 要設計一套 agent 會穩定使用的 tools（命名、schema、錯誤訊息）

## 優先規則
- 若使用者就是要「從零做 MCP server」：直接套用 `mcp-builder`（它更完整）。
- 本 skill 只負責把 MCP 併入「plugin-dev 風格」的 Codex workflow（結構、觸發、驗證、交付）。

## 交付清單（建議）
- MCP server 原始碼（TypeScript 或 Python）
- 啟動方式（stdio / http）與最短驗收指令
- 對應的 Codex skill：描述何時用、如何呼叫 MCP、如何驗證輸出


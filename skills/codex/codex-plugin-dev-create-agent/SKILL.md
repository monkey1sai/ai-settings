---
name: codex-plugin-dev-create-agent
description: Use when the user asks to create an agent or subagent-like workflow in Codex CLI (multi-step tasks, delegation, subagent prompts), or wants plugin-dev-style agent frontmatter and reusable agent behaviors.
---

# Codex Plugin-Dev：建立「Agent 風格」工作流

## 定義
Codex CLI 沒有 Claude Code 的「可安裝 agent」同一套機制，但可以用以下方式達到相同效果：
- 用 **skills** 固化行為規範（觸發條件 → 工作流）
- 用 **subagent-driven-development / dispatching-parallel-agents** 做分工與子任務

## 先釐清（必問）
1) 這個 agent 目標輸入/輸出是什麼？  
2) 要不要拆子任務？（可以平行嗎？）  
3) 允許用哪些工具？（shell、寫檔、網路等）  
4) 失敗時要怎麼回報與回復？（retries、rollback、驗收）

## 落地方式（擇一）
A) 最簡：做成一個 skill（最可控、最好觸發）  
B) 複雜：做成「路由 skill + 子 skills」  
C) 需要真正工具層：做成 MCP server，再用 `mcp-builder`/MCP 工具呼叫

## 建議模板（做成 skill）
- 用 `codex-plugin-dev-create-skill` 先產生 skeleton
- 在 `When to use` 寫清楚觸發詞：`agent`, `subagent`, `delegate`, `break down task`, `multi-step`
- 在正文寫「固定 SOP」：例如先蒐集資訊 → 產出計畫 → 執行 → 驗證 → 交付


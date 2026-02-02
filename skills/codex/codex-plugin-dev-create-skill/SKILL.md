---
name: codex-plugin-dev-create-skill
description: Use when the user asks to create a new Codex skill (SKILL.md), design trigger conditions in the description, generate a skill skeleton/scaffold, or debug why a skill isn't being selected or discovered.
---

# Codex Plugin-Dev：建立 Skill（含觸發設計）

## 核心概念
在 Codex CLI 裡，「觸發」主要靠 **skill list 的 `description`** 被語意命中；因此要把「使用者會怎麼問」寫進 description，而不是把流程寫進 description。

## 最小輸入（先問 4 件事）
1) skill 名稱（建議全小寫 + hyphen）  
2) 使用情境（使用者會怎麼問？列 5 句）  
3) 產出物（會新增/修改哪些檔案？）  
4) 約束（不能做什麼？）

## 建立骨架（建議）
用內建腳本生成：
- `pwsh -File C:\\Users\\IOT\\.codex\\skills\\codex-plugin-dev-create-skill\\scripts\\create_codex_skill.ps1 -Name <skill-name> -Description "<Use when ...>"`

> 若環境有設定 `$env:CODEX_HOME`，腳本會優先寫入 `$env:CODEX_HOME\\skills\\...`；否則寫入 `$HOME\\.codex\\skills\\...`。

## description（觸發）寫法模板
`description` 必須：
- 以 `Use when...` 開頭（第三人稱）
- 只描述「什麼情況要用」，不要描述流程

模板：
```
Use when the user asks to <動作> in Codex CLI, mentions <關鍵字/症狀>, or needs <特定結果>.
```

## 常見失敗與修正
- 「太籠統」：description 沒包含使用者語句 → 把 5 句常見提問詞塞進 description
- 「被別的 skill 搶走」：描述重疊 → 改成更具體的場景（例如「在 Codex skills 目錄下」）
- 「description 寫流程」：模型只照 description 不讀全文 → 把流程挪到正文


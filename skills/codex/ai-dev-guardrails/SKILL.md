---
name: ai-dev-guardrails
description: Enforce shared AI-assisted engineering guardrails across teams/orgs. Always discover and follow repository rules (AGENTS.md/CONTRIBUTING), maintain docs/current_task.md (objective/plan/progress/context/handoff), and journal every meaningful code change (what/why/verification + optional patch capture) so other sessions or AI systems can resume consistently. Use when setting up or following common coding standards, change logs, handoff notes, or cross-session continuity for AI coding.
---

# AI Dev Guardrails（共同規範 + 交接 + 變更紀錄）

## 核心原則（務必遵守）

1. **先找規範再改碼**：先讀專案規範（`AGENTS.md`、`CONTRIBUTING.md`、`README.md`、`.editorconfig` 等），再開始實作。
2. **可追蹤性優先**：任何「有意義」的變更都要留下可機器與人類閱讀的紀錄（What / Why / Verify / Risk）。
3. **交接可重現**：下一個 session / 另一個 AI 只靠 repo 內文件就能接續，不依賴對話紀錄。
4. **不記錄敏感資訊**：不要把 token、密碼、私密 URL、個資寫進 journal 或 patch；必要時要先遮罩再紀錄。

## 快速用法（建議每個任務都照做）

### 1) 開始任務：建立/刷新 `docs/current_task.md`

- 用腳本快速產生模板（建議）：
  - `python $CODEX_HOME/skills/ai-dev-guardrails/scripts/ai_journal.py start-task --title "..." --objective "..." --plan "..." --plan "..."`
- 或手動維護（模板見 `references/current_task_template.md`）。

### 2) 每次完成一個「可驗收」變更：追加 journal（含可選 patch）

- `python $CODEX_HOME/skills/ai-dev-guardrails/scripts/ai_journal.py record --summary "..." --why "..." --verify "..." --verify "..."`

預設會：
- 追加一筆 JSONL 到 `docs/ai_journal/changes.jsonl`
- 嘗試用 `git diff` 產生 patch，存到 `docs/ai_journal/patches/`

### 3) 交接：輸出 handoff 檔（可選）

- `python $CODEX_HOME/skills/ai-dev-guardrails/scripts/ai_journal.py handoff --note "..." --note "..."`

備註：技能安裝路徑通常是 `~/.codex/skills/...`（Windows 常見 `C:\\Users\\<you>\\.codex\\skills\\...`）。若你的環境沒有 `CODEX_HOME`，請改用實際安裝路徑。

## 分享/安裝（跨公司）

### 打包成 `.skill`

- PowerShell（在 repo 根目錄）：
  - `New-Item -ItemType Directory -Force dist | Out-Null; Compress-Archive -Path skills/ai-dev-guardrails -DestinationPath dist/ai-dev-guardrails.skill -Force`
- bash：
  - `mkdir -p dist && (cd skills && zip -r ../dist/ai-dev-guardrails.skill ai-dev-guardrails)`

`.skill` 本質是 zip；解壓後應得到一個 `ai-dev-guardrails/` 資料夾，內含 `SKILL.md`、`scripts/`、`references/`。

### 安裝

- 將解壓後的 `ai-dev-guardrails/` 放到 `~/.codex/skills/`（Windows：`C:\\Users\\<you>\\.codex\\skills\\`）。

## 匯出到其他工具

### Gemini CLI（Extensions + Agent Skills）

已提供可直接安裝的 extension 樣板：
- `skills/ai-dev-guardrails/exports/gemini-cli/ai-dev-guardrails/`

安裝方式（Gemini CLI）：
- `gemini extensions install "<path-to>/skills/ai-dev-guardrails/exports/gemini-cli/ai-dev-guardrails"`

Extension 內包含：
- `GEMINI.md`（always-on guardrails）
- `skills/ai-dev-guardrails.md`（可觸發的 skill）
- `tools/ai_journal.py`（可選的 journaling 工具）

### Antigravity IDE（.agent/skills + workflows + rules）

已提供可直接放入專案根目錄的 pack 樣板：
- `skills/ai-dev-guardrails/exports/antigravity/`

安裝方式（建議做法）：
- 將 `exports/antigravity/` 內的 `.agent/` 整個資料夾拷貝到你的專案根目錄（若已存在 `.agent/`，請合併資料夾）。

### 產生 zip 安裝包（建議）

- 若在 Codex skills 安裝目錄執行：`python $CODEX_HOME/skills/ai-dev-guardrails/scripts/build_packages.py --out dist`
- 若在本 repo 內執行：`.venv\\Scripts\\python.exe skills/ai-dev-guardrails/scripts/build_packages.py --out dist`

會輸出：
- `dist/ai-dev-guardrails.gemini-cli-extension.zip`
- `dist/ai-dev-guardrails.antigravity-pack.zip`

解壓建議：
- Gemini CLI：解壓後會得到 `ai-dev-guardrails/` 資料夾（extension root），用 `gemini extensions install <that-folder>` 安裝。
- Antigravity IDE：將 `ai-dev-guardrails.antigravity-pack.zip` **解壓到專案根目錄**，會直接產生/更新 `.agent/`。

## 執行細節（給 AI / 共同遵守的工作流）

### A. 開工前（必做）

1. 找到並讀取所有適用的 `AGENTS.md`（有多層時，越深層優先）。
2. 讀完後，在 `docs/current_task.md`：
   - 填 `Objective`（可驗收）
   - 列 `Plan`（可勾選）
   - 規定驗證方式（例如：單元測試、lint、compile）

### B. 變更落地（每一個 patch / PR chunk 都要可說明）

每次變更結束至少要能回答：
- **What**：改了哪些檔/哪些行為
- **Why**：為什麼要改（需求/bug/風險/一致性）
- **Verify**：用什麼方式驗證（指令/手動步驟/觀察指標）
- **Risk/Rollback**：可能影響與如何回退

然後用 `record` 寫入 `docs/ai_journal/changes.jsonl`（建議連同 patch 一起留存）。

### C. 交接（結束前必做）

1. `docs/current_task.md` 的 `Plan` 勾到最新狀態。
2. `docs/current_task.md` 的 `Handoff Note` 寫清楚：
   - 下一步做什麼（具體檔案/指令）
   - 目前卡點與假設
   - 如何驗證完成
3. 視需要跑 `handoff` 產生一份獨立 handoff 檔。

## 參考

- `references/current_task_template.md`：`docs/current_task.md` 範本
- `references/journal_schema.md`：`changes.jsonl` 欄位與範例

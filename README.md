# openAI CLI

統一管理 **Gemini CLI**、**Claude CLI**、**Codex CLI** 的設定、技能與擴充套件（以 Git 同步到雲端，並可在其他系統部署後再同步推送）。

## 🚀 快速開始

### 同步設定到雲端
當本機設定有變更時，執行：
```powershell
.\scripts\sync.ps1
```

可選參數：
```powershell
.\scripts\sync.ps1 -Message "新增 Gemini skill"  # 自訂 commit 訊息
.\scripts\sync.ps1 -BackupOnly                    # 只複製到專案，不 push
.\scripts\sync.ps1 -DryRun                        # 預覽模式
```

### 在新電腦還原
```powershell
git clone https://github.com/YOUR_USERNAME/openai-cli.git
cd openai-cli
git submodule update --init --recursive
.\scripts\restore.ps1
```

### 在 macOS / Linux 執行（PowerShell 7）
請先安裝 `pwsh`（PowerShell 7），再在 repo 根目錄執行：
```bash
pwsh ./scripts/sync.ps1
```

## 📁 專案結構

```
openai-cli/
├── configs/          # 設定檔
│   ├── gemini/       # settings.json, GEMINI.md
│   ├── claude/       # settings.json, plugins.json
│   └── codex/        # config.toml, AGENTS.md
├── skills/           # 技能
│   ├── gemini/
│   └── codex/
├── extensions/       # 擴充套件
│   └── gemini/
├── rules/            # 規則
│   └── codex/
└── scripts/          # 腳本
    ├── sync.ps1      # 同步到雲端
    └── restore.ps1   # 還原設定
```

## 📋 同步內容

| CLI | 設定 | 技能 | 擴充 | 規則 |
|-----|------|------|------|------|
| Gemini | ✅ | ✅ | ✅ | ✅ |
| Claude | ✅ | - | - | - |
| Codex | ✅ | ✅ | - | ✅ |

## ⚠️ 注意事項

- **認證資料不會同步**，新電腦需要重新登入
- Codex 的專案信任設定 (`[projects]`) 不會同步

## ☁️ 推上雲端（Git）

`sync.ps1` 會自動 `git add/commit/push`。在新機/新系統上：
- 確認此 repo 已設定好遠端（`git remote -v`）
- 確認你已完成 Git 身份驗證（例如 GitHub PAT/SSH Key）
- 若 repo 使用 submodule，先跑 `git submodule update --init --recursive`

## 🔧 使用前提

請先安裝對應的 CLI 工具：
- [Gemini CLI](https://github.com/google-gemini/gemini-cli)
- [Claude CLI](https://docs.anthropic.com/claude-code/docs)
- [Codex CLI](https://github.com/openai/codex)

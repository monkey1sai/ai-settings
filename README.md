# AI Settings Manager

統一管理 **Gemini CLI**、**Claude CLI**、**Codex CLI** 的設定、技能與擴充套件。

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
git clone https://github.com/YOUR_USERNAME/ai-settings.git
cd ai-settings
.\scripts\restore.ps1
```

## 📁 專案結構

```
ai-settings/
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

## 🔧 使用前提

請先安裝對應的 CLI 工具：
- [Gemini CLI](https://github.com/google-gemini/gemini-cli)
- [Claude CLI](https://docs.anthropic.com/claude-code/docs)
- [Codex CLI](https://github.com/openai/codex)

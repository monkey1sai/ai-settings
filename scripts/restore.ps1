<#
.SYNOPSIS
    AI Settings Restore Script - 在新電腦上還原 AI CLI 設定
.DESCRIPTION
    ⚠️ 此腳本設計用於「新電腦」或「全新安裝」的情況！
    
    安全機制：
    - 如果偵測到現有設定，會要求明確確認
    - 預設會備份現有設定到 *.backup 目錄
    - 使用 -DryRun 可預覽不執行
    
.PARAMETER DryRun
    預覽模式，不實際執行任何操作
.PARAMETER Force
    強制執行，跳過確認（不建議使用）
.NOTES
    ⚠️ 警告：此腳本會覆蓋目標設定！
    請確保在「新電腦」上使用，或已備份重要設定。
#>

param(
    [switch]$DryRun,
    [switch]$Force
)

$ErrorActionPreference = "Stop"

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$UserHome = $env:USERPROFILE
$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

Write-Host "╔══════════════════════════════════════════════╗" -ForegroundColor Red
Write-Host "║     AI Settings Restore Script               ║" -ForegroundColor Red
Write-Host "║     ⚠️ 此腳本會修改本機設定！                ║" -ForegroundColor Red
Write-Host "╚══════════════════════════════════════════════╝" -ForegroundColor Red
Write-Host ""

if ($DryRun) {
    Write-Host "[DRY RUN] 預覽模式 - 不會實際修改任何檔案" -ForegroundColor Yellow
    Write-Host ""
}

# ============================================================
# 安全檢查：偵測現有設定
# ============================================================

$existingConfigs = @()

$geminiDir = Join-Path $UserHome ".gemini"
$claudeDir = Join-Path $UserHome ".claude"
$codexDir = Join-Path $UserHome ".codex"

if (Test-Path $geminiDir) { $existingConfigs += "Gemini ($geminiDir)" }
if (Test-Path $claudeDir) { $existingConfigs += "Claude ($claudeDir)" }
if (Test-Path $codexDir) { $existingConfigs += "Codex ($codexDir)" }

if ($existingConfigs.Count -gt 0 -and -not $Force -and -not $DryRun) {
    Write-Host "⚠️ 偵測到現有設定：" -ForegroundColor Yellow
    foreach ($config in $existingConfigs) {
        Write-Host "   • $config" -ForegroundColor Yellow
    }
    Write-Host ""
    Write-Host "此腳本會：" -ForegroundColor White
    Write-Host "  1. 將現有設定備份到 *.backup.$Timestamp" -ForegroundColor Gray
    Write-Host "  2. 用專案中的設定覆蓋現有設定" -ForegroundColor Gray
    Write-Host ""
    
    $confirm = Read-Host "確定要繼續嗎？輸入 'YES' 確認"
    if ($confirm -ne "YES") {
        Write-Host ""
        Write-Host "❌ 操作已取消" -ForegroundColor Red
        Write-Host "提示：使用 -DryRun 可預覽操作" -ForegroundColor Gray
        exit 0
    }
    Write-Host ""
}

# ============================================================
# 還原函數
# ============================================================

function Backup-Existing {
    param(
        [string]$Path
    )
    
    if (Test-Path $Path) {
        $backupPath = "$Path.backup.$Timestamp"
        if ($DryRun) {
            Write-Host "  [BACKUP] $Path -> $backupPath" -ForegroundColor Gray
        } else {
            Rename-Item -Path $Path -NewName (Split-Path -Leaf $backupPath)
            Write-Host "  ⚡ Backed up existing to $backupPath" -ForegroundColor Yellow
        }
    }
}

function Restore-File {
    param(
        [string]$Source,
        [string]$Destination
    )
    
    if (Test-Path $Source) {
        $destDir = Split-Path -Parent $Destination
        if (-not (Test-Path $destDir)) {
            if ($DryRun) {
                Write-Host "  [MKDIR] $destDir" -ForegroundColor Gray
            } else {
                New-Item -ItemType Directory -Path $destDir -Force | Out-Null
            }
        }
        
        if ($DryRun) {
            Write-Host "  [RESTORE] $Source -> $Destination" -ForegroundColor Gray
        } else {
            Copy-Item -Path $Source -Destination $Destination -Force
            Write-Host "  ✓ $(Split-Path -Leaf $Destination)" -ForegroundColor Green
        }
    } else {
        Write-Host "  ⊘ Source not found: $Source" -ForegroundColor DarkGray
    }
}

function Restore-Directory {
    param(
        [string]$Source,
        [string]$Destination
    )
    
    if (Test-Path $Source) {
        if (-not (Test-Path $Destination)) {
            if ($DryRun) {
                Write-Host "  [MKDIR] $Destination" -ForegroundColor Gray
            } else {
                New-Item -ItemType Directory -Path $Destination -Force | Out-Null
            }
        }
        
        $items = Get-ChildItem -Path $Source -Directory
        $count = ($items | Measure-Object).Count
        
        if ($DryRun) {
            Write-Host "  [RESTORE DIR] $count items to $Destination" -ForegroundColor Gray
        } else {
            foreach ($item in $items) {
                Copy-Item -Path $item.FullName -Destination $Destination -Recurse -Force
            }
            Write-Host "  ✓ $count directories restored" -ForegroundColor Green
        }
    } else {
        Write-Host "  ⊘ Source directory not found: $Source" -ForegroundColor DarkGray
    }
}

# ============================================================
# Gemini CLI 還原
# ============================================================

Write-Host "📦 Gemini CLI" -ForegroundColor Blue

$geminiDest = Join-Path $UserHome ".gemini"
$geminiSource = Join-Path $ProjectRoot "configs\gemini"

# 備份現有設定檔（不備份整個目錄，只備份會被覆蓋的檔案）
if (Test-Path "$geminiDest\settings.json") {
    Backup-Existing -Path "$geminiDest\settings.json"
}
if (Test-Path "$geminiDest\GEMINI.md") {
    Backup-Existing -Path "$geminiDest\GEMINI.md"
}

Restore-File -Source "$geminiSource\settings.json" -Destination "$geminiDest\settings.json"
Restore-File -Source "$geminiSource\GEMINI.md" -Destination "$geminiDest\GEMINI.md"

Write-Host "  Skills:" -ForegroundColor DarkCyan
Restore-Directory -Source (Join-Path $ProjectRoot "skills\gemini") -Destination "$geminiDest\skills"

Write-Host "  Extensions:" -ForegroundColor DarkCyan
Restore-Directory -Source (Join-Path $ProjectRoot "extensions\gemini") -Destination "$geminiDest\extensions"

Write-Host ""

# ============================================================
# Claude CLI 還原
# ============================================================

Write-Host "📦 Claude CLI" -ForegroundColor Blue

$claudeDest = Join-Path $UserHome ".claude"
$claudeSource = Join-Path $ProjectRoot "configs\claude"

if (Test-Path "$claudeDest\settings.json") {
    Backup-Existing -Path "$claudeDest\settings.json"
}

Restore-File -Source "$claudeSource\settings.json" -Destination "$claudeDest\settings.json"
Restore-File -Source "$claudeSource\settings.local.json" -Destination "$claudeDest\settings.local.json"

# Claude plugins
$pluginsDest = "$claudeDest\plugins"
if (-not (Test-Path $pluginsDest) -and -not $DryRun) {
    New-Item -ItemType Directory -Path $pluginsDest -Force | Out-Null
}
Restore-File -Source "$claudeSource\installed_plugins.json" -Destination "$pluginsDest\installed_plugins.json"
Restore-File -Source "$claudeSource\known_marketplaces.json" -Destination "$pluginsDest\known_marketplaces.json"

Write-Host ""

# ============================================================
# Codex CLI 還原
# ============================================================

Write-Host "📦 Codex CLI" -ForegroundColor Blue

$codexDest = Join-Path $UserHome ".codex"
$codexSource = Join-Path $ProjectRoot "configs\codex"

if (Test-Path "$codexDest\config.toml") {
    Backup-Existing -Path "$codexDest\config.toml"
}
if (Test-Path "$codexDest\AGENTS.md") {
    Backup-Existing -Path "$codexDest\AGENTS.md"
}

Restore-File -Source "$codexSource\config.toml" -Destination "$codexDest\config.toml"
Restore-File -Source "$codexSource\AGENTS.md" -Destination "$codexDest\AGENTS.md"
Restore-File -Source "$codexSource\SYSTEM.md" -Destination "$codexDest\SYSTEM.md"

Write-Host "  Skills:" -ForegroundColor DarkCyan
Restore-Directory -Source (Join-Path $ProjectRoot "skills\codex") -Destination "$codexDest\skills"

Write-Host "  Rules:" -ForegroundColor DarkCyan
$rulesSource = Join-Path $ProjectRoot "rules\codex"
$rulesDest = "$codexDest\rules"
if (-not (Test-Path $rulesDest) -and -not $DryRun) {
    New-Item -ItemType Directory -Path $rulesDest -Force | Out-Null
}
Restore-File -Source "$rulesSource\default.rules" -Destination "$rulesDest\default.rules"

Write-Host ""

# ============================================================
# 完成
# ============================================================

Write-Host "════════════════════════════════════════════════" -ForegroundColor Cyan
if ($DryRun) {
    Write-Host "✅ 預覽完成！移除 -DryRun 參數以執行實際還原" -ForegroundColor Yellow
} else {
    Write-Host "✅ 還原完成！" -ForegroundColor Green
    Write-Host ""
    Write-Host "⚠️ 重要提醒：" -ForegroundColor Yellow
    Write-Host "  • 請重新登入各 CLI 工具" -ForegroundColor White
    Write-Host "  • Gemini: gemini auth login" -ForegroundColor Gray
    Write-Host "  • Claude: claude auth login" -ForegroundColor Gray
    Write-Host "  • Codex:  codex auth" -ForegroundColor Gray
}
Write-Host ""

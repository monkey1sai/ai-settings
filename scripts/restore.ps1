<#
.SYNOPSIS
    openAI CLI Restore Script - 在新電腦上還原 AI CLI 設定
.DESCRIPTION
    預設使用「鏡像還原」模式：
    - 會先重建目標目錄（.gemini/.claude/.codex）
    - 不保留原電腦的舊設定資料於使用路徑
    - 使用 -BackupExisting 可先備份舊目錄再還原

.PARAMETER DryRun
    預覽模式，不實際執行任何操作
.PARAMETER Force
    強制執行，跳過確認（不建議使用）
.PARAMETER BackupExisting
    還原前先將現有目錄改名為 *.backup.<timestamp>
.NOTES
    ⚠️ 警告：此腳本會重建目標設定目錄。
#>

param(
    [switch]$DryRun,
    [switch]$Force,
    [switch]$BackupExisting
)

$ErrorActionPreference = "Stop"

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$UserHome = if ($HOME) {
    $HOME
} elseif ($env:USERPROFILE) {
    $env:USERPROFILE
} else {
    [Environment]::GetFolderPath([Environment+SpecialFolder]::UserProfile)
}
$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

Write-Host "╔══════════════════════════════════════════════╗" -ForegroundColor Red
Write-Host "║     openAI CLI Restore Script                ║" -ForegroundColor Red
Write-Host "║     ⚠️  預設會重建目標設定目錄               ║" -ForegroundColor Red
Write-Host "╚══════════════════════════════════════════════╝" -ForegroundColor Red
Write-Host ""

if ($DryRun) {
    Write-Host "[DRY RUN] 預覽模式 - 不會實際修改任何檔案" -ForegroundColor Yellow
    Write-Host ""
}

if ($BackupExisting) {
    Write-Host "[BACKUP MODE] 現有目錄將改名為 *.backup.$Timestamp" -ForegroundColor Yellow
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
    if ($BackupExisting) {
        Write-Host "  1. 將現有目錄改名為 *.backup.$Timestamp" -ForegroundColor Gray
        Write-Host "  2. 以 repo 設定重建目標目錄" -ForegroundColor Gray
    } else {
        Write-Host "  1. 移除現有目錄內容（不保留舊資料於使用路徑）" -ForegroundColor Gray
        Write-Host "  2. 以 repo 設定重建目標目錄" -ForegroundColor Gray
    }
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

function Prepare-TargetDirectory {
    param(
        [string]$Path,
        [string]$Label
    )

    if (Test-Path $Path) {
        if ($BackupExisting) {
            $backupPath = "$Path.backup.$Timestamp"
            if ($DryRun) {
                Write-Host "  [BACKUP] ${Label}: $Path -> $backupPath" -ForegroundColor Gray
            } else {
                Rename-Item -Path $Path -NewName (Split-Path -Leaf $backupPath)
                Write-Host "  ⚡ $Label backed up to $backupPath" -ForegroundColor Yellow
            }
        } else {
            if ($DryRun) {
                Write-Host "  [RESET] ${Label}: remove $Path" -ForegroundColor Gray
            } else {
                Remove-Item -Path $Path -Recurse -Force
                Write-Host "  ✗ $Label old data removed" -ForegroundColor DarkYellow
            }
        }
    }

    if (-not (Test-Path $Path)) {
        if ($DryRun) {
            Write-Host "  [MKDIR] $Path" -ForegroundColor Gray
        } else {
            New-Item -ItemType Directory -Path $Path -Force | Out-Null
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
        [string]$Destination,
        [string[]]$Exclude = @()
    )

    if (-not (Test-Path $Source)) {
        Write-Host "  ⊘ Source directory not found: $Source" -ForegroundColor DarkGray
        return
    }

    if (-not (Test-Path $Destination)) {
        if ($DryRun) {
            Write-Host "  [MKDIR] $Destination" -ForegroundColor Gray
        } else {
            New-Item -ItemType Directory -Path $Destination -Force | Out-Null
        }
    }

    $items = Get-ChildItem -Path $Source -Force | Where-Object { $_.Name -notin $Exclude }
    $count = ($items | Measure-Object).Count

    if ($DryRun) {
        Write-Host "  [RESTORE DIR] $count items to $Destination" -ForegroundColor Gray
    } else {
        foreach ($item in $items) {
            Copy-Item -Path $item.FullName -Destination $Destination -Recurse -Force
        }
        Write-Host "  ✓ $count items restored" -ForegroundColor Green
    }
}

# ============================================================
# Gemini CLI 還原
# ============================================================

Write-Host "📦 Gemini CLI" -ForegroundColor Blue

$geminiDest = Join-Path $UserHome ".gemini"
$geminiSource = [IO.Path]::Combine($ProjectRoot, 'configs', 'gemini')

Prepare-TargetDirectory -Path $geminiDest -Label "Gemini"
Restore-File -Source ([IO.Path]::Combine($geminiSource, 'settings.json')) -Destination ([IO.Path]::Combine($geminiDest, 'settings.json'))
Restore-File -Source ([IO.Path]::Combine($geminiSource, 'GEMINI.md')) -Destination ([IO.Path]::Combine($geminiDest, 'GEMINI.md'))

Write-Host "  Skills:" -ForegroundColor DarkCyan
$geminiSkillsSource = [IO.Path]::Combine($ProjectRoot, 'skills', 'gemini')
$geminiSkillsDest = [IO.Path]::Combine($geminiDest, 'skills')
Restore-Directory -Source $geminiSkillsSource -Destination $geminiSkillsDest

Write-Host "  Extensions:" -ForegroundColor DarkCyan
$geminiExtensionsSource = [IO.Path]::Combine($ProjectRoot, 'extensions', 'gemini')
$geminiExtensionsDest = [IO.Path]::Combine($geminiDest, 'extensions')
Restore-Directory -Source $geminiExtensionsSource -Destination $geminiExtensionsDest

Write-Host ""

# ============================================================
# Claude CLI 還原
# ============================================================

Write-Host "📦 Claude CLI" -ForegroundColor Blue

$claudeDest = Join-Path $UserHome ".claude"
$claudeSource = [IO.Path]::Combine($ProjectRoot, 'configs', 'claude')

Prepare-TargetDirectory -Path $claudeDest -Label "Claude"
Restore-File -Source ([IO.Path]::Combine($claudeSource, 'settings.json')) -Destination ([IO.Path]::Combine($claudeDest, 'settings.json'))
Restore-File -Source ([IO.Path]::Combine($claudeSource, 'settings.local.json')) -Destination ([IO.Path]::Combine($claudeDest, 'settings.local.json'))
Restore-File -Source ([IO.Path]::Combine($claudeSource, 'installed_plugins.json')) -Destination ([IO.Path]::Combine($claudeDest, 'plugins', 'installed_plugins.json'))
Restore-File -Source ([IO.Path]::Combine($claudeSource, 'known_marketplaces.json')) -Destination ([IO.Path]::Combine($claudeDest, 'plugins', 'known_marketplaces.json'))

Write-Host ""

# ============================================================
# Codex CLI 還原
# ============================================================

Write-Host "📦 Codex CLI" -ForegroundColor Blue

$codexDest = Join-Path $UserHome ".codex"
$codexSource = [IO.Path]::Combine($ProjectRoot, 'configs', 'codex')

Prepare-TargetDirectory -Path $codexDest -Label "Codex"
Restore-File -Source ([IO.Path]::Combine($codexSource, 'config.toml')) -Destination ([IO.Path]::Combine($codexDest, 'config.toml'))
Restore-File -Source ([IO.Path]::Combine($codexSource, 'AGENTS.md')) -Destination ([IO.Path]::Combine($codexDest, 'AGENTS.md'))
Restore-File -Source ([IO.Path]::Combine($codexSource, 'SYSTEM.md')) -Destination ([IO.Path]::Combine($codexDest, 'SYSTEM.md'))

Write-Host "  Skills:" -ForegroundColor DarkCyan
$codexSkillsSource = [IO.Path]::Combine($ProjectRoot, 'skills', 'codex')
$codexSkillsDest = [IO.Path]::Combine($codexDest, 'skills')
Restore-Directory -Source $codexSkillsSource -Destination $codexSkillsDest

Write-Host "  Rules:" -ForegroundColor DarkCyan
$rulesSource = [IO.Path]::Combine($ProjectRoot, 'rules', 'codex')
$rulesDest = [IO.Path]::Combine($codexDest, 'rules')
Restore-Directory -Source $rulesSource -Destination $rulesDest

Write-Host ""

# ============================================================
# 完成
# ============================================================

Write-Host "════════════════════════════════════════════════" -ForegroundColor Cyan
if ($DryRun) {
    Write-Host "✅ 預覽完成！移除 -DryRun 參數以執行實際還原" -ForegroundColor Yellow
} else {
    Write-Host "✅ 還原完成！" -ForegroundColor Green
    if ($BackupExisting) {
        Write-Host "  先前設定已備份為 *.backup.$Timestamp" -ForegroundColor Yellow
    }
    Write-Host ""
    Write-Host "⚠️ 重要提醒：" -ForegroundColor Yellow
    Write-Host "  • 請重新登入各 CLI 工具" -ForegroundColor White
    Write-Host "  • Gemini: gemini auth login" -ForegroundColor Gray
    Write-Host "  • Claude: claude auth login" -ForegroundColor Gray
    Write-Host "  • Codex:  codex auth" -ForegroundColor Gray
}
Write-Host ""

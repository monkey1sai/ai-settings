<#
.SYNOPSIS
    AI Settings Backup Script - 備份 AI CLI 設定到專案
.DESCRIPTION
    此腳本只會「讀取」本機設定，並「複製」到專案目錄中。
    ⚠️ 不會修改任何本機設定檔案。
.NOTES
    安全性：唯讀操作，不會影響本機 CLI 設定
#>

param(
    [switch]$DryRun  # 預覽模式，不實際複製
)

$ErrorActionPreference = "Stop"

# 專案根目錄（腳本所在位置的上層）
$ProjectRoot = Split-Path -Parent $PSScriptRoot

# 使用者家目錄
$UserHome = $env:USERPROFILE

Write-Host "╔══════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║     AI Settings Backup Script                ║" -ForegroundColor Cyan
Write-Host "║     ⚠️ 唯讀模式：不會修改本機設定            ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

if ($DryRun) {
    Write-Host "[DRY RUN] 預覽模式 - 不會實際複製檔案" -ForegroundColor Yellow
    Write-Host ""
}

# ============================================================
# 備份函數
# ============================================================

function Backup-File {
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
            Write-Host "  [COPY] $Source" -ForegroundColor Gray
            Write-Host "      -> $Destination" -ForegroundColor DarkGray
        } else {
            Copy-Item -Path $Source -Destination $Destination -Force
            Write-Host "  ✓ $(Split-Path -Leaf $Source)" -ForegroundColor Green
        }
    } else {
        Write-Host "  ⊘ $(Split-Path -Leaf $Source) (not found)" -ForegroundColor DarkGray
    }
}

function Backup-Directory {
    param(
        [string]$Source,
        [string]$Destination,
        [string[]]$Exclude = @()
    )
    
    if (Test-Path $Source) {
        if (-not (Test-Path $Destination)) {
            if ($DryRun) {
                Write-Host "  [MKDIR] $Destination" -ForegroundColor Gray
            } else {
                New-Item -ItemType Directory -Path $Destination -Force | Out-Null
            }
        }
        
        $items = Get-ChildItem -Path $Source -Directory | Where-Object { $_.Name -notin $Exclude }
        $count = ($items | Measure-Object).Count
        
        if ($DryRun) {
            Write-Host "  [COPY DIR] $Source ($count items)" -ForegroundColor Gray
        } else {
            foreach ($item in $items) {
                Copy-Item -Path $item.FullName -Destination $Destination -Recurse -Force
            }
            Write-Host "  ✓ $count directories copied" -ForegroundColor Green
        }
    } else {
        Write-Host "  ⊘ Directory not found: $Source" -ForegroundColor DarkGray
    }
}

# ============================================================
# Gemini CLI 備份
# ============================================================

Write-Host "📦 Gemini CLI" -ForegroundColor Blue
$geminiSource = Join-Path $UserHome ".gemini"
$geminiDest = Join-Path $ProjectRoot "configs\gemini"

Backup-File -Source "$geminiSource\settings.json" -Destination "$geminiDest\settings.json"
Backup-File -Source "$geminiSource\GEMINI.md" -Destination "$geminiDest\GEMINI.md"

Write-Host "  Skills:" -ForegroundColor DarkCyan
Backup-Directory -Source "$geminiSource\skills" -Destination (Join-Path $ProjectRoot "skills\gemini")

Write-Host "  Extensions:" -ForegroundColor DarkCyan
Backup-Directory -Source "$geminiSource\extensions" -Destination (Join-Path $ProjectRoot "extensions\gemini") -Exclude @("extension-enablement.json")

# 複製 extension enablement
Backup-File -Source "$geminiSource\extensions\extension-enablement.json" -Destination (Join-Path $ProjectRoot "extensions\gemini\extension-enablement.json")

Write-Host ""

# ============================================================
# Claude CLI 備份
# ============================================================

Write-Host "📦 Claude CLI" -ForegroundColor Blue
$claudeSource = Join-Path $UserHome ".claude"
$claudeDest = Join-Path $ProjectRoot "configs\claude"

Backup-File -Source "$claudeSource\settings.json" -Destination "$claudeDest\settings.json"
Backup-File -Source "$claudeSource\settings.local.json" -Destination "$claudeDest\settings.local.json"
Backup-File -Source "$claudeSource\plugins\installed_plugins.json" -Destination "$claudeDest\installed_plugins.json"
Backup-File -Source "$claudeSource\plugins\known_marketplaces.json" -Destination "$claudeDest\known_marketplaces.json"

Write-Host ""

# ============================================================
# Codex CLI 備份
# ============================================================

Write-Host "📦 Codex CLI" -ForegroundColor Blue
$codexSource = Join-Path $UserHome ".codex"
$codexDest = Join-Path $ProjectRoot "configs\codex"

# 備份 config.toml（需要過濾 [projects] 區塊）
$configPath = "$codexSource\config.toml"
if (Test-Path $configPath) {
    $configContent = Get-Content $configPath -Raw
    
    # 移除 [projects.*] 區塊（這些包含本機路徑）
    $cleanedConfig = $configContent -replace '(?ms)\[projects\.[^\]]+\]\r?\ntrust_level = "[^"]+"\r?\n', ''
    
    $destPath = "$codexDest\config.toml"
    $destDir = Split-Path -Parent $destPath
    
    if (-not (Test-Path $destDir)) {
        if (-not $DryRun) {
            New-Item -ItemType Directory -Path $destDir -Force | Out-Null
        }
    }
    
    if ($DryRun) {
        Write-Host "  [COPY+CLEAN] config.toml (removed [projects] sections)" -ForegroundColor Gray
    } else {
        $cleanedConfig | Set-Content -Path $destPath -NoNewline
        Write-Host "  ✓ config.toml (cleaned)" -ForegroundColor Green
    }
} else {
    Write-Host "  ⊘ config.toml (not found)" -ForegroundColor DarkGray
}

Backup-File -Source "$codexSource\AGENTS.md" -Destination "$codexDest\AGENTS.md"
Backup-File -Source "$codexSource\SYSTEM.md" -Destination "$codexDest\SYSTEM.md"

Write-Host "  Skills:" -ForegroundColor DarkCyan
Backup-Directory -Source "$codexSource\skills" -Destination (Join-Path $ProjectRoot "skills\codex") -Exclude @(".system", "dist")

Write-Host "  Rules:" -ForegroundColor DarkCyan
Backup-Directory -Source "$codexSource\rules" -Destination (Join-Path $ProjectRoot "rules\codex")
Backup-File -Source "$codexSource\rules\default.rules" -Destination (Join-Path $ProjectRoot "rules\codex\default.rules")

Write-Host ""

# ============================================================
# 完成
# ============================================================

Write-Host "════════════════════════════════════════════════" -ForegroundColor Cyan
if ($DryRun) {
    Write-Host "✅ 預覽完成！使用 .\backup.ps1 執行實際備份" -ForegroundColor Yellow
} else {
    Write-Host "✅ 備份完成！" -ForegroundColor Green
    Write-Host ""
    Write-Host "下一步：" -ForegroundColor White
    Write-Host "  git add -A" -ForegroundColor Gray
    Write-Host "  git commit -m 'Update AI settings backup'" -ForegroundColor Gray
    Write-Host "  git push" -ForegroundColor Gray
}
Write-Host ""

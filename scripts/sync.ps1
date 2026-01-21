<#
.SYNOPSIS
    AI Settings Sync - 同步本機設定到雲端 Git
.DESCRIPTION
    此腳本會：
    1. 讀取本機 Gemini/Claude/Codex 設定
    2. 複製到專案目錄
    3. 自動 commit 並 push 到遠端倉庫
.PARAMETER Message
    自訂的 commit 訊息 (預設: "Sync AI settings - 日期時間")
.PARAMETER BackupOnly
    只備份到專案，不執行 git 操作
.PARAMETER DryRun
    預覽模式，不實際執行
.EXAMPLE
    .\sync.ps1                               # 同步到雲端
    .\sync.ps1 -Message "新增 skill"          # 自訂訊息
    .\sync.ps1 -BackupOnly                    # 只備份，不 push
    .\sync.ps1 -DryRun                        # 預覽模式
#>

param(
    [string]$Message = "",
    [switch]$BackupOnly,
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

# 專案根目錄
$ProjectRoot = Split-Path -Parent $PSScriptRoot
$UserHome = $env:USERPROFILE

Write-Host "╔══════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║     AI Settings Sync                         ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

if ($DryRun) {
    Write-Host "[DRY RUN] 預覽模式" -ForegroundColor Yellow
    Write-Host ""
}

# ============================================================
# 備份函數
# ============================================================

function Backup-File {
    param([string]$Source, [string]$Destination)
    
    if (Test-Path $Source) {
        $destDir = Split-Path -Parent $Destination
        if (-not (Test-Path $destDir) -and -not $DryRun) {
            New-Item -ItemType Directory -Path $destDir -Force | Out-Null
        }
        
        if ($DryRun) {
            Write-Host "  [COPY] $(Split-Path -Leaf $Source)" -ForegroundColor Gray
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
        [string[]]$Exclude = @(),
        [string[]]$PreserveSubmodules = @()  # 保留這些目錄不覆蓋 (submodules)
    )
    
    if (Test-Path $Source) {
        if (-not (Test-Path $Destination) -and -not $DryRun) {
            New-Item -ItemType Directory -Path $Destination -Force | Out-Null
        }
        
        # 排除指定項目和 submodule 目錄
        $allExcludes = $Exclude + $PreserveSubmodules
        $items = Get-ChildItem -Path $Source -Directory | Where-Object { $_.Name -notin $allExcludes }
        $count = ($items | Measure-Object).Count
        
        if ($DryRun) {
            Write-Host "  [COPY] $count directories" -ForegroundColor Gray
            if ($PreserveSubmodules.Count -gt 0) {
                Write-Host "  [SKIP] Submodules: $($PreserveSubmodules -join ', ')" -ForegroundColor DarkYellow
            }
        } else {
            foreach ($item in $items) {
                Copy-Item -Path $item.FullName -Destination $Destination -Recurse -Force
            }
            Write-Host "  ✓ $count directories" -ForegroundColor Green
            if ($PreserveSubmodules.Count -gt 0) {
                Write-Host "  ⊙ Preserved submodules: $($PreserveSubmodules -join ', ')" -ForegroundColor DarkCyan
            }
        }
    } else {
        Write-Host "  ⊘ Directory not found" -ForegroundColor DarkGray
    }
}

# ============================================================
# Step 1: 複製本機設定到專案
# ============================================================

Write-Host "� Gemini CLI" -ForegroundColor Blue
$geminiSource = "$UserHome\.gemini"
$geminiDest = "$ProjectRoot\configs\gemini"

Backup-File "$geminiSource\settings.json" "$geminiDest\settings.json"
Backup-File "$geminiSource\GEMINI.md" "$geminiDest\GEMINI.md"
Write-Host "  Skills:" -ForegroundColor DarkCyan
Backup-Directory "$geminiSource\skills" "$ProjectRoot\skills\gemini"
Write-Host "  Extensions:" -ForegroundColor DarkCyan
# 排除 submodule 目錄，避免覆蓋 git 連結
$geminiSubmodules = @("datacommons", "huggingface-skills")
Backup-Directory "$geminiSource\extensions" "$ProjectRoot\extensions\gemini" -Exclude @("extension-enablement.json") -PreserveSubmodules $geminiSubmodules
Backup-File "$geminiSource\extensions\extension-enablement.json" "$ProjectRoot\extensions\gemini\extension-enablement.json"
Write-Host ""

Write-Host "📦 Claude CLI" -ForegroundColor Blue
$claudeSource = "$UserHome\.claude"
$claudeDest = "$ProjectRoot\configs\claude"

Backup-File "$claudeSource\settings.json" "$claudeDest\settings.json"
Backup-File "$claudeSource\settings.local.json" "$claudeDest\settings.local.json"
Backup-File "$claudeSource\plugins\installed_plugins.json" "$claudeDest\installed_plugins.json"
Backup-File "$claudeSource\plugins\known_marketplaces.json" "$claudeDest\known_marketplaces.json"
Write-Host ""

Write-Host "📦 Codex CLI" -ForegroundColor Blue
$codexSource = "$UserHome\.codex"
$codexDest = "$ProjectRoot\configs\codex"

# config.toml - 移除 [projects.*] 區塊
$configPath = "$codexSource\config.toml"
if (Test-Path $configPath) {
    $configContent = Get-Content $configPath -Raw
    $cleanedConfig = $configContent -replace '(?ms)\[projects\.[^\]]+\]\r?\ntrust_level = "[^"]+"\r?\n', ''
    
    if (-not (Test-Path $codexDest) -and -not $DryRun) {
        New-Item -ItemType Directory -Path $codexDest -Force | Out-Null
    }
    
    if ($DryRun) {
        Write-Host "  [COPY] config.toml (cleaned)" -ForegroundColor Gray
    } else {
        $cleanedConfig | Set-Content -Path "$codexDest\config.toml" -NoNewline
        Write-Host "  ✓ config.toml (cleaned)" -ForegroundColor Green
    }
} else {
    Write-Host "  ⊘ config.toml (not found)" -ForegroundColor DarkGray
}

Backup-File "$codexSource\AGENTS.md" "$codexDest\AGENTS.md"
Backup-File "$codexSource\SYSTEM.md" "$codexDest\SYSTEM.md"
Write-Host "  Skills:" -ForegroundColor DarkCyan
Backup-Directory "$codexSource\skills" "$ProjectRoot\skills\codex" -Exclude @(".system", "dist")
Write-Host "  Rules:" -ForegroundColor DarkCyan
Backup-Directory "$codexSource\rules" "$ProjectRoot\rules\codex"
Backup-File "$codexSource\rules\default.rules" "$ProjectRoot\rules\codex\default.rules"
Write-Host ""

# ============================================================
# Step 2: Git 同步
# ============================================================

if ($BackupOnly) {
    Write-Host "════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "✅ 備份完成！(使用 -BackupOnly，未推送到雲端)" -ForegroundColor Green
    Write-Host ""
    exit 0
}

Write-Host "🔍 檢查變更..." -ForegroundColor Blue

Push-Location $ProjectRoot

try {
    if (-not (Test-Path ".git")) {
        Write-Host "❌ 此目錄不是 Git 倉庫，請先 git init" -ForegroundColor Red
        exit 1
    }

    $status = git status --porcelain
    
    if ([string]::IsNullOrWhiteSpace($status)) {
        Write-Host "✓ 沒有需要同步的變更" -ForegroundColor Green
        exit 0
    }

    # 顯示變更摘要
    $added = ($status | Where-Object { $_ -match "^\?\?" } | Measure-Object).Count
    $modified = ($status | Where-Object { $_ -match "^ M|^M " } | Measure-Object).Count
    $deleted = ($status | Where-Object { $_ -match "^ D|^D " } | Measure-Object).Count
    
    if ($added -gt 0) { Write-Host "  + $added 新增" -ForegroundColor Green }
    if ($modified -gt 0) { Write-Host "  ~ $modified 修改" -ForegroundColor Yellow }
    if ($deleted -gt 0) { Write-Host "  - $deleted 刪除" -ForegroundColor Red }
    Write-Host ""

    Write-Host "📤 推送到雲端..." -ForegroundColor Blue

    if ([string]::IsNullOrWhiteSpace($Message)) {
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"
        $Message = "Sync AI settings - $timestamp"
    }

    if ($DryRun) {
        Write-Host "  [GIT] add -A && commit && push" -ForegroundColor Gray
    } else {
        git add -A
        git commit -m $Message
        git push
        Write-Host ""
        Write-Host "✅ 同步完成！" -ForegroundColor Green
    }

} finally {
    Pop-Location
}

Write-Host ""

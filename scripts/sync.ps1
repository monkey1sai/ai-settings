<#
.SYNOPSIS
    AI Settings Sync Script - 備份本機設定並同步到雲端 Git
.DESCRIPTION
    此腳本會：
    1. 執行 backup.ps1 備份本機設定到專案
    2. 檢查是否有變更
    3. 自動 commit 並 push 到遠端倉庫
.PARAMETER Message
    自訂的 commit 訊息 (預設: "Sync AI settings - 日期時間")
.PARAMETER DryRun
    預覽模式，不實際執行 git 操作
.EXAMPLE
    .\sync.ps1
    .\sync.ps1 -Message "新增 Gemini skill"
    .\sync.ps1 -DryRun
#>

param(
    [string]$Message = "",
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

# 專案根目錄
$ProjectRoot = Split-Path -Parent $PSScriptRoot

Write-Host "╔══════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║     AI Settings Sync Script                  ║" -ForegroundColor Cyan
Write-Host "║     📤 備份 + 推送到雲端                      ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

if ($DryRun) {
    Write-Host "[DRY RUN] 預覽模式 - 不會實際執行 git 操作" -ForegroundColor Yellow
    Write-Host ""
}

# ============================================================
# Step 1: 執行備份
# ============================================================

Write-Host "📦 Step 1: 備份本機設定..." -ForegroundColor Blue
Write-Host ""

$backupScript = Join-Path $PSScriptRoot "backup.ps1"
if ($DryRun) {
    & $backupScript -DryRun
} else {
    & $backupScript
}

# ============================================================
# Step 2: 檢查 Git 狀態
# ============================================================

Write-Host "🔍 Step 2: 檢查變更..." -ForegroundColor Blue

Push-Location $ProjectRoot

try {
    # 檢查是否是 git 倉庫
    if (-not (Test-Path ".git")) {
        Write-Host "❌ 錯誤：此目錄不是 Git 倉庫" -ForegroundColor Red
        Write-Host "   請先執行 'git init' 並設定遠端倉庫" -ForegroundColor Yellow
        exit 1
    }

    # 檢查是否有變更
    $status = git status --porcelain
    
    if ([string]::IsNullOrWhiteSpace($status)) {
        Write-Host "✓ 沒有需要同步的變更" -ForegroundColor Green
        Write-Host ""
        exit 0
    }

    # 顯示變更摘要
    $added = ($status | Where-Object { $_ -match "^\?\?" } | Measure-Object).Count
    $modified = ($status | Where-Object { $_ -match "^ M|^M " } | Measure-Object).Count
    $deleted = ($status | Where-Object { $_ -match "^ D|^D " } | Measure-Object).Count
    
    Write-Host ""
    Write-Host "  變更摘要:" -ForegroundColor White
    if ($added -gt 0) { Write-Host "    + $added 新增" -ForegroundColor Green }
    if ($modified -gt 0) { Write-Host "    ~ $modified 修改" -ForegroundColor Yellow }
    if ($deleted -gt 0) { Write-Host "    - $deleted 刪除" -ForegroundColor Red }
    Write-Host ""

    # ============================================================
    # Step 3: Git 操作
    # ============================================================

    Write-Host "📤 Step 3: 推送到雲端..." -ForegroundColor Blue

    # 產生 commit 訊息
    if ([string]::IsNullOrWhiteSpace($Message)) {
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"
        $Message = "Sync AI settings - $timestamp"
    }

    if ($DryRun) {
        Write-Host "  [GIT ADD] git add -A" -ForegroundColor Gray
        Write-Host "  [GIT COMMIT] git commit -m '$Message'" -ForegroundColor Gray
        Write-Host "  [GIT PUSH] git push" -ForegroundColor Gray
    } else {
        # Add all changes
        Write-Host "  Adding files..." -ForegroundColor DarkGray
        git add -A

        # Commit
        Write-Host "  Committing..." -ForegroundColor DarkGray
        git commit -m $Message

        # Push
        Write-Host "  Pushing to remote..." -ForegroundColor DarkGray
        git push

        Write-Host ""
        Write-Host "✅ 同步完成！" -ForegroundColor Green
    }

} catch {
    Write-Host "❌ 錯誤：$($_.Exception.Message)" -ForegroundColor Red
    exit 1
} finally {
    Pop-Location
}

Write-Host ""

# ============================================================
# 完成提示
# ============================================================

if ($DryRun) {
    Write-Host "════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "✅ 預覽完成！執行 .\sync.ps1 進行實際同步" -ForegroundColor Yellow
    Write-Host ""
}

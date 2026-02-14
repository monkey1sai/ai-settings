<#
.SYNOPSIS
    openAI CLI Sync - 同步本機設定到雲端 Git
.DESCRIPTION
    此腳本會：
    1. 讀取本機 Gemini/Claude/Codex 設定
    2. 複製到專案目錄
    3. 自動 commit 並 push 到遠端倉庫
.PARAMETER Message
    自訂的 commit 訊息 (預設: "Sync openAI CLI - 日期時間")
.PARAMETER BackupOnly
    只備份到專案，不執行 git 操作
.PARAMETER NoMirror
    關閉鏡像模式（預設為鏡像模式，會刪除專案端多餘檔案/目錄）
.PARAMETER DryRun
    預覽模式，不實際執行
.EXAMPLE
    .\sync.ps1                               # 同步到雲端
    .\sync.ps1 -Message "新增 skill"          # 自訂訊息
    .\sync.ps1 -BackupOnly                    # 只備份，不 push
    .\sync.ps1 -NoMirror                      # 關閉鏡像模式
    .\sync.ps1 -DryRun                        # 預覽模式
#>

param(
    [string]$Message = "",
    [switch]$BackupOnly,
    [switch]$NoMirror,
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"
$MirrorMode = -not $NoMirror

# 專案根目錄
$ProjectRoot = Split-Path -Parent $PSScriptRoot
$UserHome = if ($HOME) {
    $HOME
} elseif ($env:USERPROFILE) {
    $env:USERPROFILE
} else {
    [Environment]::GetFolderPath([Environment+SpecialFolder]::UserProfile)
}

Write-Host "╔══════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║     openAI CLI Sync                          ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

if ($DryRun) {
    Write-Host "[DRY RUN] 預覽模式" -ForegroundColor Yellow
    Write-Host ""
}

if ($MirrorMode) {
    Write-Host "[MIRROR] 預設鏡像模式：目的端會移除多餘檔案/目錄" -ForegroundColor Yellow
    Write-Host ""
}

if ($NoMirror) {
    Write-Host "[NO MIRROR] 已關閉鏡像模式：僅覆蓋現有項目" -ForegroundColor Yellow
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
        if ($MirrorMode -and (Test-Path $Destination)) {
            if ($DryRun) {
                Write-Host "  [DELETE] $(Split-Path -Leaf $Destination) (source missing)" -ForegroundColor DarkYellow
            } else {
                Remove-Item -Path $Destination -Force
                Write-Host "  ✗ removed $(Split-Path -Leaf $Destination) (source missing)" -ForegroundColor DarkYellow
            }
        } else {
            Write-Host "  ⊘ $(Split-Path -Leaf $Source) (not found)" -ForegroundColor DarkGray
        }
    }
}

function Backup-Directory {
    param(
        [string]$Source,
        [string]$Destination,
        [string[]]$Exclude = @(),
        [string[]]$PreserveSubmodules = @()  # 保留這些目錄不覆蓋 (submodules)
    )

    if (-not (Test-Path $Source)) {
        if ($MirrorMode -and (Test-Path $Destination)) {
            if ($DryRun) {
                Write-Host "  [DELETE DIR] $Destination (source missing)" -ForegroundColor DarkYellow
            } else {
                Remove-Item -Path $Destination -Recurse -Force
                Write-Host "  ✗ removed directory (source missing)" -ForegroundColor DarkYellow
            }
        } else {
            Write-Host "  ⊘ Directory not found" -ForegroundColor DarkGray
        }
        return
    }

    if (-not (Test-Path $Destination) -and -not $DryRun) {
        New-Item -ItemType Directory -Path $Destination -Force | Out-Null
    }

    $protectedNames = @($Exclude + $PreserveSubmodules) | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
    $sourceDirs = Get-ChildItem -Path $Source -Directory | Where-Object { $_.Name -notin $protectedNames }
    $sourceFiles = Get-ChildItem -Path $Source -File | Where-Object { $_.Name -notin $protectedNames }
    $dirCount = ($sourceDirs | Measure-Object).Count
    $fileCount = ($sourceFiles | Measure-Object).Count

    if ($MirrorMode -and (Test-Path $Destination)) {
        # Mirror 模式：移除 Destination 中已不存在於 Source 的目錄與檔案（排除 protectedNames）
        $destDirs = Get-ChildItem -Path $Destination -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -notin $protectedNames }
        $toRemoveDirs = $destDirs | Where-Object { $_.Name -notin $sourceDirs.Name }
        foreach ($d in $toRemoveDirs) {
            if ($DryRun) {
                Write-Host "  [DELETE] $($d.Name)" -ForegroundColor DarkYellow
            } else {
                Remove-Item -Path $d.FullName -Recurse -Force
                Write-Host "  ✗ removed $($d.Name)" -ForegroundColor DarkYellow
            }
        }

        $destFiles = Get-ChildItem -Path $Destination -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -notin $protectedNames }
        $toRemoveFiles = $destFiles | Where-Object { $_.Name -notin $sourceFiles.Name }
        foreach ($f in $toRemoveFiles) {
            if ($DryRun) {
                Write-Host "  [DELETE] $($f.Name)" -ForegroundColor DarkYellow
            } else {
                Remove-Item -Path $f.FullName -Force
                Write-Host "  ✗ removed $($f.Name)" -ForegroundColor DarkYellow
            }
        }
    }

    if ($DryRun) {
        Write-Host "  [COPY] $dirCount directories, $fileCount files" -ForegroundColor Gray
        if ($PreserveSubmodules.Count -gt 0) {
            Write-Host "  [SKIP] Submodules: $($PreserveSubmodules -join ', ')" -ForegroundColor DarkYellow
        }
    } else {
        foreach ($item in $sourceDirs) {
            $destItem = Join-Path $Destination $item.Name
            if ($MirrorMode -and (Test-Path $destItem)) {
                Remove-Item -Path $destItem -Recurse -Force
            }
            Copy-Item -Path $item.FullName -Destination $Destination -Recurse -Force
        }

        foreach ($file in $sourceFiles) {
            Copy-Item -Path $file.FullName -Destination (Join-Path $Destination $file.Name) -Force
        }

        Write-Host "  ✓ $dirCount directories, $fileCount files" -ForegroundColor Green
        if ($PreserveSubmodules.Count -gt 0) {
            Write-Host "  ⊙ Preserved submodules: $($PreserveSubmodules -join ', ')" -ForegroundColor DarkCyan
        }
    }
}

# ============================================================
# Step 1: 複製本機設定到專案
# ============================================================

Write-Host "📦 Gemini CLI" -ForegroundColor Blue
$geminiSource = Join-Path $UserHome ".gemini"
$geminiDest = [IO.Path]::Combine($ProjectRoot, 'configs', 'gemini')

Backup-File (Join-Path $geminiSource "settings.json") (Join-Path $geminiDest "settings.json")
Backup-File (Join-Path $geminiSource "GEMINI.md") (Join-Path $geminiDest "GEMINI.md")
Write-Host "  Skills:" -ForegroundColor DarkCyan
Backup-Directory (Join-Path $geminiSource "skills") ([IO.Path]::Combine($ProjectRoot, 'skills', 'gemini'))
Write-Host "  Extensions:" -ForegroundColor DarkCyan
# 排除 submodule 目錄，避免覆蓋 git 連結
$geminiSubmodules = @("datacommons", "huggingface-skills")
Backup-Directory (Join-Path $geminiSource "extensions") ([IO.Path]::Combine($ProjectRoot, 'extensions', 'gemini')) -Exclude @("extension-enablement.json") -PreserveSubmodules $geminiSubmodules
Backup-File ([IO.Path]::Combine($geminiSource, 'extensions', 'extension-enablement.json')) ([IO.Path]::Combine($ProjectRoot, 'extensions', 'gemini', 'extension-enablement.json'))
Write-Host ""

Write-Host "📦 Claude CLI" -ForegroundColor Blue
$claudeSource = Join-Path $UserHome ".claude"
$claudeDest = [IO.Path]::Combine($ProjectRoot, 'configs', 'claude')

Backup-File (Join-Path $claudeSource "settings.json") (Join-Path $claudeDest "settings.json")
Backup-File (Join-Path $claudeSource "settings.local.json") (Join-Path $claudeDest "settings.local.json")
Backup-File ([IO.Path]::Combine($claudeSource, 'plugins', 'installed_plugins.json')) (Join-Path $claudeDest "installed_plugins.json")
Backup-File ([IO.Path]::Combine($claudeSource, 'plugins', 'known_marketplaces.json')) (Join-Path $claudeDest "known_marketplaces.json")
Write-Host ""

Write-Host "📦 Codex CLI" -ForegroundColor Blue
$codexSource = Join-Path $UserHome ".codex"
$codexDest = [IO.Path]::Combine($ProjectRoot, 'configs', 'codex')

# config.toml - 移除 [projects.*] 區塊
$configPath = Join-Path $codexSource "config.toml"
if (Test-Path $configPath) {
    $configContent = Get-Content $configPath -Raw
    $cleanedConfig = $configContent -replace '(?ms)\[projects\.[^\]]+\]\r?\ntrust_level = "[^"]+"\r?\n', ''
    
    if (-not (Test-Path $codexDest) -and -not $DryRun) {
        New-Item -ItemType Directory -Path $codexDest -Force | Out-Null
    }
    
    if ($DryRun) {
        Write-Host "  [COPY] config.toml (cleaned)" -ForegroundColor Gray
    } else {
        $cleanedConfig | Set-Content -Path (Join-Path $codexDest "config.toml") -NoNewline
        Write-Host "  ✓ config.toml (cleaned)" -ForegroundColor Green
    }
} else {
    $targetConfig = Join-Path $codexDest "config.toml"
    if ($MirrorMode -and (Test-Path $targetConfig)) {
        if ($DryRun) {
            Write-Host "  [DELETE] config.toml (source missing)" -ForegroundColor DarkYellow
        } else {
            Remove-Item -Path $targetConfig -Force
            Write-Host "  ✗ removed config.toml (source missing)" -ForegroundColor DarkYellow
        }
    } else {
        Write-Host "  ⊘ config.toml (not found)" -ForegroundColor DarkGray
    }
}

Backup-File (Join-Path $codexSource "AGENTS.md") (Join-Path $codexDest "AGENTS.md")
Backup-File (Join-Path $codexSource "SYSTEM.md") (Join-Path $codexDest "SYSTEM.md")
Write-Host "  Skills:" -ForegroundColor DarkCyan
Backup-Directory (Join-Path $codexSource "skills") ([IO.Path]::Combine($ProjectRoot, 'skills', 'codex')) -Exclude @(".system", "dist")
Write-Host "  Rules:" -ForegroundColor DarkCyan
Backup-Directory (Join-Path $codexSource "rules") ([IO.Path]::Combine($ProjectRoot, 'rules', 'codex'))
Backup-File ([IO.Path]::Combine($codexSource, 'rules', 'default.rules')) ([IO.Path]::Combine($ProjectRoot, 'rules', 'codex', 'default.rules'))
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
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        Write-Host "❌ 找不到 git，請先安裝並加入 PATH" -ForegroundColor Red
        exit 1
    }

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
        $Message = "Sync openAI CLI - $timestamp"
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

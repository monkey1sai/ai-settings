[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)]
  [string]$Name,

  [Parameter(Mandatory = $true)]
  [string]$Description,

  [string]$CodexHome
)

function Resolve-CodexHome([string]$explicit) {
  if ($explicit -and $explicit.Trim().Length -gt 0) { return $explicit }
  if ($env:CODEX_HOME -and $env:CODEX_HOME.Trim().Length -gt 0) { return $env:CODEX_HOME }
  if ($HOME -and $HOME.Trim().Length -gt 0) { return (Join-Path $HOME ".codex") }
  throw "Cannot resolve CODEX_HOME. Provide -CodexHome or set `$env:CODEX_HOME."
}

$ErrorActionPreference = "Stop"

if ($Name -notmatch "^[a-z0-9-]+$") {
  throw "Invalid -Name '$Name'. Must match ^[a-z0-9-]+$"
}
if (-not ($Description.Trim().StartsWith("Use when"))) {
  throw "Invalid -Description. Must start with 'Use when'."
}

$codexHomeResolved = Resolve-CodexHome $CodexHome
$skillsRoot = Join-Path $codexHomeResolved "skills"
$skillDir = Join-Path $skillsRoot $Name
$skillFile = Join-Path $skillDir "SKILL.md"

New-Item -ItemType Directory -Force -Path $skillDir | Out-Null

$content = @"
---
name: $Name
description: $Description
---

# $Name

## Overview
（用 1～2 句話說明這個 skill 的核心價值）

## When to use
- （列出 3～8 個症狀/觸發語句）

## Quick start
（列出最短的操作步驟或指令）
"@

Set-Content -Path $skillFile -Value $content -Encoding UTF8
Write-Host "Created: $skillFile"

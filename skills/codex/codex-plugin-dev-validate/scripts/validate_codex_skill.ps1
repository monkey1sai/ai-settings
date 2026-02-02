[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)]
  [string]$SkillName,

  [string]$CodexHome
)

function Resolve-CodexHome([string]$explicit) {
  if ($explicit -and $explicit.Trim().Length -gt 0) { return $explicit }
  if ($env:CODEX_HOME -and $env:CODEX_HOME.Trim().Length -gt 0) { return $env:CODEX_HOME }
  if ($HOME -and $HOME.Trim().Length -gt 0) { return (Join-Path $HOME ".codex") }
  throw "Cannot resolve CODEX_HOME. Provide -CodexHome or set `$env:CODEX_HOME."
}

$ErrorActionPreference = "Stop"

function Get-Frontmatter([string]$path) {
  $lines = Get-Content -Path $path -Encoding UTF8
  if ($lines.Count -lt 3 -or $lines[0].Trim() -ne "---") {
    throw "Missing YAML frontmatter (must start with '---'): $path"
  }
  $end = -1
  for ($i = 1; $i -lt $lines.Count; $i++) {
    if ($lines[$i].Trim() -eq "---") { $end = $i; break }
  }
  if ($end -lt 0) { throw "Unterminated YAML frontmatter (missing closing '---'): $path" }
  return ,@($lines[1..($end-1)])
}

function Parse-FrontmatterKV([string[]]$fmLines) {
  $map = @{}
  foreach ($line in $fmLines) {
    if ($line.Trim().Length -eq 0) { continue }
    if ($line -notmatch "^(?<k>[A-Za-z0-9_-]+):\s*(?<v>.*)$") {
      throw "Unsupported frontmatter line (expected 'key: value'): $line"
    }
    $k = $Matches["k"]
    $v = $Matches["v"].Trim()
    $map[$k] = $v
  }
  return $map
}

$codexHomeResolved = Resolve-CodexHome $CodexHome
$skillDir = Join-Path (Join-Path $codexHomeResolved "skills") $SkillName
$skillFile = Join-Path $skillDir "SKILL.md"

if (!(Test-Path $skillDir)) { throw "Skill directory not found: $skillDir" }
if (!(Test-Path $skillFile)) { throw "SKILL.md not found: $skillFile" }

$fm = Get-Frontmatter $skillFile
$kv = Parse-FrontmatterKV $fm

if (-not $kv.ContainsKey("name")) { throw "Missing 'name' in frontmatter: $skillFile" }
if (-not $kv.ContainsKey("description")) { throw "Missing 'description' in frontmatter: $skillFile" }

$name = $kv["name"]
$desc = $kv["description"]

if ($name -ne $SkillName) {
  throw "Frontmatter name '$name' must match folder name '$SkillName'."
}
if ($name -notmatch "^[a-z0-9-]+$") {
  throw "Invalid name '$name' (must match ^[a-z0-9-]+$)."
}
if (-not $desc.StartsWith("Use when")) {
  throw "Invalid description (must start with 'Use when'): $desc"
}

$fmLen = ("---`n" + ($fm -join "`n") + "`n---").Length
if ($fmLen -gt 1024) {
  throw "Frontmatter too long ($fmLen chars, max 1024)."
}

Write-Host "OK: $SkillName"
Write-Host " - SKILL.md: $skillFile"
Write-Host " - description: $desc"

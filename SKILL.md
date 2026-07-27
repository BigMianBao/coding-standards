# SKILL.md - AI Auto-Install Guide

> **You already cloned this repo to read this file.** The repo root is the directory containing this SKILL.md.
> Execute ALL steps below automatically. Do NOT ask the user to run scripts. Do NOT clone the repo again.
>
> NOTE: Variables do NOT persist between tool calls. Set `$repoDir` (PowerShell) or `$REPO_DIR` (Bash)
> to the repo root path at the start of each step that needs it.

## Prerequisites

Check `git` and `npm` are available. If missing, tell user to install first.
Detect OS: use PowerShell on Windows, Bash on macOS/Linux.

## Step 1: Deploy rule files

Copy `rules/*.md` and `MEMORY.md` from the repo to `~/.workbuddy/`.

### Windows (PowerShell)
```powershell
$repoDir  = "<REPO_ROOT>"  # path to the directory containing this SKILL.md
$rulesDir = "$env:USERPROFILE\.workbuddy\rules"
$memFile  = "$env:USERPROFILE\.workbuddy\MEMORY.md"
New-Item -ItemType Directory -Force -Path $rulesDir | Out-Null
Copy-Item "$repoDir\rules\*.md" $rulesDir -Force
if (Test-Path $memFile) {
  $old = [IO.File]::ReadAllText($memFile,[Text.Encoding]::UTF8)
  $new = [IO.File]::ReadAllText("$repoDir\MEMORY.md",[Text.Encoding]::UTF8)
  if ($old.Trim() -ne '' -and $old -ne $new) {
    Copy-Item $memFile "$memFile.bak" -Force
  }
}
Copy-Item "$repoDir\MEMORY.md" $memFile -Force
```

### macOS/Linux (Bash)
```bash
REPO_DIR="<REPO_ROOT>"  # path to the directory containing this SKILL.md
mkdir -p "$HOME/.workbuddy/rules"
cp "$REPO_DIR/rules/"*.md "$HOME/.workbuddy/rules/"
if [ -f "$HOME/.workbuddy/MEMORY.md" ] && ! diff -q "$HOME/.workbuddy/MEMORY.md" "$REPO_DIR/MEMORY.md" >/dev/null 2>&1; then
  cp "$HOME/.workbuddy/MEMORY.md" "$HOME/.workbuddy/MEMORY.md.bak"
fi
cp "$REPO_DIR/MEMORY.md" "$HOME/.workbuddy/MEMORY.md"
```

## Step 2: Deploy RULE.mdc (frontmatter safety net)

The repo template `templates/coding-standards.mdc` has YAML frontmatter (fixed upstream 2026-07-27).
This check is a safety net: if the file is missing `---` delimiters, auto-fix it.

### Windows (PowerShell)
```powershell
$repoDir  = "<REPO_ROOT>"  # path to the directory containing this SKILL.md
$cbRules  = "$env:USERPROFILE\.codebuddy\rules\coding-standards"
New-Item -ItemType Directory -Force -Path $cbRules | Out-Null
$mdc = [IO.File]::ReadAllText("$repoDir\templates\coding-standards.mdc", [Text.Encoding]::UTF8)
if ($mdc -notmatch '^---\r?\n') {
  $lines = $mdc -split "`r?`n"
  $enabledIdx = -1
  for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match '^enabled:\s*true') { $enabledIdx = $i; break }
  }
  if ($enabledIdx -ge 0) {
    $before = $lines[0..$enabledIdx]
    $after  = $lines[($enabledIdx + 1)..($lines.Count - 1)]
    $mdc = (@('---') + $before + @('---') + $after) -join "`r`n"
  }
}
$utf8NoBom = New-Object Text.UTF8Encoding $false
[IO.File]::WriteAllText("$cbRules\RULE.mdc", $mdc, $utf8NoBom)
```

### macOS/Linux (Bash)
```bash
REPO_DIR="<REPO_ROOT>"  # path to the directory containing this SKILL.md
CB_RULES="$HOME/.codebuddy/rules/coding-standards"
mkdir -p "$CB_RULES"
cp "$REPO_DIR/templates/coding-standards.mdc" "$CB_RULES/RULE.mdc"
if ! head -1 "$CB_RULES/RULE.mdc" | grep -q '^---'; then
  sed -i '1s/^/---\n/; /^enabled: true/a\\n---' "$CB_RULES/RULE.mdc"
fi
```

## Step 3: Deploy commands + skills

### Windows (PowerShell)
```powershell
$repoDir   = "<REPO_ROOT>"  # path to the directory containing this SKILL.md
$cbCmds    = "$env:USERPROFILE\.codebuddy\commands\opsx"
$cbSkills  = "$env:USERPROFILE\.codebuddy\skills"
New-Item -ItemType Directory -Force -Path $cbCmds, $cbSkills | Out-Null
Copy-Item "$repoDir\templates\codebuddy-commands\opsx\*.md" $cbCmds -Force
Copy-Item "$repoDir\templates\codebuddy-skills\*" $cbSkills -Recurse -Force
```

### macOS/Linux (Bash)
```bash
REPO_DIR="<REPO_ROOT>"  # path to the directory containing this SKILL.md
mkdir -p "$HOME/.codebuddy/commands/opsx" "$HOME/.codebuddy/skills"
cp "$REPO_DIR/templates/codebuddy-commands/opsx/"*.md "$HOME/.codebuddy/commands/opsx/"
cp -r "$REPO_DIR/templates/codebuddy-skills/"* "$HOME/.codebuddy/skills/"
```

## Step 4: Install openspec CLI

### Windows (PowerShell)
Use `--prefix "$env:APPDATA\npm"` (user-writable, already on PATH).
Do NOT use default npm global dir (may require admin).
```powershell
if (-not (Get-Command openspec -ErrorAction SilentlyContinue)) {
  $npmDir = "$env:APPDATA\npm"
  New-Item -ItemType Directory -Force -Path $npmDir | Out-Null
  npm install -g --prefix $npmDir "@fission-ai/openspec@latest"
}
```

### macOS/Linux (Bash)
```bash
if ! command -v openspec &>/dev/null; then
  npm install -g "@fission-ai/openspec@latest"
fi
```

## Step 5: Verify

Check ALL of these exist:
- `~/.workbuddy/rules/` has >= 20 .md files
- `~/.workbuddy/MEMORY.md` exists
- `~/.codebuddy/rules/coding-standards/RULE.mdc` exists AND first line is `---`
- `~/.codebuddy/commands/opsx/propose.md` exists
- `~/.codebuddy/skills/openspec-propose/SKILL.md` exists
- `openspec --version` works

Report pass/fail for each item.

## Optional: Save repo for future updates

To enable future `git pull` updates, copy this repo to `~/.workbuddy/coding-standards`.

### Windows (PowerShell)
```powershell
$dest = "$env:USERPROFILE\.workbuddy\coding-standards"
if (-not (Test-Path "$dest\.git")) {
  New-Item -ItemType Directory -Force -Path (Split-Path $dest) | Out-Null
  Copy-Item -Recurse -Force "<REPO_ROOT>" $dest
}
```

### macOS/Linux (Bash)
```bash
DEST="$HOME/.workbuddy/coding-standards"
if [ ! -d "$DEST/.git" ]; then
  mkdir -p "$(dirname "$DEST")"
  cp -r "<REPO_ROOT>" "$DEST"
fi
```

## Known Pitfalls (do NOT hit these)

1. **install.js is binary corrupted** - never execute it, never use `npx` install path
2. **setup.ps1 has PS5.1 UTF-8 encoding bug** - do NOT run setup.ps1 directly, execute steps manually via PowerShell tool
3. **coding-standards.mdc frontmatter** - FIXED UPSTREAM (commit 85cc11a); Step 2 keeps auto-fix as safety net
4. **openspec CLI EPERM on Windows default global dir** - Step 4 uses `--prefix` to bypass
5. **MEMORY.md path conflict** - `~/.workbuddy/MEMORY.md` is occupied by coding standards; never write personal memories there

## After install

Tell user: "Done. Start a new CodeBuddy session to activate rules."

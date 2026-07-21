# ============================================================
# 全局规范部署脚本 (Windows PowerShell) - 每台电脑跑一次
# 用法：.\setup.ps1
# ============================================================
$ErrorActionPreference = "Stop"

$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$HOME_DIR = $env:USERPROFILE

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  企业编程规范 - 全局部署 (Windows)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 检查前提条件
Write-Host "[前提检查] 检查依赖..."
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "  错误：未安装 Git，请先安装 https://git-scm.com" -ForegroundColor Red
    exit 1
}
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "  错误：未安装 Node.js，请先安装 https://nodejs.org (需要 >= 20.19.0)" -ForegroundColor Red
    exit 1
}
Write-Host "  -> Git: $(git --version)"
Write-Host "  -> Node.js: $(node --version)"
Write-Host ""

# 1. 部署全局规则到 ~/.workbuddy/
Write-Host "[1/5] 部署全局规则到 $HOME_DIR\.workbuddy\..."
$workbuddyRules = Join-Path $HOME_DIR ".workbuddy\rules"
New-Item -ItemType Directory -Force -Path $workbuddyRules | Out-Null
Copy-Item -Path "$SCRIPT_DIR\rules\*.md" -Destination $workbuddyRules -Force
Copy-Item -Path "$SCRIPT_DIR\MEMORY.md" -Destination "$HOME_DIR\.workbuddy\MEMORY.md" -Force
$ruleCount = (Get-ChildItem $workbuddyRules -Filter "*.md").Count
Write-Host "  -> $ruleCount 个规则文件已部署"
Write-Host "  -> $HOME_DIR\.workbuddy\MEMORY.md 已更新"
Write-Host ""

# 2. 部署 CodeBuddy 用户规则（全局，所有项目生效）
Write-Host "[2/5] 部署 CodeBuddy 用户规则..."
$codebuddyRules = Join-Path $HOME_DIR ".codebuddy\rules\coding-standards"
New-Item -ItemType Directory -Force -Path $codebuddyRules | Out-Null
Copy-Item -Path "$SCRIPT_DIR\templates\coding-standards.mdc" -Destination "$codebuddyRules\RULE.mdc" -Force
Write-Host "  -> $codebuddyRules\RULE.mdc 已部署"
Write-Host "  -> 规则类型：alwaysApply（每次会话自动加载）"
Write-Host ""

# 3. 部署 OpenSpec 斜杠命令和技能到 CodeBuddy 用户级
Write-Host "[3/5] 部署 OpenSpec 命令和技能..."
$commandsDir = Join-Path $HOME_DIR ".codebuddy\commands\opsx"
New-Item -ItemType Directory -Force -Path $commandsDir | Out-Null
Copy-Item -Path "$SCRIPT_DIR\templates\codebuddy-commands\opsx\*.md" -Destination $commandsDir -Force

$skillsDir = Join-Path $HOME_DIR ".codebuddy\skills"
New-Item -ItemType Directory -Force -Path $skillsDir | Out-Null
Get-ChildItem "$SCRIPT_DIR\templates\codebuddy-skills" -Directory | ForEach-Object {
    $destSkill = Join-Path $skillsDir $_.Name
    New-Item -ItemType Directory -Force -Path $destSkill | Out-Null
    Copy-Item -Path "$($_.FullName)\*" -Destination $destSkill -Force -Recurse
}

$cmdCount = (Get-ChildItem $commandsDir -Filter "*.md").Count
$skillCount = (Get-ChildItem $skillsDir -Directory).Count
Write-Host "  -> $cmdCount 个斜杠命令已部署到 $commandsDir"
Write-Host "  -> $skillCount 个技能文件已部署到 $skillsDir"
Write-Host "  -> 所有项目可用 /opsx:propose、/opsx:apply、/opsx:archive 等命令"
Write-Host ""

# 4. 确保 OpenSpec CLI 已安装
Write-Host "[4/5] 检查 OpenSpec CLI..."
if (Get-Command openspec -ErrorAction SilentlyContinue) {
    Write-Host "  -> OpenSpec CLI 已安装：$(openspec --version)"
} else {
    Write-Host "  -> 安装 OpenSpec CLI..."
    npm install -g "@fission-ai/openspec@latest"
    Write-Host "  -> OpenSpec CLI 安装完成：$(openspec --version)"
}
Write-Host ""

# 5. 完成
Write-Host "[5/5] 部署完成！" -ForegroundColor Green
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  全局规范已就绪" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "后续操作："
Write-Host "  1. 新项目初始化：.\init-project.ps1 'D:\path\to\project'"
Write-Host "  2. 在 CodeBuddy 中新建会话，规范自动生效"
Write-Host "  3. 验证：新会话中问 AI '当前应用了哪些规则？'"
Write-Host ""
Write-Host "规范更新流程："
Write-Host "  1. git pull 拉取最新规范"
Write-Host "  2. 重新运行 .\setup.ps1"
Write-Host "  3. CodeBuddy 新建会话生效"
Write-Host ""

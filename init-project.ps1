# ============================================================
# 项目初始化脚本 (Windows PowerShell) - 每个新项目跑一次
# 用法：.\init-project.ps1 "D:\path\to\project"
# ============================================================
$ErrorActionPreference = "Stop"

$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path

if ($args.Count -eq 0) {
    Write-Host "用法：.\init-project.ps1 'D:\path\to\project'" -ForegroundColor Yellow
    exit 1
}

$PROJECT_DIR = (Resolve-Path $args[0] -ErrorAction SilentlyContinue)?.Path
if (-not $PROJECT_DIR) {
    Write-Host "错误：项目目录不存在 $($args[0])" -ForegroundColor Red
    exit 1
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  项目规范初始化 (Windows)" -ForegroundColor Cyan
Write-Host "  项目路径：$PROJECT_DIR" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 1. 部署 CODEBUDDY.md
Write-Host "[1/3] 部署 CODEBUDDY.md..."
$codebuddyMd = Join-Path $PROJECT_DIR "CODEBUDDY.md"
if (Test-Path $codebuddyMd) {
    Write-Host "  -> CODEBUDDY.md 已存在，跳过（如需更新请手动删除后重跑）"
} else {
    Copy-Item -Path "$SCRIPT_DIR\templates\CODEBUDDY.md" -Destination $codebuddyMd
    Write-Host "  -> CODEBUDDY.md 已部署"
}
Write-Host ""

# 2. 部署 openspec/ 配置目录（规范文件 + config.yaml）
Write-Host "[2/3] 部署 OpenSpec 配置..."
$openspecRules = Join-Path $PROJECT_DIR "openspec\rules"
New-Item -ItemType Directory -Force -Path $openspecRules | Out-Null
Copy-Item -Path "$SCRIPT_DIR\rules\*.md" -Destination $openspecRules -Force
$ruleCount = (Get-ChildItem $openspecRules -Filter "*.md").Count
Write-Host "  -> $ruleCount 个规则文件已部署到 openspec\rules\"

$openspecConfig = Join-Path $PROJECT_DIR "openspec\config.yaml"
if (Test-Path $openspecConfig) {
    Write-Host "  -> config.yaml 已存在，备份后更新..."
    Copy-Item -Path $openspecConfig -Destination "$openspecConfig.bak" -Force
}
Copy-Item -Path "$SCRIPT_DIR\templates\openspec-config.yaml" -Destination $openspecConfig -Force
Write-Host "  -> openspec\config.yaml 已部署"
Write-Host ""

# 3. 完成
Write-Host "[3/3] 项目初始化完成！" -ForegroundColor Green
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  项目初始化完成！" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "后续操作："
Write-Host "  1. 用 CodeBuddy 打开项目：$PROJECT_DIR"
Write-Host "  2. 新建对话会话（规范在会话启动时加载）"
Write-Host "  3. 验证：问 AI '当前应用了哪些规则？'"
Write-Host "  4. 斜杠命令已全局部署，直接可用：/opsx:propose、/opsx:apply、/opsx:archive"
Write-Host ""
Write-Host "提示：将 CODEBUDDY.md 和 openspec\ 目录提交到项目 Git 仓库，"
Write-Host "      团队其他成员 clone 后自动获得规范，无需额外配置。"
Write-Host ""

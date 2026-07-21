# ============================================================
# 一键安装脚本 - Windows PowerShell
# 用法：irm https://raw.githubusercontent.com/BigMianBao/coding-standards/main/install.ps1 | iex
# ============================================================
$ErrorActionPreference = "Stop"

$REPO_URL = "https://github.com/BigMianBao/coding-standards.git"
$INSTALL_DIR = Join-Path $env:USERPROFILE ".workbuddy\coding-standards"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  企业编程规范 - 一键安装 (Windows)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# ---------- 前提检查 ----------
Write-Host "[1/5] 检查前提条件..."

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "  ✗ 未安装 Git，请安装: https://git-scm.com" -ForegroundColor Red
    exit 1
}
Write-Host "  ✓ Git $((git --version) -replace 'git version ','')"

if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "  ✗ 未安装 Node.js（需要 >= 20.19.0）" -ForegroundColor Red
    Write-Host "    请安装: https://nodejs.org" -ForegroundColor Red
    exit 1
}
$nodeVersion = (node --version) -replace 'v',''
$nodeMajor = [int]($nodeVersion -split '\.')[0]
if ($nodeMajor -lt 20) {
    Write-Host "  ✗ Node.js 版本过低: $nodeVersion（需要 >= 20.19.0）" -ForegroundColor Red
    exit 1
}
Write-Host "  ✓ Node.js $nodeVersion"

Write-Host ""

# ---------- 克隆 / 更新仓库 ----------
Write-Host "[2/5] 获取规范仓库..."
if (Test-Path "$INSTALL_DIR\.git") {
    Write-Host "  -> 仓库已存在，拉取最新更新..."
    Push-Location $INSTALL_DIR
    git pull --ff-only origin main 2>$null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  -> 本地有修改，强制同步远程..."
        git fetch origin
        git reset --hard origin/main
    }
    Pop-Location
} else {
    Write-Host "  -> 克隆仓库到 $INSTALL_DIR ..."
    if (Test-Path $INSTALL_DIR) { Remove-Item -Recurse -Force $INSTALL_DIR }
    git clone --depth 1 $REPO_URL $INSTALL_DIR
}
Write-Host "  ✓ 仓库就绪"
Write-Host ""

# ---------- 执行部署 ----------
Write-Host "[3/5] 部署全局规则文件..."
Push-Location $INSTALL_DIR

# 直接执行部署逻辑（复用 setup.ps1）
.\setup.ps1

Pop-Location

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  一键安装完成！" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

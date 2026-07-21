# ============================================================
# 全白机引导器（Windows）
# 自动安装 Git + Node.js（若缺失），再部署企业编程规范
# 用法：
#   irm https://raw.githubusercontent.com/BigMianBao/coding-standards/main/bootstrap.ps1 | iex
# 项目初始化：
#   irm .../bootstrap.ps1 | iex -- -Init "C:\path\to\project"
# ============================================================
$ErrorActionPreference = "Stop"

$REPO = "https://github.com/BigMianBao/coding-standards.git"
$DIR  = "$env:USERPROFILE\.workbuddy\coding-standards"

function Refresh-Path {
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" +
              [System.Environment]::GetEnvironmentVariable("Path","User")
}

Write-Host "========================================"
Write-Host "  企业编程规范 - 全白机引导器 (Windows)"
Write-Host "========================================"

# ---------- [1/3] 确保 Git ----------
Write-Host "[1/3] 检查 Git..."
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
  Write-Host "  -> 安装 Git (winget)..."
  winget install -e --id Git.Git --accept-package-agreements --accept-source-agreements
  Refresh-Path
  if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "  x Git 自动安装失败，请手动安装: https://git-scm.com" -ForegroundColor Red
    exit 1
  }
} else {
  Write-Host "  -> Git 已安装: $(git --version)"
}

# ---------- [2/3] 确保 Node.js >= 20 ----------
Write-Host "[2/3] 检查 Node.js..."
$needNode = $true
if (Get-Command node -ErrorAction SilentlyContinue) {
  $v = (node -v).TrimStart('v').Split('.')[0]
  if ([int]$v -ge 20) { $needNode = $false }
}
if ($needNode) {
  Write-Host "  -> 安装 Node.js (winget)..."
  winget install -e --id OpenJS.NodeJS.LTS --accept-package-agreements --accept-source-agreements
  Refresh-Path
  if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "  x Node.js 自动安装失败，请手动安装: https://nodejs.org" -ForegroundColor Red
    exit 1
  }
} else {
  Write-Host "  -> Node.js: $(node --version)"
}

# ---------- [3/3] 克隆并部署 ----------
Write-Host "[3/3] 获取并部署规范..."
if (Test-Path "$DIR\.git") {
  git -C $DIR pull --ff-only 2>$null
} else {
  Remove-Item -Recurse -Force $DIR -ErrorAction SilentlyContinue
  git clone --depth 1 $REPO $DIR
}
& node "$DIR\install.js" @args

Write-Host "引导完成。"

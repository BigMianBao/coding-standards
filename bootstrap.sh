#!/bin/bash
# ============================================================
# 全白机引导器（macOS / Linux）
# 自动安装 Git + Node.js（若缺失），再部署企业编程规范
# 用法：
#   curl -fsSL https://raw.githubusercontent.com/BigMianBao/coding-standards/main/bootstrap.sh | bash
# 项目初始化：
#   curl -fsSL .../bootstrap.sh | bash -s -- --init /path/to/project
# ============================================================
set -e

REPO="https://github.com/BigMianBao/coding-standards.git"
DIR="$HOME/.workbuddy/coding-standards"

echo "========================================"
echo "  企业编程规范 - 全白机引导器"
echo "  系统: $(uname -s)"
echo "========================================"

# ---------- [1/3] 确保 Git ----------
echo "[1/3] 检查 Git..."
if command -v git &>/dev/null; then
  echo "  -> Git 已安装: $(git --version | head -1)"
else
  echo "  -> 未安装 Git，正在自动安装..."
  if command -v brew &>/dev/null; then
    brew install git
  elif [[ "$(uname)" == "Linux" ]]; then
    sudo apt-get update -y && sudo apt-get install -y git
  else
    # macOS 无 Homebrew：安装 Xcode Command Line Tools（含 Git）
    xcode-select --install || true
  fi
  if ! command -v git &>/dev/null; then
    echo "  ✗ Git 自动安装失败，请手动安装后重试: https://git-scm.com" >&2
    exit 1
  fi
fi

# ---------- [2/3] 确保 Node.js >= 20 ----------
echo "[2/3] 检查 Node.js..."
NEED_NODE=0
if ! command -v node &>/dev/null; then
  NEED_NODE=1
else
  NODE_MAJOR=$(node -v | sed 's/v//' | cut -d. -f1)
  if [ "$NODE_MAJOR" -lt 20 ]; then NEED_NODE=1; fi
fi
if [ "$NEED_NODE" -eq 1 ]; then
  echo "  -> 未安装或版本过低 Node.js，正在自动安装..."
  if command -v brew &>/dev/null; then
    brew install node
  elif [[ "$(uname)" == "Linux" ]]; then
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt-get install -y nodejs
  else
    # macOS 无 Homebrew：下载官方 pkg 安装
    curl -fsSL https://nodejs.org/dist/v20.19.0/node-v20.19.0.pkg -o /tmp/node-install.pkg
    sudo installer -pkg /tmp/node-install.pkg -target /
  fi
  if ! command -v node &>/dev/null; then
    echo "  ✗ Node.js 自动安装失败，请手动安装后重试: https://nodejs.org" >&2
    exit 1
  fi
fi
echo "  -> Node.js: $(node --version)"

# ---------- [3/3] 克隆并部署 ----------
echo "[3/3] 获取并部署规范..."
if [ -d "$DIR/.git" ]; then
  git -C "$DIR" pull --ff-only 2>/dev/null || git -C "$DIR" pull || true
else
  rm -rf "$DIR"
  git clone --depth 1 "$REPO" "$DIR"
fi
node "$DIR/install.js" "$@"

echo ""
echo "引导完成。"

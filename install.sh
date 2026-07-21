#!/bin/bash
# ============================================================
# 一键安装脚本 - macOS / Linux
# 用法：curl -fsSL https://raw.githubusercontent.com/BigMianBao/coding-standards/main/install.sh | bash
# ============================================================
set -e

REPO_URL="https://github.com/BigMianBao/coding-standards.git"
INSTALL_DIR="$HOME/.workbuddy/coding-standards"

echo ""
echo "========================================"
echo "  企业编程规范 - 一键安装"
echo "========================================"
echo ""

# ---------- 前提检查 ----------
echo "[1/5] 检查前提条件..."

if ! command -v git &> /dev/null; then
    echo "  ✗ 未安装 Git"
    echo "    macOS:  brew install git"
    echo "    Ubuntu: sudo apt install git"
    exit 1
fi
echo "  ✓ Git $(git --version | awk '{print $3}')"

if ! command -v node &> /dev/null; then
    echo "  ✗ 未安装 Node.js（需要 >= 20.19.0）"
    echo "    macOS:  brew install node"
    echo "    Ubuntu: 参考 https://nodejs.org"
    exit 1
fi
NODE_VERSION=$(node --version | sed 's/v//')
NODE_MAJOR=$(echo "$NODE_VERSION" | cut -d. -f1)
if [ "$NODE_MAJOR" -lt 20 ]; then
    echo "  ✗ Node.js 版本过低: $NODE_VERSION（需要 >= 20.19.0）"
    exit 1
fi
echo "  ✓ Node.js $NODE_VERSION"

echo ""

# ---------- 克隆 / 更新仓库 ----------
echo "[2/5] 获取规范仓库..."
if [ -d "$INSTALL_DIR/.git" ]; then
    echo "  -> 仓库已存在，拉取最新更新..."
    cd "$INSTALL_DIR"
    git pull --ff-only origin main 2>/dev/null || {
        echo "  -> 本地有修改，强制同步远程..."
        git fetch origin
        git reset --hard origin/main
    }
else
    echo "  -> 克隆仓库到 $INSTALL_DIR ..."
    rm -rf "$INSTALL_DIR"
    git clone --depth 1 "$REPO_URL" "$INSTALL_DIR"
fi
echo "  ✓ 仓库就绪"
echo ""

# ---------- 执行部署 ----------
echo "[3/5] 部署全局规则文件..."
cd "$INSTALL_DIR"
chmod +x setup.sh init-project.sh

# 直接执行部署逻辑（复用 setup.sh）
./setup.sh

echo ""
echo "========================================"
echo "  一键安装完成！"
echo "========================================"

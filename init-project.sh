#!/bin/bash
# ============================================================
# 项目初始化脚本 - 每个新项目跑一次
# 用法：./init-project.sh /path/to/project
# ============================================================
set -e

PROJECT_DIR="${1:-.}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 解析为绝对路径
PROJECT_DIR="$(cd "$PROJECT_DIR" 2>/dev/null && pwd)" || {
    echo "错误：项目目录不存在 $1"
    exit 1
}

echo "========================================"
echo "  项目规范初始化"
echo "  项目路径：$PROJECT_DIR"
echo "========================================"
echo ""

# 1. 部署 CODEBUDDY.md
echo "[1/4] 部署 CODEBUDDY.md..."
if [ -f "$PROJECT_DIR/CODEBUDDY.md" ]; then
    echo "  -> CODEBUDDY.md 已存在，跳过（如需更新请手动删除后重跑）"
else
    cp "$SCRIPT_DIR/templates/CODEBUDDY.md" "$PROJECT_DIR/CODEBUDDY.md"
    echo "  -> CODEBUDDY.md 已部署"
fi
echo ""

# 2. 初始化 OpenSpec（如果还没初始化）
echo "[2/4] 检查 OpenSpec..."
if [ -d "$PROJECT_DIR/openspec" ]; then
    echo "  -> openspec/ 目录已存在，跳过初始化"
else
    echo "  -> 初始化 OpenSpec（CodeBuddy 模式）..."
    openspec init --tools codebuddy "$PROJECT_DIR"
    echo "  -> OpenSpec 初始化完成"
fi
echo ""

# 3. 部署规范文件到 openspec/rules/
echo "[3/4] 部署规范文件到 openspec/rules/..."
mkdir -p "$PROJECT_DIR/openspec/rules"
cp "$SCRIPT_DIR/rules/"*.md "$PROJECT_DIR/openspec/rules/"
echo "  -> $(ls "$PROJECT_DIR/openspec/rules/" | wc -l | tr -d ' ') 个规则文件已部署"
echo ""

# 4. 更新 openspec/config.yaml
echo "[4/4] 部署 OpenSpec 配置..."
if [ -f "$PROJECT_DIR/openspec/config.yaml" ]; then
    echo "  -> config.yaml 已存在，备份后更新..."
    cp "$PROJECT_DIR/openspec/config.yaml" "$PROJECT_DIR/openspec/config.yaml.bak"
fi
cp "$SCRIPT_DIR/templates/openspec-config.yaml" "$PROJECT_DIR/openspec/config.yaml"
echo "  -> openspec/config.yaml 已部署"
echo ""

echo "========================================"
echo "  项目初始化完成！"
echo "========================================"
echo ""
echo "后续操作："
echo "  1. 用 CodeBuddy 打开项目：$PROJECT_DIR"
echo "  2. 新建对话会话（规范在会话启动时加载）"
echo "  3. 验证：问 AI '当前应用了哪些规则？'"
echo "  4. 可用斜杠命令：/opsx:propose、/opsx:apply、/opsx:archive"
echo ""
echo "提示：将 CODEBUDDY.md 和 openspec/ 目录提交到项目 Git 仓库，"
echo "      团队其他成员 clone 后自动获得规范，无需额外配置。"
echo ""

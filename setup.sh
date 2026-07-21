#!/bin/bash
# ============================================================
# 全局规范部署脚本 - 每台电脑跑一次
# 用法：./setup.sh
# ============================================================
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "========================================"
echo "  企业编程规范 - 全局部署"
echo "========================================"
echo ""

# 1. 部署全局规则到 ~/.workbuddy/
echo "[1/4] 部署全局规则到 ~/.workbuddy/..."
mkdir -p ~/.workbuddy/rules
cp "$SCRIPT_DIR/rules/"*.md ~/.workbuddy/rules/
cp "$SCRIPT_DIR/MEMORY.md" ~/.workbuddy/MEMORY.md
echo "  -> $(ls ~/.workbuddy/rules/ | wc -l | tr -d ' ') 个规则文件已部署"
echo "  -> ~/.workbuddy/MEMORY.md 已更新"
echo ""

# 2. 部署 CodeBuddy 用户规则（全局，所有项目生效）
echo "[2/4] 部署 CodeBuddy 用户规则..."
mkdir -p ~/.codebuddy/rules/coding-standards
cp "$SCRIPT_DIR/templates/coding-standards.mdc" ~/.codebuddy/rules/coding-standards/RULE.mdc
echo "  -> ~/.codebuddy/rules/coding-standards/RULE.mdc 已部署"
echo "  -> 规则类型：alwaysApply（每次会话自动加载）"
echo ""

# 3. 确保 OpenSpec CLI 已安装
echo "[3/4] 检查 OpenSpec CLI..."
if command -v openspec &> /dev/null; then
    echo "  -> OpenSpec CLI 已安装：$(openspec --version)"
else
    echo "  -> 安装 OpenSpec CLI..."
    npm install -g @fission-ai/openspec@latest
    echo "  -> OpenSpec CLI 安装完成：$(openspec --version)"
fi
echo ""

# 4. 完成
echo "[4/4] 部署完成！"
echo ""
echo "========================================"
echo "  全局规范已就绪"
echo "========================================"
echo ""
echo "后续操作："
echo "  1. 新项目初始化：./init-project.sh /path/to/project"
echo "  2. 在 CodeBuddy 中新建会话，规范自动生效"
echo "  3. 验证：新会话中问 AI '当前应用了哪些规则？'"
echo ""
echo "规范更新流程："
echo "  1. git pull 拉取最新规范"
echo "  2. 重新运行 ./setup.sh"
echo "  3. CodeBuddy 新建会话生效"
echo ""

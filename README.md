# coding-standards

企业编程规范统一管理仓库。用于在多台电脑、多个项目间同步 CodeBuddy 编程规范。

支持 **macOS** / **Windows** / **Linux**。

---

## 怎么装

按机器情况选一种：

### A. 全新机器（没装 Node.js / Git）→ 全白机引导器

引导器会**自动安装缺失的 Git + Node.js**，再部署规范。一条命令搞定，无需手动装任何东西。

**macOS / Linux：**
```bash
curl -fsSL https://raw.githubusercontent.com/BigMianBao/coding-standards/main/bootstrap.sh | bash
```

**Windows (PowerShell)：**
```powershell
irm https://raw.githubusercontent.com/BigMianBao/coding-standards/main/bootstrap.ps1 | iex
```

> - 入口命令因系统不同（curl vs irm），这是物理限制无法消除；但交给 AI 工具"一句话执行"时用户无感（见下方）。
> - Windows 用 `winget` 装 Git + Node；macOS 无 Homebrew 时走 Xcode CLT / 官方 pkg（可能弹窗输密码）；Linux 用 apt。

### B. 已装 Node.js 的机器 → npx 一条命令

```
npx github:BigMianBao/coding-standards
```

**macOS、Windows、Linux 完全一样，就这一条。** 自动完成：检查依赖 → 克隆仓库 → 部署全局规则 → 配置 OpenSpec 命令 → 安装 CLI。

### 给 AI 工具用的一句话

在 CodeBuddy / WorkBuddy 等 AI 工具里直接说：

> **帮我执行：把企业编程规范装到这台机器上（支持全新机器自动装依赖）**

AI 会检测当前系统，自动选 A 或 B 的对应命令执行。对用户来说就是"一句话"。

---

## 新项目初始化

装完规范后，给新项目加规范也只需一条命令：

```
# 已装 Node 的机器
npx github:BigMianBao/coding-standards --init /path/to/your/project

# 全白机引导器（macOS / Linux）
curl -fsSL .../bootstrap.sh | bash -s -- --init /path/to/project

# Windows
irm .../bootstrap.ps1 | iex -- -Init "C:\path\to\project"
```

会自动部署 `CODEBUDDY.md` + `openspec/` 配置目录到项目中。

## 规范更新

重新跑同一条安装命令即可（会自动检测已有仓库并更新）。跑完后在 CodeBuddy **新建会话**生效。

---

## 前提条件对照

| 方案 | Node.js | Git | 入口命令区分系统 |
|------|---------|-----|------------------|
| A. 全白机引导器 | 自动装 | 自动装 | 是（curl / irm） |
| B. npx | 需已装 | 需已装 | 否（统一 npx） |

> 两者最终部署结果完全一致：全局规则 + CodeBuddy 用户规则 + OpenSpec 命令/技能 + CLI。

## 仓库结构

```
coding-standards/
├── package.json                        # npx 入口配置
├── install.js                          # 跨平台安装脚本（Node.js，npx 调用）
├── install.sh / install.ps1            # 备用：shell / PowerShell 安装脚本
├── bootstrap.sh / bootstrap.ps1        # 全白机引导器（自动装 Git+Node 再装规范）
├── rules/                              # 20 个详细规范文件（01 ~ 20）
├── templates/
│   ├── CODEBUDDY.md                    # 项目指令模板（放项目根目录）
│   ├── openspec-config.yaml            # OpenSpec 配置模板
│   ├── coding-standards.mdc            # CodeBuddy 用户规则模板（全局）
│   ├── codebuddy-commands/opsx/        # OpenSpec 斜杠命令模板（6 个）
│   └── codebuddy-skills/               # OpenSpec 技能模板（6 个）
├── MEMORY.md                           # 全局核心规则
├── setup.sh / setup.ps1               # 全局部署脚本（install 内部调用）
├── init-project.sh / init-project.ps1  # 项目初始化脚本
└── README.md
```

## 安装脚本做了什么

| 步骤 | 操作 |
|------|------|
| 引导器 | 检查并自动安装缺失的 Git + Node.js（仅方案 A） |
| [1/6] | 检查 Git + Node.js |
| [2/6] | 克隆/更新规范仓库 |
| [3/6] | 20 个规范文件 + MEMORY.md → `~/.workbuddy/` |
| [4/6] | CodeBuddy 用户规则（alwaysApply）→ `~/.codebuddy/rules/` |
| [5/6] | 6 个斜杠命令 + 6 个技能 → `~/.codebuddy/` |
| [6/6] | OpenSpec CLI 安装检查 |

## 两层部署机制

| 层级 | 位置 | 作用 | 何时部署 |
|------|------|------|----------|
| 全局 | `~/.workbuddy/` + `~/.codebuddy/` | 所有项目通用的核心铁律 + OpenSpec 命令 | 每台电脑一次 |
| 项目 | 项目根目录 `CODEBUDDY.md` + `openspec/` | 项目特定的完整规范 | 每个新项目一次（init-project） |

## 备用安装方式

如果 `npx` / 引导器都不可用，也可以手动下载仓库后用平台脚本：

**macOS / Linux:**
```bash
git clone https://github.com/BigMianBao/coding-standards.git ~/.workbuddy/coding-standards
cd ~/.workbuddy/coding-standards && chmod +x setup.sh && ./setup.sh
```

**Windows (PowerShell):**
```powershell
git clone https://github.com/BigMianBao/coding-standards.git "$env:USERPROFILE\.workbuddy\coding-standards"
cd "$env:USERPROFILE\.workbuddy\coding-standards"; .\setup.ps1
```

## 规范来源

- GitHub: https://github.com/BigMianBao/coding-standards
- 本仓库在此基础上有增量优化（架构分层豁免判定、事件可靠性约束等）

## 注意事项

- CodeBuddy 规则在会话启动时加载，修改后需**新建会话**生效
- `CODEBUDDY.md` 和 `openspec/` 目录应提交到项目 Git 仓库，团队共享
- `~/.codebuddy/` 为用户级配置，不被版本控制跟踪，通过脚本部署

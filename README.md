# coding-standards

企业编程规范统一管理仓库。用于在多台电脑、多个项目间同步 CodeBuddy 编程规范。

支持 **macOS** / **Windows** / **Linux**，一条命令通吃。

---

## 一键安装

```
npx github:BigMianBao/coding-standards
```

**macOS、Windows、Linux 完全一样，就这一条。**

自动完成：检查依赖 → 克隆仓库 → 部署全局规则 → 配置 OpenSpec 命令 → 安装 CLI。

跑完后在 CodeBuddy 新建会话，规范即生效。

---

## 给 AI 工具用的一句话

在 CodeBuddy / WorkBuddy 等 AI 工具里直接说：

> **帮我执行：`npx github:BigMianBao/coding-standards`**

AI 会在终端执行，完成全部配置。

---

## 前提条件

| 依赖 | 说明 |
|------|------|
| Git | 克隆仓库。macOS: `brew install git` / Windows: [下载](https://git-scm.com) |
| Node.js >= 20.19.0 | npx 运行 + OpenSpec CLI。macOS: `brew install node` / Windows: [下载](https://nodejs.org) |

> 安装脚本会自动检查，缺失时提示安装方式并退出。

## 仓库结构

```
coding-standards/
├── package.json                        # npx 入口配置
├── install.js                          # 跨平台安装脚本（Node.js，npx 调用）
├── install.sh / install.ps1            # 备用：shell / PowerShell 安装脚本
├── rules/                              # 20 个详细规范文件（01 ~ 20）
├── templates/
│   ├── CODEBUDDY.md                    # 项目指令模板（放项目根目录）
│   ├── openspec-config.yaml            # OpenSpec 配置模板
│   ├── coding-standards.mdc            # CodeBuddy 用户规则模板（全局）
│   ├── codebuddy-commands/opsx/        # OpenSpec 斜杠命令模板（6 个）
│   └── codebuddy-skills/              # OpenSpec 技能模板（6 个）
├── MEMORY.md                           # 全局核心规则
├── setup.sh / setup.ps1               # 全局部署脚本（install 内部调用）
├── init-project.sh / init-project.ps1  # 项目初始化脚本
└── README.md
```

## 新项目初始化

一键安装后，给新项目加规范也只需一条命令：

```
npx github:BigMianBao/coding-standards --init /path/to/your/project
```

> macOS 和 Windows 路径格式不同，但命令结构一样。

会自动部署 `CODEBUDDY.md` + `openspec/` 配置目录到项目中。

## 规范更新

规范有更新后，重新跑同一条命令即可：

```
npx github:BigMianBao/coding-standards
```

> 会自动检测已有仓库并更新。跑完后在 CodeBuddy **新建会话**生效。

## 安装脚本做了什么

| 步骤 | 操作 |
|------|------|
| [1/6] | 检查 Git + Node.js |
| [2/6] | 克隆/更新规范仓库 |
| [3/6] | 20 个规范文件 + MEMORY.md → `~/.workbuddy/` |
| [4/6] | CodeBuddy 用户规则（alwaysApply）→ `~/.codebuddy/rules/` |
| [5/6] | 6 个斜杠命令 + 6 个技能 → `~/.codebuddy/` |
| [6/6] | OpenSpec CLI 安装检查 |

## 两层部署机制

| 层级 | 位置 | 作用 | 何时部署 |
|------|------|------|----------|
| 全局 | `~/.workbuddy/` + `~/.codebuddy/` | 所有项目通用的核心铁律 + OpenSpec 命令 | 每台电脑一次（npx 一键安装） |
| 项目 | 项目根目录 `CODEBUDDY.md` + `openspec/` | 项目特定的完整规范 | 每个新项目一次（init-project） |

## 备用安装方式

如果 `npx` 不可用，也可以用平台脚本：

**macOS / Linux:**
```bash
curl -fsSL https://raw.githubusercontent.com/BigMianBao/coding-standards/main/install.sh | bash
```

**Windows (PowerShell):**
```powershell
irm https://raw.githubusercontent.com/BigMianBao/coding-standards/main/install.ps1 | iex
```

## 规范来源

- GitHub: https://github.com/BigMianBao/coding-standards
- 本仓库在此基础上有增量优化（架构分层豁免判定、事件可靠性约束等）

## 注意事项

- CodeBuddy 规则在会话启动时加载，修改后需**新建会话**生效
- `CODEBUDDY.md` 和 `openspec/` 目录应提交到项目 Git 仓库，团队共享
- `~/.codebuddy/` 为用户级配置，不被版本控制跟踪，通过脚本部署

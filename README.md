# coding-standards

企业编程规范统一管理仓库。用于在多台电脑、多个项目间同步 CodeBuddy 编程规范。

支持 **macOS** 和 **Windows** 双平台。

---

## 一键安装（推荐）

### macOS / Linux

```bash
curl -fsSL https://raw.githubusercontent.com/BigMianBao/coding-standards/main/install.sh | bash
```

### Windows (PowerShell)

```powershell
irm https://raw.githubusercontent.com/BigMianBao/coding-standards/main/install.ps1 | iex
```

> Windows 如果提示执行策略限制，先运行：
> `Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned`

**就这一条命令。** 脚本会自动完成：检查依赖 → 克隆仓库 → 部署全局规则 → 安装 OpenSpec CLI → 配置斜杠命令。

跑完后在 CodeBuddy 新建会话，规范即生效。

---

## 前提条件

| 依赖 | macOS | Windows | 说明 |
|------|-------|---------|------|
| Git | `brew install git` | [下载安装](https://git-scm.com) | 克隆仓库 |
| Node.js >= 20.19.0 | `brew install node` | [下载安装](https://nodejs.org) | OpenSpec CLI 依赖 |

> 一键安装脚本会自动检查这两项，缺失时会提示安装方式并退出。

## 仓库结构

```
coding-standards/
├── install.sh / install.ps1            # 一键安装脚本（curl | bash / irm | iex）
├── rules/                              # 20 个详细规范文件（01 ~ 20）
├── templates/
│   ├── CODEBUDDY.md                    # 项目指令模板（放项目根目录）
│   ├── openspec-config.yaml            # OpenSpec 配置模板
│   ├── coding-standards.mdc            # CodeBuddy 用户规则模板（全局）
│   ├── codebuddy-commands/opsx/        # OpenSpec 斜杠命令模板（6 个）
│   └── codebuddy-skills/              # OpenSpec 技能模板（6 个）
├── MEMORY.md                           # 全局核心规则
├── setup.sh / setup.ps1               # 全局部署脚本（一键安装内部调用）
├── init-project.sh / init-project.ps1  # 项目初始化脚本
└── README.md
```

## 新项目初始化

一键安装后，给新项目加规范也只需一条命令：

**macOS:**
```bash
~/.workbuddy/coding-standards/init-project.sh /path/to/your/project
```

**Windows:**
```powershell
& "$env:USERPROFILE\.workbuddy\coding-standards\init-project.ps1" "D:\path\to\your\project"
```

会自动部署 `CODEBUDDY.md` + `openspec/` 配置目录到项目中。

## 规范更新流程

规范有更新后，重新跑一键安装命令即可（会自动检测已有仓库并更新）：

**macOS:**
```bash
curl -fsSL https://raw.githubusercontent.com/BigMianBao/coding-standards/main/install.sh | bash
```

**Windows:**
```powershell
irm https://raw.githubusercontent.com/BigMianBao/coding-standards/main/install.ps1 | iex
```

> 跑完后在 CodeBuddy **新建会话**生效。

## 一键安装做了什么

| 步骤 | 操作 | macOS 位置 | Windows 位置 |
|------|------|------------|--------------|
| [1/5] | 检查 Git + Node.js | — | — |
| [2/5] | 克隆/更新规范仓库 | `~/.workbuddy/coding-standards/` | `%USERPROFILE%\.workbuddy\coding-standards\` |
| [3/5] | 20 个规范文件 + MEMORY.md | `~/.workbuddy/rules/` | 同左 |
| [4/5] | CodeBuddy 用户规则 + OpenSpec 命令 + 技能 | `~/.codebuddy/` | 同左 |
| [5/5] | OpenSpec CLI 安装检查 | 全局 npm | 全局 npm |

## 两层部署机制

| 层级 | 位置 | 作用 | 何时部署 |
|------|------|------|----------|
| 全局 | `~/.workbuddy/` + `~/.codebuddy/` | 所有项目通用的核心铁律 + OpenSpec 命令 | 每台电脑一次（一键安装） |
| 项目 | 项目根目录 `CODEBUDDY.md` + `openspec/` | 项目特定的完整规范 | 每个新项目一次（init-project） |

## 给 AI 工具用的一句话指令

在 CodeBuddy / WorkBuddy 等 AI 工具里直接说：

> **帮我执行：`curl -fsSL https://raw.githubusercontent.com/BigMianBao/coding-standards/main/install.sh | bash`**

AI 工具会在终端执行这条命令，完成全部配置。

## 规范来源

- GitHub: https://github.com/BigMianBao/coding-standards
- 本仓库在此基础上有增量优化（架构分层豁免判定、事件可靠性约束等）

## 注意事项

- CodeBuddy 规则在会话启动时加载，修改后需**新建会话**生效
- `CODEBUDDY.md` 和 `openspec/` 目录应提交到项目 Git 仓库，团队共享
- `~/.codebuddy/` 为用户级配置，不被版本控制跟踪，通过脚本部署
- Windows 用户注意：路径中有空格时请用双引号包裹

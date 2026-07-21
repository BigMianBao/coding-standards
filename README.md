# coding-standards

企业编程规范统一管理仓库。用于在多台电脑、多个项目间同步 CodeBuddy 编程规范。

支持 **macOS** 和 **Windows** 双平台。

## 仓库结构

```
coding-standards/
├── rules/                              # 20 个详细规范文件（01 ~ 20）
├── templates/
│   ├── CODEBUDDY.md                    # 项目指令模板（放项目根目录）
│   ├── openspec-config.yaml            # OpenSpec 配置模板
│   ├── coding-standards.mdc            # CodeBuddy 用户规则模板（全局）
│   ├── codebuddy-commands/opsx/        # OpenSpec 斜杠命令模板（6 个）
│   └── codebuddy-skills/              # OpenSpec 技能模板（6 个）
├── MEMORY.md                           # 全局核心规则
├── setup.sh / setup.ps1               # 全局部署脚本（macOS / Windows）
├── init-project.sh / init-project.ps1  # 项目初始化脚本（macOS / Windows）
└── README.md
```

## 前提条件

| 依赖 | macOS | Windows | 说明 |
|------|-------|---------|------|
| Git | `brew install git` | [下载安装](https://git-scm.com) | 克隆仓库 |
| Node.js >= 20.19.0 | `brew install node` | [下载安装](https://nodejs.org) | OpenSpec CLI 依赖 |
| SSH 密钥 | [配置指南](https://docs.github.com/zh/authentication/connecting-to-github-with-ssh) | 同左 | 推送/拉取仓库（也可用 HTTPS） |

## 使用方式

### macOS

**新电脑部署（每台一次）：**

```bash
git clone git@github.com:BigMianBao/coding-standards.git ~/.workbuddy/coding-standards
cd ~/.workbuddy/coding-standards
chmod +x setup.sh init-project.sh
./setup.sh
```

**新项目初始化（每个项目一次）：**

```bash
~/.workbuddy/coding-standards/init-project.sh /path/to/your/project
```

### Windows (PowerShell)

**新电脑部署（每台一次）：**

```powershell
git clone git@github.com:BigMianBao/coding-standards.git "$env:USERPROFILE\.workbuddy\coding-standards"
cd "$env:USERPROFILE\.workbuddy\coding-standards"
.\setup.ps1
```

**新项目初始化（每个项目一次）：**

```powershell
"$env:USERPROFILE\.workbuddy\coding-standards\init-project.ps1" "D:\path\to\your\project"
```

> 如果 PowerShell 提示执行策略限制，先运行：
> `Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned`

### 规范更新流程（两个平台通用）

```bash
cd ~/.workbuddy/coding-standards    # macOS
cd "$env:USERPROFILE\.workbuddy\coding-standards"  # Windows
git pull
./setup.sh          # macOS
.\setup.ps1         # Windows
# CodeBuddy 中新建会话生效
```

## setup 脚本做了什么（5 步）

| 步骤 | 操作 | macOS 位置 | Windows 位置 |
|------|------|------------|--------------|
| [1/5] | 20 个规范文件 + MEMORY.md | `~/.workbuddy/rules/` | `%USERPROFILE%\.workbuddy\rules\` |
| [2/5] | CodeBuddy 用户规则（alwaysApply） | `~/.codebuddy/rules/coding-standards/RULE.mdc` | 同左（路径结构一致） |
| [3/5] | 6 个斜杠命令 + 6 个技能 | `~/.codebuddy/commands/opsx/` + `~/.codebuddy/skills/` | 同左 |
| [4/5] | OpenSpec CLI 安装检查 | 全局 npm | 全局 npm |
| [5/5] | 完成 | — | — |

## 两层部署机制

| 层级 | 位置 | 作用 | 何时部署 |
|------|------|------|----------|
| 全局 | `~/.workbuddy/` + `~/.codebuddy/` | 所有项目通用的核心铁律 + OpenSpec 命令 | 每台电脑一次 |
| 项目 | 项目根目录 `CODEBUDDY.md` + `openspec/` | 项目特定的完整规范 | 每个新项目一次 |

## 规范来源

- GitHub: https://github.com/BigMianBao/coding-standards
- 本仓库在此基础上有增量优化（架构分层豁免判定、事件可靠性约束等）

## 注意事项

- CodeBuddy 规则在会话启动时加载，修改后需**新建会话**生效
- `CODEBUDDY.md` 和 `openspec/` 目录应提交到项目 Git 仓库，团队共享
- `~/.codebuddy/` 为用户级配置，不被版本控制跟踪，通过 setup 脚本部署
- Windows 用户注意：路径中有空格时请用双引号包裹

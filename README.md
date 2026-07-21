# coding-standards

企业编程规范统一管理仓库。用于在多台电脑、多个项目间同步 CodeBuddy 编程规范。

## 仓库结构

```
coding-standards/
├── rules/                    # 20 个详细规范文件（01 ~ 20）
├── templates/
│   ├── CODEBUDDY.md          # 项目指令模板（放项目根目录）
│   ├── openspec-config.yaml  # OpenSpec 配置模板
│   └── coding-standards.mdc  # CodeBuddy 用户规则模板（全局）
├── MEMORY.md                 # 全局核心规则
├── setup.sh                  # 全局部署脚本（每台电脑跑一次）
├── init-project.sh           # 项目初始化脚本（每个新项目跑一次）
└── README.md
```

## 使用方式

### 新电脑部署（每台一次）

```bash
git clone <你的仓库地址> ~/.workbuddy/coding-standards
cd ~/.workbuddy/coding-standards
chmod +x setup.sh init-project.sh
./setup.sh
```

### 新项目初始化（每个项目一次）

```bash
~/.workbuddy/coding-standards/init-project.sh /path/to/your/project
```

### 规范更新流程

```bash
cd ~/.workbuddy/coding-standards
git pull
./setup.sh
# CodeBuddy 中新建会话生效
```

## 两层部署机制

| 层级 | 位置 | 作用 | 何时部署 |
|------|------|------|----------|
| 全局 | `~/.workbuddy/` + `~/.codebuddy/rules/` | 所有项目通用的核心铁律 | 每台电脑一次 |
| 项目 | 项目根目录 `CODEBUDDY.md` + `openspec/` | 项目特定的完整规范 | 每个新项目一次 |

## 规范来源

- GitHub: https://github.com/BigMianBao/coding-standards
- 本仓库在此基础上有增量优化（架构分层豁免判定、事件可靠性约束等）

## 注意事项

- CodeBuddy 规则在会话启动时加载，修改后需新建会话生效
- `CODEBUDDY.md` 和 `openspec/` 目录应提交到项目 Git 仓库，团队共享
- `~/.codebuddy/rules/` 为用户级规则，不被版本控制跟踪，通过 setup.sh 部署


# 我对你很失望，没有严格按照以下规则进行编程
# 用户级全局规则

## 一、核心铁律（任何场景不可违反）

1. **需求模糊必须追问，禁止自行猜测填充**：用户只提供简短/不完整需求、缺少限定条件、存在多方案可选时，禁止自行脑补默认规则、技术选型、业务逻辑。
2. **禁止替用户做技术决策**：不询问直接选用默认技术栈、默认目录结构、默认部署方式，一律先确认。
3. **结构化提问**：存在固定可选方案时用选择题，无固定选项时用清单式开放式提问。

## 二、代码变更前规范自检清单（每次必查）

### A. 架构分层
- Domain/Model 层零外部依赖（禁止 import ORM/http 框架）
- Handler/Controller 只做参数校验和响应格式化，不含业务逻辑
- 模块间通过接口通信，禁止直接 import 其他模块内部实现
- 单文件不超过 300 行，超过必须拆分

### B. 安全检查
- 禁止密钥/密码/token 硬编码
- 接口双层校验（路由鉴权 + 资源归属）
- 生产环境 CORS 禁止 `*` 通配符
- 敏感数据通过 DTO 输出，禁止返回原始数据库实体

### C. 命名规范
- 接口使用 I+ 前缀（IUserRepository）
- 私有字段 _camelCase，常量 PascalCase
- 重复代码 3 处以上必须抽取
- 禁止空 catch / 静默忽略错误

### D. 配置检查
- 所有可变参数通过配置注入，禁止硬编码 IP/端口/超时
- Token/密钥过期时间从配置读取

### E. Git 提交
- 格式：`<type>(<scope>): <描述>`（Conventional Commits）
- 禁止直推 main，必须通过 PR
- 单次提交原子化

## 三、技术选型白名单

| 领域 | 推荐 | 禁止 |
|------|------|------|
| 前端 | Vue3 / React + Vite | - |
| .NET后端 | ASP.NET Core LTS | .NET Framework |
| Java后端 | SpringBoot / SpringCloud | - |
| Go后端 | Gin / Kitex | - |
| Python后端 | FastAPI | Flask |
| 数据库 | MySQL 8.0+ / PostgreSQL 14+ | - |
| 缓存 | Redis | - |
| 消息队列 | RocketMQ / Kafka | - |
| 通信 | gRPC / REST | 裸TCP Socket |

## 四、版本号
语义化 SemVer：MAJOR.MINOR.PATCH

## 五、代码风格偏好
- 缩进：按项目约定（检查 .editorconfig / .prettierrc）
- 引号：单引号优先（JS/TS），双引号（C#/Java）
- 分号：JS/TS 按项目配置
- 命名：英文，禁止拼音，禁止无意义单字母（循环变量除外）

---

## 六、规范来源

- **GitHub 仓库**: https://github.com/BigMianBao/coding-standards
- **本地缓存**: `~/.workbuddy/rules/`（20个规则文件）
- **同步策略**: 每次会话启动时检查 GitHub 版本，有更新则自动同步到本地

> 详细规范见 `~/.workbuddy/rules/`（01-规范总则 ~ 20-规范落地保障）

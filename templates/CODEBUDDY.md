# CodeBuddy 项目指令

> 本文件是 CodeBuddy 的强制项目指令，每次会话自动加载。以下规范为约束性规则，不是参考建议。

## 一、核心铁律（任何场景不可违反）

1. **需求模糊必须追问，禁止自行猜测填充**：用户只提供简短/不完整需求、缺少限定条件、存在多方案可选时，禁止自行脑补默认规则、技术选型、业务逻辑。
2. **禁止替用户做技术决策**：不询问直接选用默认技术栈、默认目录结构、默认部署方式，一律先确认。
3. **结构化提问**：存在固定可选方案时用选择题，无固定选项时用清单式开放式提问。

## 二、架构分层规范（Clean Architecture）

### 层间依赖方向（只能外层指向内层，禁止反向）

```
API（控制器/路由）
  ↓
Application（用例/DTO/接口定义）
  ↓
Domain（实体/值对象/领域事件）  ← 核心层，零外部依赖
  ↑（依赖倒置）
Infrastructure（数据库/MQ/第三方API）
```

### 各层依赖规则

| 层 | 可以依赖 | 禁止依赖 |
|----|----------|----------|
| Domain | 无（零外部依赖） | Application、Infrastructure、API、任何框架 |
| Application | Domain | Infrastructure、API、任何框架具体实现 |
| Infrastructure | Domain、Application（仅接口） | API |
| API | Application、Domain（仅DTO/枚举） | Infrastructure |

### 接口归属约定
- 仓储接口（`IUserRepository` 等）归属 **Domain 层**（持久化是领域关注点）
- 外部服务接口（`IMessageSender`、`IPaymentGateway` 等）归属 **Application 层**（应用编排关注点）

### 事件通信可靠性约束
通过领域事件通信时必须满足：
- **幂等性**：订阅方处理逻辑必须幂等，通过业务唯一键或事件 ID 去重
- **补偿机制**：处理失败必须有重试/死信队列/人工兜底，禁止"失败即丢弃"
- **可追踪**：每个事件必须携带 traceId / correlationId
- **事务边界**：使用事务发件箱（Outbox Pattern），禁止"先提交事务再发事件"

### 分层豁免判定（四信号法）
四个硬信号全部不命中才可豁免完整四层，任一命中必须四层：

| 信号 | 判定标准 |
|------|----------|
| 业务不变量 | 实体内部存在必须永远成立的跨字段约束规则 |
| 状态机 | 实体有多于 2 个状态，且状态间有迁移规则 |
| 跨实体协调 | 操作此实体时需校验或联动其他实体 |
| 领域事件 | 其他模块需响应此实体的变更 |

豁免必须留痕：`// @layering:exempt reason=no-invariants,no-state-machine,no-coordination,no-events`

## 三、代码变更前自检清单（每次必查）

### A. 架构分层
- Domain 层零外部依赖（禁止 import ORM/http 框架）
- Handler/Controller 只做参数校验和响应格式化，不含业务逻辑
- 模块间通过接口通信，禁止直接 import 其他模块内部实现
- 单文件不超过 300 行，超过必须拆分
- 无循环依赖

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

## 四、技术选型白名单

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

## 五、前端分层规则

| 层 | 可依赖 | 禁止依赖 |
|----|--------|----------|
| components/ | utils、common、assets | modules、api |
| modules/业务模块 | api、utils、common、components | 其他 modules（写操作） |
| api/ | utils、common、config | modules、components |
| store/ | api、utils、common | modules、components |
| utils/ | 无（零依赖） | 所有其他层 |

跨模块只读引用豁免：读操作允许跨模块封装好的只读 selector，写操作禁止直接调用其他模块的 mutation/action。

## 六、详细规范文件索引

以下规范文件位于 `openspec/rules/`，需要时按需读取：

| 编号 | 文件 | 内容 |
|------|------|------|
| 01 | 01-规范总则.md | 目的、适用范围、九大核心原则 |
| 02 | 02-项目命名与版本规范.md | 仓库命名格式、SemVer版本号规范 |
| 03 | 03-Git分支管理规范.md | 分支定义、保护规则、合并策略 |
| 04 | 04-Git提交规范.md | Conventional Commits格式、type分类 |
| 05 | 05-技术选型规范.md | 技术白名单、推荐清单、ADR决策文档要求 |
| 06 | 06-立项权限流程.md | 立项评审、仓库创建、权限分配 |
| 07 | 07-项目目录结构规范.md | 根目录必备文件、通用分层标准、各技术栈目录模板 |
| 08 | 08-架构分层与依赖规范.md | 层间依赖方向、模块间通信、循环依赖、分层豁免判定 |
| 09 | 09-项目搭建流程.md | 9步标准化搭建流程 |
| 10 | 10-代码命名规范.md | 类/方法/变量/常量/字段命名规则 |
| 11 | 11-代码复用与去重规范.md | DRY原则、重复判定标准、抽取位置决策 |
| 12 | 12-异常处理规范.md | 自定义异常、捕获规则、统一返回格式 |
| 13 | 13-配置管理规范.md | 多环境配置、强类型绑定、禁止硬编码 |
| 14 | 14-REST-API设计规范.md | URL规范、HTTP方法语义、分页、DTO输出 |
| 15 | 15-安全编码规范.md | 输入校验、注入防护、XSS/CSRF、CORS、越权防护 |
| 16 | 16-密钥管理规范.md | 各环境密钥存储方式、禁止提交密钥铁律 |
| 17 | 17-测试策略与分层规范.md | 测试金字塔、单元/集成/E2E测试规范 |
| 18 | 18-发布运维规范.md | CD流水线、发布策略、监控告警、回滚规范 |
| 19 | 19-项目验收标准.md | 搭建验收条件、Checklist |
| 20 | 20-规范落地保障.md | 模板固化、定期巡检、版本迭代 |

## 七、OpenSpec 工作流

本项目已集成 OpenSpec（规格驱动开发框架），可用斜杠命令：

| 命令 | 作用 |
|------|------|
| `/opsx:propose <功能描述>` | 创建变更提案，生成 proposal + design + tasks |
| `/opsx:apply` | 按规格和设计执行实现 |
| `/opsx:archive` | 归档完成的变更 |
| `/opsx:explore` | 探索思考 |

OpenSpec 生成文档时会自动读取 `openspec/config.yaml` 中的 context 和 rules，遵循上述规范。

---
name: Git提交规范
weight: 4
---
# Git提交规范

## 1. Conventional Commits 格式
```
<type>(<scope>): <描述>

可选body

可选footer
```

## 2. type 分类

| type | 含义 |
|------|------|
| feat | 新增功能 |
| fix | 缺陷修复 |
| docs | 文档修改 |
| style | 仅格式调整，无逻辑变更 |
| refactor | 代码重构，无功能变化 |
| test | 新增/修改测试用例 |
| chore | 构建脚本、依赖更新 |
| perf | 性能优化 |
| ci | 流水线配置调整 |

## 3. 示例
```
feat(auth): 新增JWT刷新令牌轮换
fix(order): 修复并发下单库存超卖问题
docs(readme): 补充部署说明文档
```

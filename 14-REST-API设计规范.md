---
name: REST-API设计规范
weight: 12
---
# REST API 设计规范

## 1. URL规范
统一URL前缀：`/api/v1/资源名`

## 2. HTTP方法语义

| 方法 | 用途 | 示例 |
|------|------|------|
| GET | 查询 | GET /users、GET /users/{id} |
| POST | 创建 | POST /users |
| PUT | 全量更新 | PUT /users/{id} |
| PATCH | 局部更新 | PATCH /users/{id} |
| DELETE | 删除 | DELETE /users/{id} |

## 3. 分页参数
统一分页：`?page=1&pageSize=20`

## 4. 错误响应
遵循 RFC 7807 Problem Details 标准格式。

## 5. 数据输出
禁止返回原始数据库实体，统一使用 DTO 对外输出。

# Task: 代码开发｜REST API 服务

> 示例 Task，展示如何用 TaskBrain 驱动 AI 完成一个代码项目

```markdown
- [ ] Task-API服务开发-用户认证模块 🔺 📅 2026-08-20 🏷️ #task 📁 ~/projects/api-server/

# Task: 代码开发｜用户认证模块

## 背景
我们的 API 服务缺少认证模块，需要实现 JWT token 认证。

## 执行上下文
| 字段 | 值 |
|------|-----|
| **📁 执行文件夹** | `~/projects/api-server/` |
| **🛠 关联 Skills** | 无 |

## 目标
- [ ] 实现 JWT 认证 API（注册/登录/刷新/验证）
- [ ] 单元测试覆盖 ≥ 80%
- [ ] README 包含 API 文档

## 约束
- 技术栈：Node.js + Express + jsonwebtoken
- 禁止：硬编码密钥，必须使用环境变量
- 安全：密码必须 bcrypt 哈希，不能明文存储

## 资源
| 资源 | 路径 |
|------|------|
| 项目结构规范 | `SPEC.md` |
| API 约定 | `docs/api-spec.md` |

## 执行步骤

### Phase 1 · 搭建骨架
1. 检查 `SPEC.md`，确认项目结构
2. 安装依赖：`npm install jsonwebtoken bcryptjs`
3. 创建 `src/middleware/auth.js` 骨架
4. 创建 `src/routes/auth.js` 骨架

### Phase 2 · 实现核心逻辑
按以下顺序实现：
1. `POST /auth/register` — 注册
2. `POST /auth/login` — 登录，签发 JWT
3. `POST /auth/refresh` — 刷新 token
4. `GET /auth/me` — 验证 token，返回当前用户

### Phase 3 · 测试
1. 编写 `test/auth.test.js`
2. 跑测试，确保覆盖率 ≥ 80%

### Phase 4 · 文档
1. 更新 `README.md`，添加 API 文档
2. 用 curl 示例演示每个接口

## 验收标准
- [ ] 4 个 API 全部实现，逻辑正确
- [ ] `npm test` 全部通过，覆盖率 ≥ 80%
- [ ] README 包含 API 文档和 curl 示例
```

# 🧠 zTask

**把"我想做 X"变成一个结构完整的 Task 文件。**

zTask 只做一件事：帮助制定 Task。不执行、不管理任务进度、不负责完成。

---

## 核心

```
💬 "我想做 X"
       ↓
📋 结构完整的 Task 文件
       ↓
丢给任何 AI 执行（用户自己决定用哪个）
```

---

## 一个 Task 长什么样？

```markdown
- [ ] Task-分析竞品差异化策略 🔺 📅 2026-08-15 🏷️ #task 📁 ~/projects/strategy/

# Task: 竞品分析｜差异化策略

## 背景
我们需要搞清楚竞品的差异化路线，为下季度产品方向提供依据。

## 执行上下文
| 字段 | 值 |
|------|-----|
| **📁 执行文件夹** | `~/projects/strategy/` |
| **🛠 关联 Skills** | `research` |

## 目标
- [ ] 完成 5 家主要竞品的差异化分析
- [ ] 输出 1 页策略摘要

## 执行步骤
### Phase 1 · 竞品调研
...

## 验收标准
- [ ] 5 家竞品全部覆盖
```

---

## 5 分钟上手

### 第一步：克隆仓库
```bash
git clone https://github.com/YOUR_USERNAME/ztask.git ~/ztask
```

### 第二步：扫描路径上下文
```bash
cd ~/ztask
./scripts/scan-paths.sh           # 生成 paths-context.md
```

### 第三步：让 AI 制定 Task

把 `skills/taskbrain/SKILL.md` 作为系统提示，告诉 AI：

```
请帮我把"我想做竞品差异化分析"制定成一个 Task。
```

AI 会：
1. 提问澄清（目标/位置/约束）
2. 生成完整的 Task 文件
3. 告知存放路径

### 第四步：拿到 Task 后

用户自己决定怎么执行——丢给 Claude / GPT / OpenClaw / 任何 AI。

---

## Task 格式速查

| 符号 | 含义 |
|------|------|
| `🔺` | 高优先级 |
| `🔻` | 中优先级 |
| `📅 YYYY-MM-DD` | 截止日期 |
| `📁 /路径/` | AI 执行时的工作目录 |
| `🏷️ #task` | 标签 |
| `- [x] ✅ 日期` | 已完成 |

完整格式见 [TASK-FORMAT.md](TASK-FORMAT.md)

---

## 文件结构

```
ztask/
├── README.md
├── TASK-FORMAT.md            ← Task 格式规范
├── scripts/
│   └── scan-paths.sh        ← 扫描电脑关键路径
└── skills/taskbrain/
    ├── SKILL.md             ← AI 制定 Task 的规范
    └── README.md             ← Skill 安装指南
```

---

## zTask 做什么

✅ 制定 Task（把模糊想法变成结构化指令）
✅ 生成执行上下文（scan-paths.sh）
✅ Task 格式规范（TASK-FORMAT.md）

## zTask 不做什么

❌ 执行 Task
❌ 管理任务进度
❌ 追踪完成状态

---

## 为什么需要这个？

因为"我想做 X"不是一个好指令。

AI 需要知道：在哪做？做什么？分几步？验收标准是什么？

zTask 让 AI 帮你把这些问清楚，然后生成一个结构完整的 Task 文件。

---

## 许可证

MIT License

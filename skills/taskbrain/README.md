# TaskBrain Agent Skill

让任何 AI Agent 都能理解并执行 TaskBrain 任务。

## 支持的 Agent

| Agent | 安装方式 |
|-------|---------|
| **OpenClaw / QClaw** | 复制到 `~/.qclaw-oversea/skills/taskbrain/` |
| **Claude Code** | 复制到项目 `.taskbrain/skill.md`，会话开头加载 |
| **通用 AI（手动）** | 把 SKILL.md 内容作为系统提示的一部分 |

## OpenClaw 安装

```bash
# 方式一：复制到 skills 目录
cp -r skills/taskbrain ~/.qclaw-oversea/skills/

# 方式二：参考 skills/taskbrain/SKILL.md 手动配置
```

安装后，OpenClaw 会自动识别并在用户要求执行 Task 时激活。

## Claude Code 使用

在会话开头告诉 Claude Code：

```
请先读取 .taskbrain/skill.md 文件，这是 TaskBrain Agent Skill 的执行规范。
然后读取 paths-context.md 了解当前系统环境。
```

## 通用 AI 使用

把 `SKILL.md` 的内容粘贴到你的 AI 的系统提示中，或者在每次对话开头说：

```
请先读取 paths-context.md（系统路径）和 Task 文件，然后按 Task 执行。
```

## Skill 做了什么

1. **读取路径上下文** — AI 知道文件在哪
2. **解析 Task** — 提取执行文件夹、目标、步骤
3. **按 Phase 执行** — 分阶段完成交付物
4. **更新 signpost 行** — Task 状态同步到 Obsidian

## 文件结构

```
skills/taskbrain/
├── SKILL.md    ← Skill 主文件（给 AI 读的规范）
└── README.md   ← 本文件（安装指南）
```

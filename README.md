# 🧠 TaskBrain

**用 Obsidian 驱动 AI 执行任务。** 把模糊的想法变成 AI 能准确执行的指令，执行完了归档，沉淀为下一个任务的上下文。

---

## 核心循环

```
制定 Task（Obsidian）
       ↓
扫描路径上下文（scan-paths.sh）
       ↓
AI 执行 Task + 路径上下文
       ↓
交付物 → Archive → 新 Task
```

---

## 一个 Task 长什么样？

```markdown
- [ ] Task-分析竞品差异化策略 🔺 📅 2026-08-15 🏷️ #task 📁 ~/projects/strategy/

# Task: 竞品分析｜差异化策略

## 背景
我们需要搞清楚竞品的差异化路线。

## 执行上下文
| 字段 | 值 |
|------|-----|
| **📁 执行文件夹** | `~/projects/strategy/` |

## 目标
- [ ] 完成 5 家主要竞品的差异化分析

## 执行步骤
### Phase 1 · 竞品调研
...

## 验收标准
- [ ] 5 家竞品全部覆盖
```

---

## 5 分钟上手

### 第一步：安装 Tasks 插件
`设置 → 社区插件 → 搜索 `Tasks` → 安装 → 启用`

### 第二步：克隆仓库
```bash
git clone https://github.com/YOUR_USERNAME/taskbrain.git ~/taskbrain
```

### 第三步：扫描路径上下文
```bash
cd ~/taskbrain
./scripts/scan-paths.sh           # 生成 paths-context.md
```

### 第四步：新建 Task

把 `obsidian-templates/Task模板.md` 复制到 Vault 的 `01 Tasks/` 目录，然后新建 Task 文件。

### 第五步：丢给 AI

把 **Task 内容 + paths-context.md** 一起粘贴给 AI，它就知道在哪工作、做什么。

### 第六步：安装 Agent Skill（让 AI 更聪明）

**OpenClaw：**
```bash
cp -r skills/taskbrain ~/.qclaw-oversea/skills/
```

**Claude Code / 通用 AI：**
在会话开头说：`请先读取 paths-context.md 和你的 Task 文件，然后按 Task 执行。`

---

## 完整流程图

```
┌──────────────────────────────────┐
│  📋 制定 Task（Obsidian 新建.md） │
└──────────────┬───────────────────┘
               ▼
┌──────────────────────────────────┐
│  💻 ./scan-paths.sh → paths-context.md │
└──────────────┬───────────────────┘
               ▼
        把两者一起粘贴给 AI
               │
               ▼
┌──────────────────────────────────┐
│  🤖 AI 执行                       │
│  - 读取 paths-context.md          │
│  - 在执行文件夹中工作             │
│  - 按 Phase 顺序执行              │
│  - 交付物写入磁盘                │
└──────────────┬───────────────────┘
               ▼
┌──────────────────────────────────┐
│  ✅ 更新 signpost 行（- [x] ✅）  │
│  📦 移入 history/                 │
└──────────────────────────────────┘
```

---

## 文件结构

```
taskbrain/
├── README.md
├── TASK-FORMAT.md
├── scripts/
│   └── scan-paths.sh          ← 扫描关键路径
├── skills/
│   └── taskbrain/
│       ├── SKILL.md           ← Agent 执行规范
│       └── README.md          ← Skill 安装指南
├── examples/
│   ├── Task-竞品分析.md
│   ├── Task-API服务开发.md
│   └── Task-知识整理-主题笔记.md
└── obsidian-templates/
    └── Task模板.md
```

---

## Task 格式速查

| 符号 | 含义 |
|------|------|
| `🔺` | 高优先级 |
| `📅 YYYY-MM-DD` | 截止日期 |
| `📁 /路径/` | AI 执行时的**工作目录** |
| `🏷️ #task` | 标签 |
| `- [x] ✅ 日期` | 已完成 |

完整格式见 [TASK-FORMAT.md](TASK-FORMAT.md)

---

## 为什么比提示词好？

| | 提示词 | TaskBrain |
|--|--------|----------|
| 上下文 | 每次手动复制 | **持久化，跨会话继续** |
| 文件位置 | 要额外描述 | **执行上下文直接告知 AI** |
| 交付物 | 存在对话里 | **写入磁盘，归档沉淀** |
| 循环 | 每次重来 | **每次产出 → 下次上下文** |

---

## 许可证

MIT License

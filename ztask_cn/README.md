# zTask（中文版）

> **把模糊想法变成结构化的可执行 Task —— 只制定，不执行。**

zTask 是一个面向 AI Agent 的 Skill：当你只有一个模糊的想法（"我想做 X"）时，它会通过提问澄清、读取系统上下文，生成一份结构化、可直接交给任意 AI 执行的 Task 文件（Markdown 格式）。生成之后，用哪个 AI、怎么执行，完全由你决定。

English version: [ztask_eng](../ztask_eng/README.md)

---

## 解决什么问题

- 想法太模糊，直接丢给 AI 执行，结果总是跑偏（"做好一点"不是任务）
- AI 不了解你的本机环境，不知道文件在哪、该在哪个目录干活
- 任务没有验收标准，做完也不知道算不算完成

zTask 在"想法"和"执行"之间加一层**制定**：先问清楚做什么、在哪做、做到什么程度，再输出一份带目标清单、分阶段步骤和验收标准的 Task 文件。任何 AI 拿到这份文件都能直接开工。

**适用场景：**

- 有一个想法，想先整理成清晰的任务说明再动手
- 需要把任务交给特定的 AI 工具（Claude Code、Cursor、Qoder 等）执行
- 希望任务有明确的完成标准，可逐项验收

## 工作流程

```
提问澄清 → 读取系统上下文 → 生成 Task → 输出与存放建议
```

1. **提问澄清** —— 一次问清楚：做什么（交付物）、在哪做（目录/文件）、做到什么程度（完成标准），可选追问约束、截止日期、已有资源
2. **读取系统上下文** —— 若存在 `paths-context.md` 则先读取；否则可运行 `scan-paths.sh` 扫描本机 Git 项目、AI 工具 Skills/MCP 配置与 Obsidian Vault，生成环境清单，帮助推断执行文件夹
3. **生成 Task** —— 按规范模板输出，必含：背景、执行上下文、目标（checkbox）、Phase 步骤、验收标准
4. **输出与存放建议** —— 给出完整 Markdown 内容和推荐存放路径（如 `~/Obsidian Vault/01 Tasks/Task-xxx.md`），并提醒：下一步由用户决定

## Task 输出模板

```markdown
# Task: {领域}｜{描述}

## 背景
{为什么做这件事}

## 执行上下文
| 字段 | 值 |
|------|-----|
| **📁 执行文件夹** | `/路径/` |
| **🛠 关联 Skills** | `{如果有}` |

## 目标
- [ ] {具体目标1}
- [ ] {具体目标2}

## 执行步骤
### Phase 1 · {阶段名}
{步骤...}

## 验收标准
- [ ] {可验证的标准1}
- [ ] {可验证的标准2}
```

## 触发方式

安装后，对 AI 说：

- "帮我制定 Task"
- "写个任务"
- "我想做 X"
- "把这个想法变成任务"

## 安装

把 `ztask_cn/` 目录整体复制到你所用 AI 工具的 skills 目录，并将 `scripts/` 一并放在其上级目录（见下方路径约定），或将 `scripts/` 复制进 Skill 目录并相应调整 SKILL.md 中的脚本路径。

| AI 工具 | 示例路径 |
|---------|---------|
| Claude Code | `~/.claude/skills/ztask_cn/` |
| Qoder | `~/.qoder/skills/ztask_cn/` |
| Cursor | `~/.cursor/skills/ztask_cn/` |
| Hermes | `~/.hermes/skills/ztask_cn/` |

> **路径约定**：本 Skill 中脚本以相对路径 `../scripts/scan-paths.sh` 引用（即仓库根目录的 `scripts/`）。若整体克隆本仓库使用，开箱即用；若单独复制 Skill 目录安装，请把根目录 `scripts/` 放在该 Skill 目录的上级，或复制脚本进 Skill 目录后修改 SKILL.md 中的路径。

## scan-paths.sh

**用途：** 扫描本机的 Git 项目、各 AI 工具的 Skills/Plugins/MCP 配置、Obsidian Vault 与开发工具版本，输出 `paths-context.md`，让 AI 制定任务时了解你的真实环境。

**依赖：** bash + python3（macOS/Linux 自带）

**用法：**

```bash
bash scripts/scan-paths.sh paths-context.md
```

参数为输出文件名，缺省也是 `paths-context.md`。生成的文件建议放在常制定任务的目录（如 Obsidian Vault 的任务目录），Skill 会在制定前自动读取。

## 目录结构

```
ztask/                        # 仓库根目录
├── README.md                 # 仓库总览（双语导航）
├── LICENSE                   # MIT License
├── scripts/
│   └── scan-paths.sh         # 系统路径扫描脚本
├── ztask_cn/                 # 中文版 Skill
│   ├── SKILL.md
│   └── README.md
└── ztask_eng/                # 英文版 Skill
    ├── SKILL.md
    └── README.md
```

## License

[MIT License](../LICENSE)

# zTask

**把模糊想法变成结构化的可执行 Task —— 只制定，不执行。**

zTask 是一个面向 AI Agent 的 Skill。它通过提问澄清和读取系统上下文（可选运行 `scan-paths.sh` 扫描本机环境），把"我想做 X"这样的模糊想法转化为一份带目标清单、分阶段步骤和验收标准的 Task 文件（Markdown），交给任意 AI 执行。用哪个 AI、怎么执行，由你决定。

**Turn vague ideas into structured, executable Tasks — drafting only, never execution.**

zTask is a Skill for AI agents. Through clarifying questions and local system context, it turns a fuzzy "I want to do X" into a Task file (Markdown) with goals, phased steps, and acceptance criteria — ready for any AI to execute. Which AI, and how, is entirely up to you.

## 快速开始 / Quick Start

### 1. 扫描本地环境 / Scan Local Environment

让 zTask 了解你的项目结构、AI 工具和文件布局：
Let zTask understand your project structure, AI tools, and file layout:

```bash
bash ztask_cn/scripts/scan-paths.sh paths-context.md
```

运行后生成 `paths-context.md`，zTask 制定任务时会自动读取它，帮你推断合适的执行目录。
This generates `paths-context.md`, which zTask reads automatically when drafting tasks to infer the right execution directory.

### 2. 制定一个 Task / Draft a Task

安装 Skill 后，对 AI Agent 说：
After installing the Skill, tell your AI Agent:

- **"帮我制定一个 Task：整理 Downloads 文件夹"**
- **"我想把 Obsidian 笔记里的英文翻译成中文"**
- **"写个任务：给项目加单元测试"**

zTask 会先向你提问澄清需求，然后生成一份包含执行目录的 Task 文件，交给任意 AI 执行。
zTask will first ask clarifying questions, then generate a Task file with execution directory, ready for any AI to execute.

---

## 选择哪个版本 / Which Version

两个版本功能完全一致，仅语言不同，任选其一安装即可。
Both editions are functionally identical — they differ only in language. Pick one.

| 目录 / Directory | 版本 / Edition | 说明 / Details |
|------------------|----------------|----------------|
| [`ztask_cn/`](ztask_cn/README.md) | 中文版 | 中文 Skill + 中文文档，安装目录名建议为 `ztask_cn` |
| [`ztask_eng/`](ztask_eng/README.md) | English | English Skill + English docs; install as `ztask_eng` |

## 目录结构 / Repository Layout

```
ztask/
├── README.md                 # 本文件 / This file
├── LICENSE                   # MIT License
├── scripts/
│   └── scan-paths.sh         # 系统路径扫描脚本 / System path scanner
├── ztask_cn/                 # 中文版 Skill / Chinese Skill
│   ├── SKILL.md
│   └── README.md
└── ztask_eng/                # 英文版 Skill / English Skill
    ├── SKILL.md
    └── README.md
```

> Skill 以相对路径 `../scripts/scan-paths.sh` 引用扫描脚本，整体克隆本仓库即可开箱即用。
> Each Skill references the scanner via `../scripts/scan-paths.sh`; cloning the whole repo works out of the box.

## License

[MIT License](LICENSE)

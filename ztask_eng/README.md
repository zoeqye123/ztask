# zTask (English Edition)

> **Turn vague ideas into structured, executable Tasks — drafting only, never execution.**

zTask is a Skill for AI agents. You bring a half-formed idea ("I want to do X"); zTask asks the right clarifying questions, reads your local system context, and produces a structured Task file (Markdown) that any AI can pick up and execute. Which AI you run it with, and how — that's entirely up to you.

中文版：[ztask_cn](../ztask_cn/README.md)

---

## The Problem

- Vague prompts produce vague results. "Make it better" is not a task.
- Your AI has no idea what's on your machine — where the files are, or which directory to work in.
- Without acceptance criteria, you can't tell when something is actually done.

zTask inserts a **drafting layer** between idea and execution: it pins down *what* gets delivered, *where* the work happens, and *what "done" looks like*, then outputs a Task file with goal checklists, phased steps, and acceptance criteria. Hand that file to any AI and it can get straight to work.

**Good fit when you:**

- Have an idea you want to shape into a clear brief before acting on it
- Delegate work to specific AI tools (Claude Code, Cursor, Qoder, ...)
- Want tasks with explicit, item-by-item verifiable completion criteria

## How It Works

```
Clarify with questions → Read system context → Generate the Task → Output & storage advice
```

1. **Clarify with questions** — one focused round: what's being delivered, where the work lives (directories/files), and what "done" means. Optionally: constraints, deadlines, existing resources.
2. **Read system context** — if `paths-context.md` exists, it's read first. Otherwise, `scan-paths.sh` can scan your local Git projects, AI tool Skills/MCP setups, and Obsidian Vaults to produce an environment snapshot that helps pick the right execution folder.
3. **Generate the Task** — output follows a fixed template: background, execution context, goals (checkboxes), phased steps, and acceptance criteria.
4. **Output & storage advice** — the full Markdown content plus a suggested home for the file (e.g. `~/Obsidian Vault/01 Tasks/Task-xxx.md`), with a reminder that the next move is yours.

## Task Template

```markdown
# Task: {Domain} | {Description}

## Background
{Why this task exists}

## Execution Context
| Field | Value |
|-------|-------|
| **📁 Execution folder** | `/path/` |
| **🛠 Related Skills** | `{if any}` |

## Goals
- [ ] {Concrete goal 1}
- [ ] {Concrete goal 2}

## Steps
### Phase 1 · {Phase name}
{Steps...}

## Acceptance Criteria
- [ ] {Verifiable criterion 1}
- [ ] {Verifiable criterion 2}
```

## Triggering

Once installed, just tell your AI:

- "Draft a task for me"
- "Write me a task"
- "I want to do X"
- "Turn this idea into a task"

## Installation

Copy the `ztask_eng/` folder into the skills directory of your AI tool of choice, keeping `scripts/` available per the path convention below (or copy `scripts/` into the Skill directory and adjust the script path in SKILL.md).

| AI tool | Example path |
|---------|--------------|
| Claude Code | `~/.claude/skills/ztask_eng/` |
| Qoder | `~/.qoder/skills/ztask_eng/` |
| Cursor | `~/.cursor/skills/ztask_eng/` |
| Hermes | `~/.hermes/skills/ztask_eng/` |

> **Path convention:** the Skill references the script via the relative path `../scripts/scan-paths.sh` (i.e. `scripts/` at the repo root). Cloning the whole repo works out of the box. If you install the Skill folder standalone, either place the repo-root `scripts/` directory next to it, or copy the script into the Skill directory and update the path in SKILL.md.

## scan-paths.sh

**What it does:** scans your local Git projects, Skills/Plugins/MCP configurations across AI tools, Obsidian Vaults, and installed dev tool versions, then writes the results to `paths-context.md` — so the AI drafts tasks against your real environment, not a guess.

**Dependencies:** bash + python3 (shipped with macOS/Linux)

**Usage:**

```bash
bash scripts/scan-paths.sh paths-context.md
```

The argument is the output filename (defaults to `paths-context.md`). Keep the generated file somewhere you often draft tasks (e.g. your Obsidian Vault's task folder); the Skill reads it automatically before drafting.

## Repository Layout

```
ztask/                        # Repo root
├── README.md                 # Repo overview (bilingual navigation)
├── LICENSE                   # MIT License
├── scripts/
│   └── scan-paths.sh         # System path scanner
├── ztask_cn/                 # Chinese Skill
│   ├── SKILL.md
│   └── README.md
└── ztask_eng/                # English Skill
    ├── SKILL.md
    └── README.md
```

## License

[MIT License](../LICENSE)

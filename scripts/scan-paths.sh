#!/usr/bin/env bash
#===============================================
# scan-paths.sh v3 (bash 3.2 兼容版)
# 扫描电脑 Git 项目 + AI 工具 Skills/Plugins/MCP
# 输出: paths-context.md（TaskBrain SKILL.md 的输入）
#===============================================

OUTPUT="${1:-paths-context.md}"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M")
HOME_DIR="$HOME"

echo "🔍 扫描关键路径..."

# ── 用 Python 生成完整文档 ──────────────────────────────
python3 - "$HOME_DIR" "$OUTPUT" "$TIMESTAMP" << 'PYEOF'
import os
import sys
import subprocess
import json
import glob
import time

home = os.path.expanduser("~")
output_file = sys.argv[2]
timestamp = sys.argv[3]

out = []

def L(msg=""):
    out.append(msg)

def section(title, emoji="##"):
    L("")
    L(f"{emoji} {title}")
    L("")

def get_skill_desc(skill_md):
    if not os.path.isfile(skill_md):
        return None
    try:
        content = open(skill_md, encoding="utf-8", errors="ignore").read()
        # Try to get first # heading
        for line in content.splitlines():
            line = line.strip()
            if line.startswith("# ") and len(line) > 2:
                desc = line[2:].strip()
                desc = desc.strip("#*`[]|")
                return desc[:60]
        # Try description field
        for line in content.splitlines():
            if line.strip().startswith("description:"):
                desc = line.split("description:", 1)[1].strip().strip('"').strip("'")
                return desc[:60]
    except:
        pass
    return None

def get_git_project_type(repo_dir):
    checks = [
        ("Cargo.toml", "🦀 Rust"),
        ("go.mod", "🐹 Go"),
        ("go.sum", "🐹 Go"),
        ("package.json", "📦 Node"),
        ("pyproject.toml", "🐍 Python"),
        ("requirements.txt", "🐍 Python"),
        ("setup.py", "🐍 Python"),
        ("pubspec.yaml", "🪟 Flutter"),
        ("pom.xml", "☕ Java"),
        ("build.gradle", "☕ Java"),
        ("CMakeLists.txt", "⚙️ C++"),
        ("Makefile", "⚙️ Make"),
    ]
    for fname, label in checks:
        if os.path.isfile(os.path.join(repo_dir, fname)):
            return label
    return "📄 其他"

def get_git_last_commit(repo_dir):
    try:
        r = subprocess.run(
            ["git", "-C", repo_dir, "log", "-1", "--format=%ad", "--date=short"],
            capture_output=True, text=True, timeout=10
        )
        return r.stdout.strip() or "未知"
    except:
        return "未知"

def list_dir_items(base_dir, prefix="", hidden=False):
    """List non-hidden directories, optionally with prefix."""
    items = []
    if not os.path.isdir(base_dir):
        return items
    try:
        for name in os.listdir(base_dir):
            if not hidden and name.startswith("."):
                continue
            items.append(name)
    except:
        pass
    return items

def scan_skills_dir(skill_dir, label):
    """Scan a skills directory and return formatted markdown lines."""
    lines = []
    if not os.path.isdir(skill_dir):
        return lines
    items = list_dir_items(skill_dir, hidden=False)
    if not items:
        return lines
    lines.append(f"### {label}")
    lines.append("")
    lines.append(f"`{skill_dir}/`")
    lines.append("")
    count = 0
    for name in sorted(items):
        skill_path = os.path.join(skill_dir, name)
        if not os.path.isdir(skill_path):
            continue
        count += 1
        desc = get_skill_desc(os.path.join(skill_path, "SKILL.md"))
        if desc:
            lines.append(f"- **{name}** — {desc}")
        else:
            lines.append(f"- **{name}**")
    lines.append("")
    lines.append(f"> 共 {count} 个")
    lines.append("")
    return lines

def scan_plugins_dir(plugin_dir, label):
    """Scan a plugins/extensions directory."""
    lines = []
    if not os.path.isdir(plugin_dir):
        return lines
    items = list_dir_items(plugin_dir, hidden=False)
    if not items:
        return lines
    lines.append(f"### {label}")
    lines.append("")
    lines.append(f"`{plugin_dir}/`")
    lines.append("")
    count = 0
    for name in sorted(items):
        item_path = os.path.join(plugin_dir, name)
        if not os.path.isdir(item_path):
            continue
        count += 1
        lines.append(f"- **{name}**")
    lines.append("")
    lines.append(f"> 共 {count} 个")
    lines.append("")
    return lines

def run_cmd(cmd, timeout=10):
    try:
        r = subprocess.run(cmd, capture_output=True, text=True, timeout=timeout, shell=False)
        return r.stdout.strip()
    except:
        return ""

# ── 生成文档 ────────────────────────────────────────────
L("# 💻 系统关键路径 & AI 工具全景")
L("")
L(f"> 生成时间：{timestamp}")
L("> 本文件由 scan-paths.sh v3 自动生成")
L("> **TaskBrain Skill 执行前，请先阅读此文件了解系统环境**")
L("")

# 系统信息
section("系统信息")
L("| 项目 | 值 |")
L("|------|-----|")
L(f"| OS | {os.uname().sysname} {os.uname().machine} |")
L(f"| 用户目录 | `~` |")
L(f"| Shell | {os.path.basename(os.environ.get('SHELL', '/bin/bash'))} |")
L(f"| Hostname | `{os.uname().nodename}` |")
L("")

# 目录结构
section("主目录结构")
for d in ["Desktop", "Documents", "Downloads", "Music", "Movies", "Pictures"]:
    path = os.path.join(home, d)
    if os.path.isdir(path):
        try:
            count = len(os.listdir(path))
        except:
            count = 0
        L(f"- `~/{d}/` — {count} 个文件")
L("")

# Git 项目扫描
section("🚀 Git 项目（自动扫描）", "##")
L("扫描范围：`~` 下所有含 `.git` 的目录")
L("")

# Find all git repos
git_repos = []
try:
    result = subprocess.run(
        ["find", home, "-name", ".git", "-type", "d"],
        capture_output=True, text=True, timeout=60
    )
    for git_path in result.stdout.strip().splitlines():
        if not git_path:
            continue
        repo_dir = os.path.dirname(git_path)
        rel_path = repo_dir.replace(home + "/", "")
        # Skip noise dirs
        skip_patterns = [
            "project/ztask", "ztask",
            ".qclaw-oversea/workspace", ".cache", "Library/Caches",
            "node_modules", ".git/objects"
        ]
        skip = False
        for pat in skip_patterns:
            if rel_path == pat or rel_path.startswith(pat + "/"):
                skip = True
                break
        if skip:
            continue
        git_repos.append((repo_dir, rel_path))
except:
    pass

git_repos = git_repos[:80]  # cap at 80

if not git_repos:
    L("> 未发现 Git 仓库")
else:
    L("| 项目名 | 路径 | 类型 | 最近提交 |")
    L("|--------|------|------|----------|")
    for repo_dir, rel_path in git_repos:
        name = os.path.basename(repo_dir)
        ptype = get_git_project_type(repo_dir)
        last = get_git_last_commit(repo_dir)
        L(f"| `{name}` | `~/{rel_path}` | {ptype} | {last} |")
    L("")
    L(f"> 共发现 **{len(git_repos)}** 个 Git 仓库")
L("")

# ── AI 工具扫描 ────────────────────────────────────────
section("🛠️ AI 编码工具 & Skills/Plugins/MCP 全景")

# ── OpenClaw / QClaw ──
L("### OpenClaw / QClaw")
L("")
L("路径前缀：`~/.qclaw-oversea/` 和 `~/.qclaw/`")
L("")

for skill_path in [
    os.path.join(home, ".qclaw-oversea/skills"),
    os.path.join(home, ".qclaw/skills"),
]:
    if os.path.isdir(skill_path):
        label = "OpenClaw Skills" if "oversea" in skill_path else "QClaw Skills"
        out.extend(scan_skills_dir(skill_path, label))

# MCP 配置
for mcp_cfg in [
    os.path.join(home, ".qclaw-oversea/config/mcp.json"),
    os.path.join(home, ".qclaw/config/mcp.json"),
]:
    if os.path.isfile(mcp_cfg):
        L("### OpenClaw MCP 配置")
        L("")
        L(f"`{mcp_cfg}`")
        L("")
        try:
            data = json.load(open(mcp_cfg))
            if isinstance(data, dict):
                keys = list(data.keys())
                if keys:
                    for k in keys:
                        L(f"  - {k}")
                else:
                    L("  （空配置）")
            elif isinstance(data, list):
                for item in data:
                    if isinstance(item, dict):
                        L(f"  - {item.get('name', item)}")
                    else:
                        L(f"  - {item}")
        except:
            L("  （无法解析 JSON）")
        L("")

# agents/skills
out.extend(scan_skills_dir(
    os.path.join(home, ".agents/skills"),
    "共享 Skills（.agents）"
))

# Workspace
ws_dir = os.path.join(home, ".qclaw-oversea/workspace")
if os.path.isdir(ws_dir):
    L("### OpenClaw Workspace")
    L("")
    L("`~/.qclaw-oversea/workspace/`")
    L("")
    for name in sorted(list_dir_items(ws_dir)):
        L(f"- **{name}**/")
    L("")

L("")

# ── Claude Code ──
L("### Claude Code")
L("")
L("路径前缀：`~/.claude/`")
L("")

out.extend(scan_skills_dir(
    os.path.join(home, ".claude/skills"),
    "Claude Code Skills"
))

# Claude Code MCP
settings_file = os.path.join(home, ".claude/settings.json")
if os.path.isfile(settings_file):
    L("### Claude Code MCP")
    L("")
    L("`~/.claude/settings.json` 中的 MCP 配置：")
    L("")
    try:
        data = json.load(open(settings_file))
        mcp = data.get("mcpServers", {})
        if mcp:
            for k in mcp.keys():
                L(f"  - {k}")
        else:
            L("  未找到 MCP 配置")
    except:
        L("  （无法解析）")
    L("")

# Claude Projects
projects_dir = os.path.join(home, ".claude/projects")
if os.path.isdir(projects_dir):
    L("### Claude Code Projects")
    L("")
    L("`~/.claude/projects/`")
    L("")
    for proj in sorted(list_dir_items(projects_dir)):
        proj_path = os.path.join(projects_dir, proj)
        has_skill = (
            os.path.isfile(os.path.join(proj_path, ".claude/skill.md")) or
            os.path.isfile(os.path.join(proj_path, ".taskbrain/skill.md"))
        )
        tag = " （含项目级 Skill）" if has_skill else ""
        L(f"- **{proj}**/{tag}")
    L("")

L("")

# ── Codex ──
L("### Codex")
L("")
for cdir in [
    os.path.join(home, ".codex"),
    os.path.join(home, ".codexai"),
    os.path.join(home, "Library/Application Support/Codex"),
]:
    if os.path.isdir(cdir):
        L(f"路径：`{cdir}/`")
        L("")
        out.extend(scan_skills_dir(os.path.join(cdir, "skills"), "Codex Skills"))
        out.extend(scan_skills_dir(os.path.join(cdir, "plugins"), "Codex Plugins"))
        out.extend(scan_skills_dir(os.path.join(cdir, "extensions"), "Codex Extensions"))
        for cfg in ["settings.json", "config.json"]:
            cfg_path = os.path.join(cdir, cfg)
            if os.path.isfile(cfg_path):
                L(f"配置文件：`{cfg_path}` ✅")
        L("")
if not any(os.path.isdir(d) for d in [
    os.path.join(home, ".codex"),
    os.path.join(home, ".codexai"),
    os.path.join(home, "Library/Application Support/Codex"),
]):
    L("> 未发现 Codex 安装")
    L("")

L("")

# ── Cursor ──
L("### Cursor")
L("")
L("路径前缀：`~/.cursor/`")
L("")

out.extend(scan_skills_dir(os.path.join(home, ".cursor/skills-cursor"), "Cursor Skills"))
out.extend(scan_skills_dir(os.path.join(home, ".cursor/skills"), "Cursor 通用 Skills"))
out.extend(scan_plugins_dir(os.path.join(home, ".cursor/extensions"), "Cursor 扩展"))

# Cursor MCP
cursor_settings = os.path.join(home, ".cursor/settings.json")
if os.path.isfile(cursor_settings):
    L("### Cursor MCP")
    L("")
    L("`~/.cursor/settings.json` 中的 MCP 配置：")
    L("")
    try:
        data = json.load(open(cursor_settings))
        mcp = data.get("mcpServers", {})
        if mcp:
            for k in mcp.keys():
                L(f"  - {k}")
        else:
            L("  未找到 MCP 配置")
    except:
        L("  （无法解析）")
    L("")

L("")

# ── Gemini ──
L("### Gemini")
L("")
for gdir in [
    os.path.join(home, ".gemini"),
    os.path.join(home, ".config/gemini"),
    os.path.join(home, "Library/Application Support/gemini"),
]:
    if os.path.isdir(gdir):
        L(f"路径：`{gdir}/`")
        L("")
        out.extend(scan_skills_dir(os.path.join(gdir, "skills"), "Gemini Skills"))
        out.extend(scan_plugins_dir(os.path.join(gdir, "plugins"), "Gemini Plugins"))
        L("")
gemini_cli = run_cmd(["which", "gemini"]) or run_cmd(["which", "gem"])
if gemini_cli:
    L("Gemini CLI 已安装 ✅")
    L("")

L("")

# ── Hermes ──
L("### Hermes")
L("")
hermes_found = False
for hdir in [
    os.path.join(home, ".hermes"),
    os.path.join(home, ".config/hermes"),
    os.path.join(home, "hermes"),
    os.path.join(home, "projects/hermes"),
]:
    if os.path.isdir(hdir):
        hermes_found = True
        L(f"路径：`{hdir}/`")
        L("")
        out.extend(scan_skills_dir(os.path.join(hdir, "skills"), "Hermes Skills"))
        out.extend(scan_plugins_dir(os.path.join(hdir, "plugins"), "Hermes Plugins"))
        out.extend(scan_plugins_dir(os.path.join(hdir, "config"), "Hermes 配置"))
        L("")
if not hermes_found:
    L("> 未发现 Hermes 安装")
    L("")

L("")

# ── Qoder ──
L("### Qoder")
L("")
for qdir in [
    os.path.join(home, ".qoder"),
    os.path.join(home, ".config/qoder"),
    os.path.join(home, "Library/Application Support/Qoder"),
    os.path.join(home, ".qoder-ai"),
]:
    if os.path.isdir(qdir):
        L(f"路径：`{qdir}/`")
        L("")
        out.extend(scan_skills_dir(os.path.join(qdir, "skills"), "Qoder Skills"))
        out.extend(scan_plugins_dir(os.path.join(qdir, "plugins"), "Qoder Plugins"))
        L("")

L("")

# ── Grok ──
L("### Grok")
L("")
grok_found = False
for gkdir in [
    os.path.join(home, ".grok"),
    os.path.join(home, ".config/grok"),
    os.path.join(home, "Library/Application Support/Grok"),
    os.path.join(home, ".xai"),
]:
    if os.path.isdir(gkdir):
        grok_found = True
        L(f"路径：`{gkdir}/`")
        L("")
        out.extend(scan_skills_dir(os.path.join(gkdir, "skills"), "Grok Skills"))
        out.extend(scan_plugins_dir(os.path.join(gkdir, "plugins"), "Grok Plugins"))
        L("")
grok_cli = run_cmd(["which", "grok"])
if grok_cli:
    L("Grok CLI 已安装 ✅")
    L("")
if not grok_found and not grok_cli:
    L("> 未发现 Grok 安装")
    L("")

L("")

# ── ZCode ──
L("### ZCode")
L("")
for zdir in [
    os.path.join(home, ".zcode"),
    os.path.join(home, ".config/zcode"),
    os.path.join(home, "Library/Application Support/ZCode"),
]:
    if os.path.isdir(zdir):
        L(f"路径：`{zdir}/`")
        L("")
        out.extend(scan_skills_dir(os.path.join(zdir, "skills"), "ZCode Skills"))
        out.extend(scan_plugins_dir(os.path.join(zdir, "plugins"), "ZCode Plugins"))
        L("")

L("")

# ── VS Code / Open Code ──
L("### VS Code / Open Code")
L("")
for vdir in [
    os.path.join(home, ".vscode"),
    os.path.join(home, "Library/Application Support/Code"),
]:
    if os.path.isdir(vdir):
        L(f"路径：`{vdir}/`")
        L("")
        out.extend(scan_skills_dir(os.path.join(vdir, "skills"), "VS Code Skills"))
        out.extend(scan_plugins_dir(os.path.join(vdir, "extensions"), "VS Code 扩展"))
        L("")
vscode_cli = run_cmd(["which", "code"])
if vscode_cli:
    ver = run_cmd(["code", "--version"]) or "已安装"
    L(f"VS Code CLI：`{ver}` ✅")
    L("")

L("")

# ── 全局 MCP 汇总 ───────────────────────────────────────
section("🔌 全局 MCP 服务器汇总")

mcp_found = False

# mcporter CLI
mcporter_path = run_cmd(["which", "mcporter"])
if mcporter_path:
    mcp_found = True
    L("### mcporter（CLI 管理工具）")
    L("")
    L("已安装 ✅")
    L("")
    try:
        r = subprocess.run(["mcporter", "list"], capture_output=True, text=True, timeout=10)
        lines = [l for l in r.stdout.splitlines() if l.strip() and not l.startswith("#")]
        if lines:
            L("~~~")
            for l in lines[:30]:
                L(l)
            L("~~~")
    except:
        L("（无法获取列表）")
    L("")

# 各平台 MCP 配置汇总
for platform, cfg_file in [
    ("OpenClaw", os.path.join(home, ".qclaw-oversea/config/mcp.json")),
    ("Claude Code", os.path.join(home, ".claude/settings.json")),
    ("Cursor", os.path.join(home, ".cursor/settings.json")),
]:
    if os.path.isfile(cfg_file):
        L(f"### {platform} MCP")
        L("")
        L(f"`{cfg_file}`")
        L("")
        try:
            data = json.load(open(cfg_file))
            servers = []
            if "mcpServers" in data:
                servers = list(data["mcpServers"].keys())
            elif isinstance(data, dict):
                servers = list(data.keys())
            if servers:
                for s in servers:
                    L(f"  - {s}")
                mcp_found = True
            else:
                L("  （无 MCP 服务器）")
        except:
            L("  （无法解析）")
        L("")

if not mcp_found:
    L("> 未发现全局 MCP 配置")
    L("")

# ── Obsidian Vault ─────────────────────────────────────
section("📓 Obsidian Vault")

obsidian_found = False
vault_patterns = [
    os.path.join(home, "Obsidian*"),
    os.path.join(home, "Library/CloudStorage/*/Obsidian*"),
    os.path.join(home, "Dropbox/Obsidian*"),
]
for pattern in vault_patterns:
    for vault in glob.glob(pattern):
        if not os.path.isdir(vault):
            continue
        obsidian_found = True
        md_count = sum(1 for _ in glob.glob(os.path.join(vault, "**/*.md"), recursive=True))
        L(f"- `{vault}` — {md_count} 个笔记")
        # Subdirs
        for sub in sorted(os.listdir(vault)):
            sub_path = os.path.join(vault, sub)
            if not os.path.isdir(sub_path):
                continue
            sub_count = sum(1 for _ in glob.glob(os.path.join(sub_path, "**/*.md"), recursive=True))
            if sub_count > 0:
                L(f"  - {sub}/ ({sub_count} 笔记)")
        L("")

if not obsidian_found:
    L("> 未发现 Obsidian Vault")
    L("")

# ── 开发工具版本 ───────────────────────────────────────
section("⚙️ 开发工具版本")

tools = ["git", "python3", "node", "go", "rustc", "docker", "brew", "mcporter", "code", "claude", "cursor"]
L("| 工具 | 版本 |")
L("|------|------|")
for tool in tools:
    path = run_cmd(["which", tool])
    if path:
        try:
            r = subprocess.run([tool, "--version"], capture_output=True, text=True, timeout=5)
            ver = r.stdout.splitlines()[0].strip() if r.stdout else "已安装"
        except:
            ver = "已安装"
        L(f"| `{tool}` | {ver} |")

L("")

# ── TaskBrain 执行上下文摘要 ────────────────────────────
section("🧠 TaskBrain 执行上下文摘要")
L("**推荐默认执行路径：**")
L("")
L("| 任务类型 | 推荐 Agent | 执行路径 |")
L("|---------|-----------|---------|")
L("| 代码任务 / 项目开发 | Claude Code / OpenClaw | 项目根目录 |")
L("| 系统脚本 / 终端任务 | OpenClaw | `~` |")
L("| 笔记 / 知识管理 | Obsidian + AI | Obsidian Vault |")
L("| 多工具协作任务 | OpenClaw（TaskBrain Skill）| `paths-context.md` 同目录 |")
L("")
L("---")
L(f"*由 scan-paths.sh v3 生成 | {timestamp}*")

# 写入文件
with open(output_file, "w", encoding="utf-8") as f:
    f.write("\n".join(out))

print("OK", file=__import__("sys").stderr)
PYEOF

exitcode=$?

if [ "$exitcode" -eq 0 ]; then
    echo "✅ 生成完成: ${OUTPUT}"
    echo "   AI 执行 Task 前请先读取此文件"
else
    echo "❌ 生成失败（exit code: ${exitcode}）"
    exit 1
fi

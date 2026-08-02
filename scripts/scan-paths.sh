#!/usr/bin/env bash
#===============================================
# scan-paths.sh
# 扫描电脑关键路径，生成上下文文件
# 用法: ./scan-paths.sh
# 输出: paths-context.md
# AI 执行任务前，先读这个文件
#===============================================

set -euo pipefail

OUTPUT="${1:-paths-context.md}"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M")

echo "🔍 扫描关键路径..."

{
    echo "# 💻 系统关键路径"
    echo ""
    echo "> 生成时间：${TIMESTAMP}"
    echo "> 本文件由 scan-paths.sh 自动生成"
    echo "> **AI 执行 Task 前，请先阅读此文件了解系统环境**"
    echo ""

    # ── 操作系统 ──────────────────────────────────────────
    echo "## 系统信息"
    echo ""
    echo "- OS: $(uname -s) $(uname -m)"
    echo "- 用户目录: ${HOME}"
    echo "- Shell: ${SHELL##*/}"
    echo ""

    # ── 目录结构 ──────────────────────────────────────────
    echo "## 主目录结构"
    echo ""
    echo "### \`~\`（用户目录）"
    echo ""
    for d in Desktop Documents Downloads Music Movies Pictures; do
        if [ -d "${HOME}/${d}" ]; then
            count=$(find "${HOME}/${d}" -maxdepth 1 -type f 2>/dev/null | wc -l | tr -d ' ')
            echo "- \`~/${d}/\` — ${count} 个文件"
        fi
    done
    echo ""

    # ── 代码/项目目录 ─────────────────────────────────────
    echo "### 代码和项目"
    echo ""
    for dir in "${HOME}"/projects "${HOME}"/code "${HOME}"/workspace "${HOME}"/dev; do
        if [ -d "$dir" ]; then
            echo "📁 **${dir}/**"
            for sub in "$dir"/*/; do
                [ -d "$sub" ] || continue
                name=$(basename "$sub")
                count=$(find "$sub" -maxdepth 1 -type f 2>/dev/null | wc -l | tr -d ' ')
                echo "  - ${name}/ — ${count} 个文件"
            done
            echo ""
        fi
    done

    # ── Obsidian Vault ─────────────────────────────────────
    echo "### Obsidian Vault"
    echo ""
    for vault in "${HOME}"/Obsidian*/"${HOME}"/Library/CloudStorage/*/Obsidian* "${HOME}"/Library/CloudStorage/*/Obsidian*; do
        if [ -d "$vault" ]; then
            count=$(find "$vault" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
            echo "- \`${vault}\` — ${count} 个笔记"
            echo "  子目录:"
            for sub in "$vault"/*/; do
                [ -d "$sub" ] || continue
                name=$(basename "$sub")
                nc=$(find "$sub" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
                [ "$nc" -gt 0 ] && echo "    - ${name}/ (${nc} 笔记)"
            done
            echo ""
        fi
    done

    # ── AI/Agent 配置 ─────────────────────────────────────
    echo "### AI Agent 配置"
    echo ""
    for dir in "${HOME}"/.claude "${HOME}"/.qclaw* "${HOME}"/.cursor "${HOME}"/.openai; do
        if [ -d "$dir" ]; then
            echo "- \`${dir}/\`"
            ls "$dir" 2>/dev/null | head -10 | sed 's/^/    /'
            echo ""
        fi
    done

    # ── 开发工具 ──────────────────────────────────────────
    echo "### 开发工具版本"
    echo ""
    for cmd in git python3 node go rustc docker brew; do
        if command -v "$cmd" &>/dev/null; then
            ver=$($cmd --version 2>/dev/null | head -1 || echo "已安装")
            echo "- \`${cmd}\`: ${ver}"
        fi
    done
    echo ""

    echo "---"
    echo "*由 scan-paths.sh 生成 | ${TIMESTAMP}*"

} > "$OUTPUT"

echo "✅ 生成完成: ${OUTPUT}"
echo "   AI 执行前请先读取此文件"

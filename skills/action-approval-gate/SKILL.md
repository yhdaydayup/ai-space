---
name: action-approval-gate
description: >-
  Mandatory approval gate before modifying code or configuration files,
  running state-changing git commands, committing, or pushing. Always loaded at
  session boot via ai-space.
---

# 操作审批门禁（Action Approval Gate）

本规则为开机默认加载的最高优先级操作门禁。除非当前轮次已有用户的**明确指令或明确同意**，否则严禁擅自执行以下操作：

## 必须先获明确同意的操作

1. **修改代码与配置**
   - 修改、新建、删除、重命名任何业务代码、脚本、工程配置、CLI/Agent 配置文件（如 `.cursor/`、`.claude/`、`.botmux/`、Podfile、BUILD 等）。
   - 未获同意前：只能只读排查、分析根因、给出拟改方案或 diff 预览，等待用户确认后再落盘。

2. **执行写操作 / 改状态的 Git 命令、提交与推送**
   - 禁止未经明确同意执行 `git commit`、`git push`（含 `--force` / `--force-with-lease`）。
   - 禁止未经明确同意执行任何改变工作区、索引、分支、历史或远端交互的 `git` 命令（包括但不限于 `git add`、`git checkout`、`git switch`、`git reset`、`git restore`、`git clean`、`git stash`、`git merge`、`git rebase`、`git cherry-pick`、`git pull`、`git fetch`、`git tag`、`git branch -d/-D/-m`）。
   - 纯只读排查命令（如 `git status`、`git log`、`git diff`、`git show`、`git ls-tree`、`git rev-parse`、`git branch` 查看）允许在排查问题时直接执行。
   - **知识仓维护例外**：`~/.ai-space/` 个人知识仓按 `ai-space` 协议的「拍板即写入」与 `write-lock.sh` 维护流程自动写入并本地 commit，但向外部导出 `wiki-ext/` 或向远端 push 仍必须先获用户明确同意。

## 执行约定

- **单次授权原则**：用户上一轮对某次修改或某次提交的同意，不等于对后续新一轮修改、提交或推送的默认授权；每次执行前均须有针对当次操作的明确指令或同意。
- **合并指令拆解**：除非用户在同一句话里明确说了「改完直接提交并推送」，否则「改一下 X」只代表授权修改代码，改完后必须停在工作区，等待用户验证并明确下达「提交 / 推送」指令。

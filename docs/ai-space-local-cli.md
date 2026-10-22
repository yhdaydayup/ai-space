# 给本机 CLI 机器人：安装并遵守个人 AI 知识仓（L1）

你是这台机器上、由本地 CLI 绑定的机器人身份。按本文件做完即可。

你是**本机 Agent**，不是 Aime / Mira，也不是给同事的共享会话。查知识走 `wiki/`，不要只用 `wiki-ext/`。

L1 只管知识仓。你自己的产品 skill、绑定身份、其它 CLI 凭证，L1 不管，不要卸、不要改。

## 两样东西

- 协议（L1）真本：`~/ai_workSpace/ai-space/skills/ai-space/`（GitHub `yhdaydayup/ai-space`）。`~/.cursor/skills/ai-space` 应软链到这里，不要再拷一份正文
- 知识仓：`~/.ai-space/`（已经是 git，工作副本必须是这个路径）

## 步骤

### 1. 确认知识仓在

```bash
test -f "$HOME/.ai-space/wiki/index.md" && echo OK
```

没有 `OK` → 停，告诉用户仓不在 `~/.ai-space/`，不要另建目录。

### 2. 把 L1 链进你这条 CLI 会扫描的 skill 目录

真本不要拷贝。先弄清你这条 CLI 的用户级 skill 路径，再软链过去。常见：

| CLI | 链到 |
| --- | --- |
| Claude Code | `~/.agents/skills/ai-space` → 真本；再 `~/.claude/skills/ai-space` → `~/.agents/skills/ai-space` |
| Cursor Agent / Cursor | 真本已在 `~/.cursor/skills/ai-space/`，不必再拷 |
| 其它 CLI | 该产品文档里的 user skills 目录，目录名固定 `ai-space` |

```bash
# Claude Code 示例
mkdir -p "$HOME/.agents/skills" "$HOME/.claude/skills"
ln -sfn "$HOME/.cursor/skills/ai-space" "$HOME/.agents/skills/ai-space"
ln -sfn "$HOME/.agents/skills/ai-space" "$HOME/.claude/skills/ai-space"
test -f "$HOME/.claude/skills/ai-space/SKILL.md" && echo SKILL_OK
```

你环境里已有的其它 skill 软链（如 `bytedcli`、`lark-cli`）不要删。

### 3. 写开机钩子

在**你这条 CLI 每次新会话都会读到的用户级规则**里加一段（文件已存在则只追加，不要覆盖原文）。没有就新建。

```markdown
# Boot

会话开始必须 Read 个人 AI 知识仓 L1 的 SKILL.md 并遵守。
路径：先 `~/.cursor/skills/ai-space/SKILL.md`；若你已按上一步软链，也可用该 CLI skill 目录下的 `ai-space/SKILL.md`。
知识仓在 `~/.ai-space/`。不要整仓灌入上下文。
```

Claude Code 写在 `~/.claude/CLAUDE.md`。其它 CLI 用它自己的用户规则文件（如 `AGENTS.md`、`CLAUDE.md`、rules），不要为每个产品发明一份不同的 L1 正文。

### 4. 本会话立刻开机

1. Read `~/.cursor/skills/ai-space/SKILL.md`（或你刚链上的那份，内容应相同）
2. 确认 `~/.ai-space/` 存在
3. 不要把 `wiki/`、`sources/` 整仓灌进上下文。开机先不打开 `references/maintain.md`。不要读已废止的 `skills/LOADOUT.md` 当门禁。开机到此不是会话结束。可复述的结论当轮写入 wiki。这次选中的妙记、PRD、导出或一段原文，写成 sources 里的普通文件。没选中的对话不进 sources，也不要扫描全部会话。

查知识：`~/.ai-space/wiki/index.md` → 只打开点到的那一页。

写入走 L1 `references/maintain.md`。先 `~/.cursor/skills/ai-space/scripts/write-lock.sh prepare`，commit 完 `release`。无 remote 不 pull。脏仓由拿到锁的人恢复提交，不要全员停写。

### 5. 向用户汇报

- L1 软链（或已有真本）是否可读到 `SKILL.md`
- 开机钩子写在哪个文件、新建还是追加
- 本会话是否已经 Read 了 `SKILL.md`

## 禁止

- 拷贝 L1 成另一份正文（会分叉）
- `cp -R` 知识仓，或把仓放到别的路径
- 把整仓灌进上下文；顺着 `sources/` 软链接读整棵目标树
- 未确认就把 `wiki-ext/` 交给外部，或把整仓 push 到别人能 clone 的网
- 为对外改 `wiki/` 里的真名
- 用仓内 `LOADOUT.md` 决定加载哪些产品 skill

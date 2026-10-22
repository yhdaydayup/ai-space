# 初始化（新机器 / 新 Agent）

1. 把本 L1 包装进当前产品的 skill 路径。不要按产品拆 `init-cursor.md`。真本是本 git 仓里的 `skills/ai-space/`；各 CLI 用软链，不要再拷一份正文。
   - 安装：`npx skills add yhdaydayup/ai-space@ai-space -g -y`，或 clone 后软链（见仓库 README）
   - Cursor：`~/.cursor/skills/ai-space/` → 真本
   - Claude Code：`~/.agents/skills/ai-space` → Cursor 那条（或直接 → 真本）；`~/.claude/skills/ai-space` → `~/.agents/skills/ai-space`
2. 知识仓工作副本必须是 `~/.ai-space/`，且该目录是 git。它不是本 skill 仓。
   - 已有 remote：clone 到这个路径。
   - 没有仓：建目录骨架（`sources/` `wiki/` `wiki-ext/` 及三份 index），`git init`。
   - 写入用本包 `scripts/write-lock.sh`。无 remote 不 pull。
3. 不要在初始化时扫描或导入全部对话。仓里已有的会话软链可以不管；要读的内容应是之前 agent 选中后写下的普通文件。
4. 写开机钩子（本机文件，不进本 skill 仓）：新对话开始 Read 本包 `SKILL.md`。Cursor 用 alwaysApply 规则指向该文件。
5. 给外部 Agent 不要 clone `~/.ai-space/`，只导出已确认的 `wiki-ext/`。知识仓若有 remote，只能是只有你能读的仓库。

# ai-space

个人 AI 知识仓协议（L1）。告诉 Agent：`~/.ai-space/` 怎么查、怎么写、怎么外发。不管产品 skill 怎么加载。

知识仓本身（`~/.ai-space/` 里的 wiki / sources）**不在这个仓库**。本仓只有协议。

## Install

包已发布：https://www.npmjs.com/package/@wangjoey666/ai-space

### npm

```bash
npm install -g @wangjoey666/ai-space --registry https://registry.npmjs.org/
```

装完把包目录软链进各 CLI 的 skill 路径（不要拷正文）：

```bash
PKG="$(npm root -g --registry https://registry.npmjs.org/)/@wangjoey666/ai-space"
ln -sfn "$PKG" ~/.cursor/skills/ai-space
ln -sfn ~/.cursor/skills/ai-space ~/.agents/skills/ai-space
ln -sfn ~/.agents/skills/ai-space ~/.claude/skills/ai-space
```

或：`npx skillpm install @wangjoey666/ai-space`

### GitHub

```bash
npx skills add yhdaydayup/ai-space@ai-space -g -y
```

或 clone 后软链：

```bash
git clone https://github.com/yhdaydayup/ai-space.git ~/ai_workSpace/ai-space
ln -sfn ~/ai_workSpace/ai-space/skills/ai-space ~/.cursor/skills/ai-space
ln -sfn ~/.cursor/skills/ai-space ~/.agents/skills/ai-space
ln -sfn ~/.agents/skills/ai-space ~/.claude/skills/ai-space
```

装好后新会话 Read `SKILL.md`。Cursor 若要 alwaysApply 开机必读，在**本机** `~/.cursor/rules` 自行留钩子——不进本仓库。Claude 的 `CLAUDE.md` 同样本机自留。

## 两份东西

| | 这份仓库 | 知识仓 |
| --- | --- | --- |
| 是什么 | L1 skill。开机和做法 | sources / wiki / wiki-ext |
| 路径 | 本仓库 `skills/ai-space/` | `~/.ai-space/` |
| 在不在 GitHub | 在 | 不在，只留本机 |

## 仓库结构

```
ai-space/
├── README.md
├── LICENSE
├── docs/
│   ├── ai-space.html          # 给人看的规格备份。活规格在本机 ~/ai_workSpace/ai-space.html
│   └── ai-space-local-cli.md  # 本机 CLI 机器人投喂稿备份
└── skills/
    └── ai-space/
        ├── SKILL.md           # 开机必读。决定什么时候写，不管产品 skill
        ├── package.json       # npm 包 @wangjoey666/ai-space
        ├── references/
        │   ├── init.md        # 新机器
        │   └── maintain.md    # 做法：先拿锁、分类、写入、巡检、对外副本
        └── scripts/
            └── write-lock.sh
```

## 本机开发

- 协议正文改 `skills/ai-space/`。给人看的规格同时改 `docs/` 和本机活规格，两份保持一致
- `~/.cursor/skills/ai-space` → 本仓库 `skills/ai-space/`
- 改完 `git commit && git push`
- 发 npm：`cd skills/ai-space && npm version patch && npm publish --access public --registry https://registry.npmjs.org/`

## 不要放进本仓

- `~/.ai-space/` 知识仓
- 密钥、私钥、`.env`
- 各 CLI 的开机钩子文件

# ai-space

个人 AI 知识仓协议（L1）。告诉 Agent：`~/.ai-space/` 怎么查、怎么写、怎么外发。不管产品 skill 怎么加载。

知识仓本身（`~/.ai-space/` 里的 wiki / sources）**不在这个仓库**。本仓只有协议。

## Install

GitHub（推荐，和 yehong-ai-preference 同一套）：

```bash
npx skills add yhdaydayup/ai-space@ai-space -g -y
```

或 clone 后软链，不要再拷一份正文：

```bash
git clone https://github.com/yhdaydayup/ai-space.git ~/ai_workSpace/ai-space
ln -sfn ~/ai_workSpace/ai-space/skills/ai-space ~/.cursor/skills/ai-space
ln -sfn ~/.cursor/skills/ai-space ~/.agents/skills/ai-space
ln -sfn ~/.agents/skills/ai-space ~/.claude/skills/ai-space
```

npm / skillpm（semver）：

```bash
npx skillpm install @wangjoey666/ai-space
# 或
npm install -g @wangjoey666/ai-space --registry https://registry.npmjs.org/
```

装好后新会话 Read `SKILL.md`。Cursor 若要 alwaysApply 开机必读，在**本机** `~/.cursor/rules` 自行留钩子——不进本仓库。Claude 的 `CLAUDE.md` 同样本机自留。

## 仓库结构

```
ai-space/
├── README.md
├── LICENSE
└── skills/
    └── ai-space/
        ├── SKILL.md           # 开机必读
        ├── package.json       # npm 包 @wangjoey666/ai-space
        ├── references/
        │   ├── init.md
        │   └── maintain.md
        └── scripts/
            └── write-lock.sh
```

## 本机开发

- 正文只改：`skills/ai-space/`
- `~/.cursor/skills/ai-space` → 本仓库该目录
- 改完 `git commit && git push`
- 发 npm：`cd skills/ai-space && npm version patch && npm publish --access public --registry https://registry.npmjs.org/`

## 不要放进本仓

- `~/.ai-space/` 知识仓
- 密钥、私钥、`.env`
- 各 CLI 的开机钩子文件

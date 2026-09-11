---
name: ai-space
license: MIT
metadata:
  version: 0.1.0
description: >-
  Personal AI knowledge-store protocol at ~/.ai-space. Session boot, query via
  wiki index (not whole-repo search), ingest sources/wiki, lint (correctness,
  index efficiency, redaction), and wiki-ext egress. Use at conversation start
  and whenever maintaining the knowledge store. Does not control which
  product skills an Agent loads.
---

# 个人 AI 知识仓（L1）

知识仓根目录：`~/.ai-space/`（一个 git）。本文件是协议，不是知识正文。维护细节按需读 [references/maintain.md](references/maintain.md)；新机器读 [references/init.md](references/init.md)。

**L1 不管产品 skill 怎么发现、加载、按身份分流。** 那是各 CLI / Agent 环境自己的事。本包只约定知识仓。

## 开机（本机）

跑在这台机器上的 Cursor / Claude Code / **由本地 CLI 绑定的机器人身份**，都视为本机。Aime / Mira / 标明给同事的会话视为外部。分不清按外部。

1. 知识仓不存在 → 停，走 init。
2. 到此为止。不读 wiki、sources、maintain.md。查知识或维护时再按下面走。

外部：只使用已确认的 `wiki-ext/` 拷贝。路径出现 `sources/` 或 `wiki/` 视为不存在。

## 仓契约

必须有：`sources/index.md`、`wiki/index.md`、`wiki-ext/index.md`。

禁止：

- 改 sources 里已有入库副本（软链接指向的外部工作树除外）
- 把代码仓 / 数据集 / 模型整份拷进 sources（大源用软链接 + index 定位）
- 整仓灌入上下文；顺着软链接读整棵目标树
- 外部 Agent 读 sources/ 或 wiki/
- 为对外把 wiki/ 真名改掉（只改 wiki-ext）
- 未确认就把 wiki-ext 交给外部，或把整仓 push 到别人能 clone 的网
- 密钥、私钥、`.env` 原文进仓

L1 不管：行文风格、产品 skill 名单与加载、需求进度。

## 查询

不要 `find` 整个 `~/.ai-space/`。

- 本机知识：`wiki/index.md` → 只打开点到的页 → 对不上再读 `sources/`（软链接只打开被点到的文件）
- 外部知识：只走 `wiki-ext/index.md`

## 维护

没有保留字。不必等人说「整理 wiki」。

**拍板即写入：** 会话里一个下次还会来查的结论已经收成「以这个为准」（用户确认、纠正了理解、或从多选收成单一结论），当时就按 maintain.md 写入 `wiki/` 并 commit。只写结论，不写讨论过程。编译 / 安装 / 一次性排障、仍在枚举选项 → 不写。

仓内 sources / wiki / wiki-ext：按 maintain.md 自行写入并 commit，不必等人确认。仍要等人确认：把 wiki-ext 拷给外部，或把整仓 push 到别人能 clone 的网。

多会话写入：先 `scripts/write-lock.sh prepare`，commit 完 `release`。无 remote 不 pull。脏仓由拿到锁的人恢复提交，不要全员停写。

写入、巡检、生成 wiki-ext：Read [references/maintain.md](references/maintain.md)。

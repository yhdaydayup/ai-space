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
2. 仓在：不要把 wiki / sources 整仓灌进上下文。开机先不打开 maintain.md。
3. 开机到此不是会话结束。这一轮若有可复述的结论，或有你决定留下的原料，当轮 Read maintain.md 并写入，再继续答。不要等用户说「记下来」。留什么、用哪种形态，只看下面「留下什么」。

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

## 留下什么

当轮 agent 决定留不留。没选中的不写，也不要扫描全部会话。

| 留下什么 | 去哪 | 形态 |
| --- | --- | --- |
| 可复述的结论 | `wiki/` | 普通文件。可改，能并进已有页就并 |
| 选中的小原料：妙记、一页 PRD、摘录、小导出 | `sources/` | 普通文件，只增不改 |
| 选中的大源：代码仓、数据集、模型、大目录、大体积导出 | `sources/` | 软链。index 写本机路径；有 git 就写 URL。禁止整份拷进仓 |
| 选中的线上文档 | `sources/index.md` | 只记 URL，不下载 |
| 没选中 | 不写 | — |

对话里值得留的句子按小原料写。不要把会话目录整棵链进来。仓里已有的会话软链是遗留：不修，不再新增。源文件可以没有对应的 wiki 页。

## 查询

不要 `find` 整个 `~/.ai-space/`。

- 本机知识：`wiki/index.md` → 只打开点到的页 → 对不上再读 `sources/`（软链接只打开被点到的文件）
- 外部知识：只走 `wiki-ext/index.md`

## 维护

没有保留字。不必等人说「整理 wiki」。

**拍板即写入：** 会话里一个下次还会来查的结论已经收成「以这个为准」（用户确认、纠正了理解、或从多选收成单一结论），当时就按 maintain.md 写入 `wiki/` 并 commit。只写结论，不写讨论过程。不写：编译、安装、rebase、日志、当场会过期的数值，以及还没分出对错的选项。排障里已经能复述的原因、所有权、字段、门禁、生命周期，照写。

原料按「留下什么」收。小原料不必等拍板。结论进 wiki，不把整段对话抄进去。

仓内 sources / wiki / wiki-ext：按 maintain.md 自行写入并 commit，不必等人确认。仍要等人确认：把 wiki-ext 拷给外部，或把整仓 push 到别人能 clone 的网。

多会话写入：先 `scripts/write-lock.sh prepare`，commit 完 `release`。无 remote 不 pull。脏仓由拿到锁的人恢复提交，不要全员停写。

写入、巡检、生成 wiki-ext：Read [references/maintain.md](references/maintain.md)。

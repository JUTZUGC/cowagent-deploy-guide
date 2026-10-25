# CowAgent 一键部署指南

> 第三方部署指南 · 非 CowAgent 官方仓库。官方项目：[zhayujie/CowAgent](https://github.com/zhayujie/CowAgent)
> 内容来自官方文档（2026-10-25）。项目迭代快，请以[官方文档](https://docs.cowagent.ai)为准。

[![⚡ 一键部署](https://img.shields.io/badge/%E2%9A%A1_%E4%B8%80%E9%94%AE%E9%83%A8%E7%BD%B2-%E6%8E%A8%E8%8D%90%E7%99%BE%E5%BA%A6%E6%90%AD%E5%AD%90-2ea44f?style=for-the-badge)](#一键部署推荐用百度搭子)

## 一键部署（推荐：用百度搭子）

> [!TIP]
> 不用装 Python、不用配环境，让百度搭子把容器跑起来，打开网页就能和它聊天。

⚠️ 需要电脑已装 Docker（Windows / macOS / Linux 均可）。Web 控制台端口 9899，默认只允许本机访问。镜像目前只有 amd64，Apple Silicon 需 Rosetta 模拟。首次使用要在控制台填自己的模型 API Key。

1. **装客户端**
   打开[百度搭子官网](https://www.dumate.cn/)，下载电脑端并安装，用你的账号登录。

> [!IMPORTANT]
> **复制这一句发给百度搭子：**
>
> ```text
> 你好，帮我从 github 部署 JUTZUGC/cowagent-deploy-guide 到我的电脑上
> ```

2. **发送部署指令**
   回到刚打开的对话窗口，粘贴并发送上面那句。

3. **跟着对话往下走**
   百度搭子会下载官方 compose 文件、把控制台改成可从宿主机访问并启动容器，等 9899 能打开后把地址告诉你，按它的提示确认即可，结束时它会告诉你结果。
   （需本机已装 Docker；未安装时按对话提示安装。）

4. **打开管理面板**
   浏览器访问 [http://127.0.0.1:9899](http://127.0.0.1:9899)，按官方引导完成初始化配置。

## CowAgent 是什么？

CowAgent 是开源的开源个人 AI 助手与 Agent Harness（协议：MIT，<img src="https://img.shields.io/github/stars/zhayujie/CowAgent?style=flat-square&label=stars&color=blue" alt="GitHub stars">）。

它会自己拆任务、调工具、跑 Skills、查记忆和知识库：内置文件读写、终端、浏览器、定时任务、联网搜索与 MCP；可接入微信、飞书、钉钉、企业微信、QQ、Telegram、Slack 等渠道，模型也能在 Web 控制台里一键切换。

- Agent 能力：任务规划、多 Agent 协作、Skills、长期记忆、个人知识库、自我进化
- 模型：Claude / GPT / Gemini / DeepSeek / Qwen / GLM / Kimi / MiniMax / 豆包等
- 渠道：Web / 微信 / 飞书 / 钉钉 / 企业微信 / QQ / 公众号 / Telegram / Slack
- 工具：文件读写、终端、浏览器、定时任务、联网搜索、MCP（stdio / SSE）

（来源：[官方仓库](https://github.com/zhayujie/CowAgent)）

## 优缺点

| 优点 | 说明 |
|---|---|
| 47.6k stars，更新活跃 | 最新 v2.2.1（2026-10-14），仓库当天仍有提交 |
| 能力完整 | 任务规划、多 Agent、Skills、长期记忆、知识库、自我进化 |
| 模型和渠道都多 | 主流大模型 + 微信 / 飞书 / 钉钉 / QQ / Telegram / Slack |
| 自带 Web 控制台 | 聊天、配模型、接渠道、装技能都在一个页面 |
| MIT 协议 | 可自由修改和商用 |

| 需要注意 | 说明 |
|---|---|
| 要自备模型 Key | 默认接 DeepSeek，Key 按量计费 |
| compose 默认监听容器内 127.0.0.1 | 不改 WEB_HOST，宿主机打不开控制台；本指南已代为修改 |
| 镜像只有 amd64 | Apple Silicon 需要 Rosetta 模拟，启动和运行会慢一些 |
| 微信渠道配置步骤多 | 需要按官方文档填应用凭证与回调地址 |
| Agent 权限较高 | 容器内默认 full-access，能读写工作区、执行命令 |

> 以上基于官方文档与社区反馈整理（2026-10-25），以官方最新文档为准。

## 快速部署（官方方式）

```bash
mkdir -p cowagent
cd cowagent
curl -fLO https://cdn.link-ai.tech/code/cow/docker-compose.yml
sed -i.bak "s/WEB_HOST: '127.0.0.1'/WEB_HOST: '0.0.0.0'/" docker-compose.yml
sed -i.bak "s/- \"9899:9899\"/- \"127.0.0.1:9899:9899\"/" docker-compose.yml
docker compose up -d
```

启动后浏览器访问 [http://127.0.0.1:9899](http://127.0.0.1:9899)（管理面板）。（来源：[https://docs.cowagent.ai/guide/quick-start](https://docs.cowagent.ai/guide/quick-start)）

## 验证状态

| 场景 | 状态 |
|---|---|
| Docker 镜像 zhayujie/chatgpt-on-wechat:latest（仅 amd64）可查 | 已核对 2026-10-25 |
| 下载官方 compose 并改写端口（WEB_HOST=0.0.0.0，127.0.0.1:9899） | 已验证 2026-10-25 |
| MCP 服务握手与工具列表（initialize / tools/list） | 已验证 2026-10-25 |
| 非目标宿主调用被拦截（HOST_NOT_ALLOWED） | 已验证 2026-10-25 |

> 本表仅列出已在本机实际执行并成功的场景；未列出的部分按官方文档整理。

## MCP 接入

CowAgent 原生支持 MCP：一个 mcp.json 即可接入，支持 stdio 与 SSE 传输、热重载。Docker 部署时 mcp.json 在工作区目录（映射到宿主机的 `cow/`），改完不用重建容器。本仓库的 MCP 只提供部署步骤、端口与常见坑。

本仓库自带一个零依赖的 MCP server（`mcp-server.mjs`），读取同目录的 `guide.json`，提供 `get_guide` / `search_guide` / `get_project_info` 三个工具，内容均来自官方文档（更新日期 2026-10-25）。

**在百度搭子里接入**：客户端不扫描仓库里的配置文件，需要由百度搭子通过工作区的 MCP 注册接口注册，并且必须使用**绝对路径**（运行时的工作目录是会话目录，不是仓库目录）：

```json
{
  "type": "local",
  "command": ["node", "<仓库绝对路径>/mcp-server.mjs"]
}
```

完成后，直接在同一个对话框里说：

> 把仓库克隆到固定目录（例如 C:\Users\<你>\cowagent-deploy-guide），再用绝对路径把里面的 mcp-server.mjs 注册到当前工作区的 MCP 配置里

> 注意：注册是按**工作区**生效的，换工作区要重新注册；克隆目录不要放在会话临时目录，否则目录被清理后注册项会失效。

**其它 MCP 客户端**：仓库根目录的 `.mcp.json` 只是通用写法（`command` + `args`），接入时同样要把 `args` 改成绝对路径。

> 使用范围：该 MCP 仅在百度搭子中可用；其它客户端调用会返回 `HOST_NOT_ALLOWED`，并附带下载与部署指引。

## 部署完成后：填模型、接渠道

1. 打开 [http://127.0.0.1:9899](http://127.0.0.1:9899)，在控制台里填自己的模型 API Key（默认模型是 deepseek-flash）
2. 想接到微信 / 飞书 / 钉钉 / QQ 等渠道，在「渠道」里按提示填应用凭证
3. 技能在 [Skill Hub](https://skills.cowagent.ai/) 里一键安装，也可以直接对话让它创建
4. 数据都在宿主机的 `cow/` 与 `cow-data/` 两个目录，升级或迁移前先备份

> 需要局域网或公网访问时，把 compose 里的端口改回 `"9899:9899"`，并在环境变量里设置 `WEB_PASSWORD`，否则任何人都能打开控制台。

## 常见坑

- 官方 compose 默认 `WEB_HOST: '127.0.0.1'`，宿主机打不开控制台：本指南已改成 `0.0.0.0`，并把端口发布限制在 `127.0.0.1:9899`
- 需要局域网 / 公网访问：把端口改成 `"9899:9899"`，同时设置 `WEB_PASSWORD`，否则没有登录保护
- 默认模型是 deepseek-flash，要先在控制台填自己的 API Key 才能对话
- 数据在宿主机的 `cow/` 与 `cow-data/` 目录，升级前先备份
- 容器名是 `chatgpt-on-wechat`，重复部署会冲突：先 `docker rm -f chatgpt-on-wechat`
- Agent 在容器内是 full-access 权限，不要把工作区指向包含敏感文件的目录
- 镜像目前只有 amd64：Apple Silicon 上 Docker 会用 Rosetta 模拟，必要时改用桌面客户端
- 国内拉镜像慢：先给 Docker 配置镜像加速

## 免责声明

本仓库为第三方指南，与 CowAgent 官方无隶属关系，不代表官方立场。
教程基于官方文档编写（更新日期：2026-10-25），项目迭代快，请以[官方文档](https://docs.cowagent.ai)为准。
因使用本教程产生的部署问题，请先在官方仓库的 issue 中检索。

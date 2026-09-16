# 自定义 Skills 与工作模式

本仓库集中保存可复用的个人 Skill，以及组合多个 Skill 的上层工作模式。系统预装 Skill 与第三方插件 Skill 不在此仓库维护。

## 分类原则

- 按主要使用场景分类，不按 Skill 的来源目录分类。
- 每个 Skill 保持独立目录，完整保留 `SKILL.md`、`agents/`、`references/`、`scripts/` 与必要资源。
- 名称使用 Skill 元数据中的稳定名称；例如 `jiagou_skill` 以 `godot-game-architecture-std` 保存。
- 跨多个 Skill 的协作流程放在 `workflows/`，项目专属 GDD、SPEC、实现和进度文档留在对应项目仓库。

## Skills

| 分类 | Skills | 适用范围 |
| --- | --- | --- |
| [Creative](skills/creative/) | [`cozy-horror-lowpoly-art-director`](skills/creative/cozy-horror-lowpoly-art-director/SKILL.md)、`game-art-agent`、`game-design-thinking-partner`、`holo-card`、`low-poly-game-asset-generator`、`retro-liminal-ps1-background` | 游戏创意、克制怪谈美术指导、视觉资产与互动卡片 |
| [Godot](skills/godot/) | `ai-gd-code-std`、`crazygames-godot-web-compression`、`godot-ambient-particles`、`godot-button2d-faithful-extraction`、`godot-crt-scanlines`、`godot-elastic-button`、`godot-game-analytics`、`godot-game-architecture-std`、`godot-source-decomposer` | Godot 4 代码、架构、组件、埋点、UI 复用、保真与屏幕适配环境粒子、圆形屏幕转场与 CrazyGames 网页包 Brotli 压缩；拆解保留源默认值并可开放局部参数，仅在依赖未解析、边界歧义或宿主契约变化时询问，组件资产采用相对路径以支持任意安装目录 |
| [UI](skills/ui/) | `ui-semantic-lightweight-arcade` | 轻量街机风格与颜色语义 |
| [Engineering](skills/engineering/) | `ad-reward-service`、`ai-py-code-std`、`systematic-debugging`、`test-driven-development`、`verification-before-completion`、`receiving-code-review`、`requesting-code-review` | 广告奖励服务、Python 规范、调试、测试、验证与评审 |
| [Project](skills/project/) | `game-dev-change-log-maintainer`、`project-change-log` | 项目开发变更记录 |
| [Knowledge](skills/knowledge/) | `ima-skill`、`weread-skills` | 笔记、知识库与微信读书 |
| [Codex](skills/codex/) | `create-rule`、`writing-skills` | Codex 规则与 Skill 编写维护 |
| [Data](skills/data/) | `xlsx-authoring` | `.xlsx` 文件创作与验证 |
| [Web](skills/web/) | `oil-motion` | 网页交互与运动设计 |

## Workflows

| 工作模式 | 用途 |
| --- | --- |
| [GameStudio GPT Companion](workflows/game-studio-companion/README.md) | 组织游戏设计、UI 与工程变更记录；ChatGPT 负责设计/产品思考，Codex 负责工程执行 |

## 使用与维护

- 将单个 Skill 目录复制或安装到本机技能目录后，工具才能加载它。
- GitHub 上的版本化保存不等于自动安装或自动启用。
- 更新 Skill 时，同时更新其自身文档与根目录的 `CHANGELOG.md`，并保留历史。
- `ai-gd-code-std` 的场景规范包含外部 `.tscn` 与 `%唯一节点` 的参考场景、MCP 创建和独立/宿主双重加载验证要求。

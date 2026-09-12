# 自定义 Skills 与工作模式

本仓库用于集中保存可复用的自定义 Skill，以及组合多个 Skill 的上层工作模式。

## 目录结构

```text
skills/
├── design/
│   └── game-design-thinking-partner/
├── ui/
│   └── ui-semantic-lightweight-arcade/
└── development/
    └── project-change-log/

workflows/
└── game-studio-companion/
```

## Skills

| 分类 | Skill | 用途 |
| --- | --- | --- |
| Design | [game-design-thinking-partner](skills/design/game-design-thinking-partner/SKILL.md) | 核心体验、玩法发散与收束、一次一个问题的 Grill |
| UI | [ui-semantic-lightweight-arcade](skills/ui/ui-semantic-lightweight-arcade/SKILL.md) | 猫咪增量项目的视觉、颜色语义与 Godot 布局 |
| Development | [project-change-log](skills/development/project-change-log/SKILL.md) | 修改后续写项目记录，保留验证与维护信息 |

## Workflows

| 工作模式 | 用途 |
| --- | --- |
| [GameStudio GPT Companion](workflows/game-studio-companion/README.md) | 作为游戏开发上层协作模式，组织设计、UI 与工程变更记录 Skill；ChatGPT 负责设计/产品思考，Codex 负责工程执行 |

## 约定

- 单一、可复用的能力放在 `skills/<category>/<skill-name>/`。
- 跨多个 Skill 的协作流程放在 `workflows/`，不伪装成单一 Skill。
- 每个 Skill 保留自己的 `SKILL.md`、`agents/` 与必要的 `references/`。
- 项目自身的 GDD、SPEC、开发进度和实现文档应与项目仓库绑定，不存进本 Skill 仓库。
- 将 Skill 文件夹上传到 GitHub只代表版本化保存；具体工具仍需显式加载或安装这些 Skill 才会执行其规则。

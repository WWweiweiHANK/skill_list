# 自定义 Skills

本仓库保存以下三个自定义 Skill 的重建优化版。2026-09-06 未取得此前 Skill 原文件；本版依据用户已确认的对话要求整理，不是对旧文件的逐行修改。

| Skill | 用途 |
| --- | --- |
| [game-design-thinking-partner](skills/game-design-thinking-partner/SKILL.md) | 核心体验、玩法发散与收束、一次一个问题的 Grill |
| [ui-semantic-lightweight-arcade](skills/ui-semantic-lightweight-arcade/SKILL.md) | 猫咪增量项目的视觉、颜色语义与 Godot 布局 |
| [project-change-log](skills/project-change-log/SKILL.md) | 修改后续写项目记录，保留验证与维护信息 |

每个文件夹包含 SKILL.md 与 agents/openai.yaml；UI 的历史布局单独放在 references 中按需读取。将完整 Skill 文件夹导入支持该格式的工具；仅上传 GitHub 不会让任意工具自动加载它们。

本次优化：明确触发范围；隔离项目规范；区分候选建议与已确认规则；估时说明假设；日志区分实际完成、待办和未验证；不把文件保存误报成远程上传。保留既有 LICENSE 与 .gitattributes。

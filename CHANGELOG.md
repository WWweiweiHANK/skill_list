# Changelog

## 2026-09-13 — 统一整理本机自定义 Skills

- 目的：将仅存在于本机技能目录的个人 Skills 纳入 `skill_list` 版本控制，并统一分类。
- 变化：新增 18 个此前未纳入仓库的个人 Skill；将既有 Creative 与 Project Skills 迁移到按用途命名的目录；将远程新增的 `retro-liminal-ps1-background` 一并归入 Creative；保留原有 Skill 内容和工作模式。
- 文件：`skills/`、`README.md`。
- 验证：已检查每个顶级 Skill 目录均含 `SKILL.md`，并确认 Git 识别既有文件为重命名而非删除重建。
- 维护：系统预装与第三方插件 Skills 刻意不纳入本仓库；`low-poly-game-asset-generator` 仍仅在仓库中，尚未安装到本机技能目录。

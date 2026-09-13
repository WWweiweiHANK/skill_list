# Changelog

## 2026-09-13 — 新增 Godot 视觉组件 Skills

- 新增：`godot-elastic-button`，提供四态 StyleBox、悬停缩放、按压弹性反馈、统一信号与可选本地音效的可复用 Godot 4 按钮资产。
- 新增：`godot-crt-scanlines`，提供扫描线与轻度屏幕弯曲的无脚本 Godot 4 全屏覆盖层及参数化 shader。
- 归档：两个 Skill 均归入 `skills/godot/`，保留其组件资产、提取记录和静态契约校验脚本；未纳入缓存或源项目专属资源。

## 2026-09-13 — 统一整理本机自定义 Skills

- 目的：将仅存在于本机技能目录的个人 Skills 纳入 `skill_list` 版本控制，并统一分类。
- 变化：新增 18 个此前未纳入仓库的个人 Skill；将既有 Creative 与 Project Skills 迁移到按用途命名的目录；将远程新增的 `retro-liminal-ps1-background` 一并归入 Creative；保留原有 Skill 内容和工作模式。
- 文件：`skills/`、`README.md`。
- 验证：已检查每个顶级 Skill 目录均含 `SKILL.md`，并确认 Git 识别既有文件为重命名而非删除重建。
- 维护：系统预装与第三方插件 Skills 刻意不纳入本仓库；`low-poly-game-asset-generator` 仍仅在仓库中，尚未安装到本机技能目录。

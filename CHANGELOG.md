# Changelog

## 2026-09-13 — 新增源代码保真 Button2D 提取 Skill

- 新增：`godot-button2d-faithful-extraction`，提供源 `button_2d` 的场景、四态 StyleBox、标签阴影与字体、`Juice2D` 弹簧反馈、悬停/点击音效及原始信号接口。
- 兼容：场景内资源改为相对路径；源二进制 Theme 改写为等效的可移植 `.tres` Theme，并保留 `Match 7.ttf` 与中文 `NotoSansSC.ttf` 本地化分支。
- 契约：明确要求复用单一 `DampedSprings` 自动加载、提供 `InputManager.using_gamepad()` 宿主契约、配置 `Sound` 音频总线，不再以额外反馈节点或隐藏替代实现掩盖依赖。
- 验证：通过清单检查、注册表架构验证，并在 Godot 4.6.3 的独立临时项目中加载和按压场景。

## 2026-09-13 — 强化 Godot 保真拆解门槛

- 调整：`godot-source-decomposer` 在任何提取前必须生成视觉保真清单，覆盖 Theme、字体、排版、StyleBox、资源、边框、阴影、音效、动画、坐标、偏移、锚点、尺寸与视口约束。
- 调整：新增强制选择门槛。用户必须在 `faithful reconstruction` 与 `generalized redesign` 之间作出选择；未选择前提取状态为 `blocked`，不得删除、替换或以通用默认值补全源视觉与依赖。
- 验证：新增并运行拆解 Skill 的保真门槛静态检查。

## 2026-09-13 — 修复 Godot 组件资源路径可移植性

- 修复：`godot-elastic-button` 的 `弹性按钮.tscn` 改用同级相对路径引用两个脚本，不再依赖固定的 `res://ui/弹性按钮/` 目录；使用说明和静态契约测试同步更新。
- 调整：`godot-source-decomposer` 明确要求：随场景分发的依赖必须相对于场景文件引用，`res://` 仅用于已声明的宿主项目依赖；新增对应的规则验证脚本。
- 归档：已同步两套完整 Skill 目录至 `skills/godot/`。

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

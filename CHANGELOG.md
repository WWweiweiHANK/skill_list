# Changelog

## 2026-09-21 — 归档三套 UI 设计 Skills

- 新增：`skills/ui/finesse-ui/`，来自 `mouse-lin/finesse-skill`（`5050b6c`），包含完整参考资料、示例、检测脚本和 OpenAI 元数据。
- 新增：`skills/ui/taste-skill/`，来自 `Leonxlnx/taste-skill`（`5217fb4`），安装名称为 `design-taste-frontend`，用于落地页、作品集与现有页面改版。
- 新增：`skills/ui/impeccable/`，来自 `pbakaus/impeccable`（`f2c7051`），包含设计、审查、无障碍、响应式、动效与收尾命令所需的完整参考资料和脚本。
- 安装：三套 Skill 同步安装到本机 Codex 技能目录；本次按用户明确要求归档第三方 Skill。

## 2026-09-17 — 新增 Cozy Horror Lowpoly Art Director

- 新增：`skills/creative/cozy-horror-lowpoly-art-director/`，提供夜班图书馆与小型营业空间的低多边形 cozy horror 美术方向、审图、Grill、角色与环境指导。
- 基调：保留 DAY 1 的 80% 舒适 / 15% 孤独 / 5% 不安、暖室内与冷雨夜、构图和灯光优先、引擎内修正优先及与 GameArtAgent 的职责划分。
- 格式：采用 `name` / `description` 标准入口及 `agents/openai.yaml` 显示配置；原讨论已完整取回的第 1–30 节放入 `references/art-direction.md`，入口整理验收条件并明确文字/静帧审查的证据边界。

## 2026-09-15 — 增强 Godot 环境粒子与屏幕适配拆解

- 调整：`godot-ambient-particles` 新增 `设置屏幕雪花`，在保留保真尘埃默认参数的同时，按视口扩大发射和可见区域、按面积换算密度，并提高雪花尺寸与透明度；公开屏幕适配、密度与可见度控制。
- 调整：`godot-source-decomposer` 将粒子发射覆盖、密度、尺寸、透明度和 z 序纳入视觉清单；任何宣称覆盖宿主屏幕的效果必须给出并验证视口适配契约。
- 验证：环境粒子独立 Godot 夹具覆盖保真尘埃、雪花与屏幕雪花；两套 Skill 的静态契约检查均已通过。

## 2026-09-15 — 提取 Godot 圆形屏幕转场组件

- 新增：`godot-source-decomposer` 的 `screen-transition/circle-iris` 变体，保留源项目的 CanvasLayer 层级 16、黑色硬边圆形 Shader、1.25 阈值、0.5 秒 Quad 收拢/展开、透明输入拦截层及 `Transition.wav` 音效。
- 参数：公开遮罩颜色、圆心、收拢/展开时长与缓动、阈值倍率、输入阻断、音效开关和音频总线；默认值仍与源项目一致。
- 接口：提供收拢/展开信号与方法；作为 Autoload 时可调用场景转场，普通宿主也可仅使用视觉层与信号。
- 验证：静态资产契约、组件注册表与提取记录检查、Godot 4.6.3 独立宿主加载均已通过。

## 2026-09-15 — 优化 Godot 视觉拆解决策门槛

- 调整：`godot-source-decomposer` 将“保真默认值 + 可选参数化”确认为同一交付方式，不再把它错误拆成保真重建与通用重设计的二选一。
- 决策：只有效果边界存在多个可信候选、关键资源/服务未解析，或宿主系统的输入、音频、换场等集成契约会改变时，才向用户发起澄清。
- 验证：新增依赖门槛回归测试，并同步更新既有可移植性检查。

## 2026-09-15 — 新增 Godot 保真环境粒子 Skill

- 新增：`godot-ambient-particles`，从源标题场景提取可移植的 50 粒子尘埃组件，保留方形贴图、加法混合、透明度渐变、尺寸曲线、300×100 发射域、3 秒生命周期及原始速度、重力和扰动数值。
- 参数：在不改变默认保真尘埃外观的前提下，向 Inspector 暴露粒子密度、风向、风力、速度倍率、大小倍率与颜色；雪花以明确命名的非保真预设提供。
- 验证：静态资产契约与 Godot 4.6.3 临时宿主加载测试均已通过。

## 2026-09-14 — 强化 Godot 外部场景与预期失败约束

- 调整：`ai-gd-code-std` 新增外部 `.tscn` 使用 `%唯一节点` 时的参考场景比对、Godot MCP/编辑器创建、ASCII 资源 ID 与独立/宿主双重加载验证要求。
- 调整：明确场景解析、资源 ID、编译、空节点与运行期错误属于实现错误，不能作为测试驱动开发中的有效“预期失败”。
- 归档：已同步本机 `ai-gd-code-std` 的完整 Skill 文档至 `skills/godot/ai-gd-code-std/`。

## 2026-09-13 — 新增 Godot 游戏打点 Skill

- 新增：`godot-game-analytics`，用于 Godot 4 游戏的事件总线埋点、低频领域事件、高频行为聚合、离线批量上报和 HTTP 传输审查。
- 约束：强调只记录已完成的业务结果；公共字段不可被业务数据覆盖；客户端不存储私钥、SSH 凭据或长期密钥，服务端承担校验、限流与反滥用。

## 2026-09-13 — 新增通用奖励广告服务 Skill

- 新增：`ad-reward-service`，用于将激励/插屏广告与业务奖励解耦，不绑定 CrazyGames、Godot 或任何特定广告平台。
- 契约：业务层只派发带上下文的广告意图；适配器仅归一化完整播放、取消、失败和不可用结果；只有完整播放分支能结算奖励。
- 生命周期：要求广告服务统一处理并发保护、暂停与音频状态快照/恢复、过期回调过滤，以及开发和正式环境各自明确的不可用策略。
- 验证：提供完成、取消/失败、重复请求和不可用策略的可观察测试清单，并要求发布前进行平台预览或真机完整观看/提前关闭验证。

## 2026-09-13 — 新增 CrazyGames Godot 包体压缩 Skill

- 新增：`crazygames-godot-web-compression`，用于为 CrazyGames 准备 Godot HTML5 导出包；以 Brotli 11 压缩 `index.js`、`index.pck` 与 `index.wasm`，并在删除源文件前逐项解压比对验证。
- 加载器：仅改写压缩资源 URL，并要求 `index.pck`、`index.wasm` 的 fetch 重定向幂等且不触及 Godot 原有启动逻辑。
- 部署：明确要求验证 CrazyGames 上传/运行时对 `.br` 直链、MIME 类型与 `Content-Encoding: br` 的处理，再发布清理后的包体。

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

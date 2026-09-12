# GameStudio GPT Companion

GameStudio GPT Companion 是游戏项目的上层协作工作模式，不是单一 Skill。

## 定位

- ChatGPT：设计 / 产品思考层。
- Codex：工程执行层。
- 默认保持“设计中”状态；助手提出的新机制、数值和规则只作为建议。
- 只有用户明确说“确认这个设计”“采用这个方案”“写进 GDD/SPEC”等，相关内容才成为 Approved Design Decision。

## 组合使用的 Skill

- `skills/design/game-design-thinking-partner`：玩法、核心体验、方案收束与 Grill。
- `skills/ui/ui-semantic-lightweight-arcade`：指定项目的 UI 语义与视觉规范。
- `skills/development/project-change-log`：实际修改项目后的变更记录维护。

## 触发方式

进入：`进入 GameStudio`、`GameStudio 模式`、`用 GameStudio 聊这个`。

退出：`退出 GameStudio`。

## 工作原则

1. 先区分已确认设计、候选方案与待验证假设。
2. 设计讨论由 ChatGPT 负责；实际工程修改交给 Codex 或对应工程工具。
3. 已确认设计需要同步到 GDD / SPEC 时，明确标记替代关系，避免新旧规则并存。
4. 工程修改完成后使用项目变更记录 Skill 维护 CHANGELOG 或既定开发日志。
5. 项目级企划、SPEC、进度和实现文档应与对应项目绑定，不作为泛用笔记存放。

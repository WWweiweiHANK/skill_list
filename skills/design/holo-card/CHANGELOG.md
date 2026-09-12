# 变更记录

## 2026-09-11

### 目的

修复照片主体在光栅卡流程中被重绘、裁断或静默当作已完成的问题，并为成品增加显式视觉验收门槛。

### 修改

- 照片主体默认使用 `source.png` 的原始 RGB 像素，只允许 Alpha 蒙版决定透明度。
- 新增 `apply-source-alpha`，校验蒙版尺寸、灰阶格式和前后景取值后生成主体层。
- `assemble` 改为输出 `assembled_unreviewed`，必须执行 `approve` 并记录审核说明后才进入 `completed`。
- 主体提示词明确禁止生成式重画，结构层必须从最终主体 Alpha 推导。
- 所有文本模板读写显式使用 UTF-8，避免 Windows GBK 组装失败。
- 新增原图像素保真与显式批准回归测试，并更新既有组装测试。

### 验证

- `python -m unittest discover -s tests -v`
- `node tests/test_motion.mjs`
- `quick_validate.py` 技能结构校验
- 新照片成品在本地浏览器验证景深端点、辉光端点、翻面及控制台错误。

### 已知限制

- 自动 Alpha 仍需黑底、白底和最终卡面三次视觉审核；复杂遮挡或前景/背景近色时不能跳过人工批准。
- 当前技能目录不是 Git 仓库，因此本次只更新本地技能与变更记录，没有可提交或推送的远程仓库。

### 真透明硬门禁与猫咪卡片 v2

- 目的：阻止 RGB 棋盘格预览被误称为透明 PNG，并防止已审核图层在组装前被静默替换。
- 变化：`add` 返回可审计的 `transparency_evidence`；无 Alpha 的角色/UI 候选只能进入 `needs_alpha_mask`；`assemble` 重新计算每层哈希并拒绝任何导入后变化；技能明确区分 `assembled_unreviewed` 与 `completed`。
- 文件：`scripts/native.py` 增加透明度证据与图层完整性门禁；`tests/test_native.py` 增加无 Alpha 证据和篡改拒绝测试；`SKILL.md` 增加真透明硬门禁流程。
- 验证：新增测试已完成 RED→GREEN；独立代理复测确认 RGB 棋盘格不能被称为透明抠图或直接组装；猫咪卡片 v2 已检查黑白底、景深 -3/0/+3、辉光 0/0.15/3、正反面及浏览器控制台。
- 待办／维护：蒙版形状质量仍需视觉审核；本地 `approve` 的审核说明依赖执行者如实记录。

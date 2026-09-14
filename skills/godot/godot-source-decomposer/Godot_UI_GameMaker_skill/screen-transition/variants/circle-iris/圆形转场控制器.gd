extends CanvasLayer


# 此组件复刻源项目的黑色硬边圆形收拢与展开；可作为 Autoload 管理场景切换，也可由宿主仅调用视觉方法。


signal 收拢完成
signal 展开完成


## 保留源项目的纯黑遮罩默认色，可按需改为任意不透明或半透明颜色。
@export var 遮罩颜色: Color = Color.BLACK
## 使用归一化 UV 指定圆形中心；默认值为源项目的屏幕中心。
@export var 圆心: Vector2 = Vector2(0.5, 0.5)
## 收拢阶段的默认时长，源项目数值为 0.5 秒。
@export var 收拢时长: float = 0.5
## 展开阶段的默认时长，源项目数值为 0.5 秒。
@export var 展开时长: float = 0.5
## 保留源 Shader 的 1.25 遮罩阈值倍率；降低可减小边角残留。
@export var 遮罩阈值倍率: float = 1.25
## 控制收拢阶段的缓动曲线，默认保留 Quad In。
@export var 收拢缓动: Tween.EaseType = Tween.EASE_IN
## 控制展开阶段的缓动曲线，默认保留 Quad Out。
@export var 展开缓动: Tween.EaseType = Tween.EASE_OUT
## 转场期间是否显示透明拦截层，防止底层 UI 接收点击。
@export var 是否阻断输入: bool = true
## 是否在每个半程开始时播放源转场音效。
@export var 是否播放音效: bool = true
## 保留源项目的 Sound 总线名称；没有该总线时由宿主改为现有总线。
@export var 音频总线: StringName = &"Sound"
## 绑定承载圆形 Shader 的 Sprite2D，以支持外部场景实例化。
@export var 圆形遮罩节点: Sprite2D
## 绑定透明的全屏输入拦截层，以支持外部场景实例化。
@export var 输入遮罩节点: ColorRect
## 绑定可选转场音效播放器，以支持外部场景实例化。
@export var 转场音效节点: AudioStreamPlayer


var 正在转场: bool = false
var 圆形半径: float = 1.0


# 初始化源默认半径、输入拦截层，并让承载面按当前视口铺满。
func _ready() -> void:
	_调整遮罩尺寸()
	_设置输入拦截(false)
	get_viewport().size_changed.connect(_调整遮罩尺寸)


# 每帧将 Tween 改写的半径和公开参数同步至 Shader。
func _process(_帧间隔: float) -> void:
	_应用遮罩参数()


# 播放从全屏开口收拢为全黑的源项目默认动画。
func 播放收拢() -> void:
	正在转场 = true
	圆形半径 = 1.0
	_设置输入拦截(true)
	_播放转场音效()
	_创建半径补间(0.0, 收拢时长, 收拢缓动, _当收拢结束)


# 播放从全黑展开为全屏开口的源项目默认动画。
func 播放展开() -> void:
	圆形半径 = 0.0
	_设置输入拦截(true)
	_播放转场音效()
	_创建半径补间(1.0, 展开时长, 展开缓动, _当展开结束)


# 在本组件作为 Autoload 时执行与源项目相同的收拢、切场、缓冲和展开时序。
func 执行场景转场(目标场景路径: String) -> void:
	if 正在转场:
		return
	播放收拢()
	await get_tree().create_timer(收拢时长 * 1.25).timeout
	var 切换结果: Error = get_tree().change_scene_to_file(目标场景路径)
	if 切换结果 != OK:
		正在转场 = false
		_设置输入拦截(false)
		return
	await get_tree().create_timer(展开时长 * 1.25).timeout
	播放展开()


# 返回当前半径，供宿主在不访问内部节点时观察转场状态。
func 获取圆形半径() -> float:
	return 圆形半径


# 将公开遮罩参数写入 ShaderMaterial，并同步音频总线。
func _应用遮罩参数() -> void:
	if 圆形遮罩节点 == null:
		return
	var 遮罩材质: ShaderMaterial = 圆形遮罩节点.material as ShaderMaterial
	if 遮罩材质 == null:
		return
	遮罩材质.set_shader_parameter("tint_color", 遮罩颜色)
	遮罩材质.set_shader_parameter("center", 圆心)
	遮罩材质.set_shader_parameter("radius", 圆形半径)
	遮罩材质.set_shader_parameter("threshold_multiplier", 遮罩阈值倍率)
	if 转场音效节点 != null:
		转场音效节点.bus = 音频总线


# 依据源 128×128 Sprite 的尺寸与当前视口计算全屏缩放，1920×1080 时得到原值 15×8.4375。
func _调整遮罩尺寸() -> void:
	if 圆形遮罩节点 == null:
		return
	圆形遮罩节点.scale = get_viewport().get_visible_rect().size / Vector2(128.0, 128.0)


# 使用源项目的 Quad 过渡曲线创建半径补间，并在完成时通知对应阶段。
func _创建半径补间(目标半径: float, 时长: float, 缓动: Tween.EaseType, 完成回调: Callable) -> void:
	var 新补间: Tween = create_tween()
	新补间.tween_property(self, "圆形半径", 目标半径, maxf(0.0, 时长)).set_trans(Tween.TRANS_QUAD).set_ease(缓动)
	新补间.finished.connect(完成回调)


# 在音效节点、音效开关均可用时播放一次半程反馈。
func _播放转场音效() -> void:
	if 是否播放音效 and 转场音效节点 != null:
		转场音效节点.play()


# 根据公开配置显示或隐藏透明输入拦截层。
func _设置输入拦截(是否显示: bool) -> void:
	if 输入遮罩节点 != null:
		输入遮罩节点.visible = 是否阻断输入 and 是否显示


# 收拢补间结束后向宿主广播可安全切换内容的时机。
func _当收拢结束() -> void:
	收拢完成.emit()


# 展开补间结束后恢复输入，并结束当前转场状态。
func _当展开结束() -> void:
	_设置输入拦截(false)
	正在转场 = false
	展开完成.emit()

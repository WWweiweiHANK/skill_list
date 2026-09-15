@tool
extends Node2D


enum 效果预设 { 保真尘埃, 雪花 }


## 选择保真尘埃或明确标记为变体的雪花预设。
@export var 效果类型: 效果预设 = 效果预设.保真尘埃
## 控制同一时刻可见的粒子数量；保真尘埃默认值为 50。
@export var 粒子密度: int = 50
## 决定重力移动的二维方向；保真尘埃默认向下。
@export var 风向: Vector2 = Vector2.DOWN
## 将风向转换为重力时使用的强度；保真尘埃默认值为 20。
@export var 风力: float = 20.0
## 等比例调整源效果的 10–20 初始速度范围。
@export var 速度倍率: float = 1.0
## 等比例调整源效果的 0.5–0.75 尺寸范围。
@export var 大小倍率: float = 1.0
## 在保留源透明度渐变的前提下为粒子着色。
@export var 粒子颜色: Color = Color.WHITE
## 启用后按当前视口扩大发射域和可见区域；默认关闭以保持源尘埃的固定范围。
@export var 是否适配屏幕: bool = false
## 将按视口面积计算后的粒子数量再乘以此倍率，用于控制降雪密度。
@export var 屏幕密度倍率: float = 1.0
## 在保留渐变节奏的前提下放大透明度，最高不超过完全不透明。
@export var 粒子可见度倍率: float = 1.0
## 绑定场景中的 GPUParticles2D；使用显式路径可保证外部实例也能正常解析。
@export var 粒子节点: GPUParticles2D


# 场景加载后将当前导出参数同步到粒子处理材质。
func _ready() -> void:
	get_viewport().size_changed.connect(_当视口尺寸变化)
	应用参数()


# 切换预设并写入相应的起始参数；雪花数值属于明确的非保真变体。
func 设置预设(新效果类型: 效果预设) -> void:
	效果类型 = 新效果类型
	if 效果类型 == 效果预设.保真尘埃:
		粒子密度 = 50
		风向 = Vector2.DOWN
		风力 = 20.0
		速度倍率 = 1.0
		大小倍率 = 1.0
		粒子颜色 = Color.WHITE
	else:
		粒子密度 = 36
		风向 = Vector2(0.15, 1.0)
		风力 = 14.0
		速度倍率 = 0.65
		大小倍率 = 0.8
		粒子颜色 = Color(0.88, 0.94, 1.0, 1.0)
	应用参数()


# 选择面向菜单全屏展示的雪花配置，并保留所有参数供 Inspector 继续微调。
func 设置屏幕雪花() -> void:
	设置预设(效果预设.雪花)
	是否适配屏幕 = true
	屏幕密度倍率 = 1.0
	大小倍率 = 2.5
	粒子可见度倍率 = 1.75
	应用参数()


# 将公开参数映射到源粒子材质的密度、重力、速度、大小与颜色通道。
func 应用参数() -> void:
	if 粒子节点 == null:
		return
	var 粒子材质: ParticleProcessMaterial = 粒子节点.process_material as ParticleProcessMaterial
	if 粒子材质 == null:
		return
	var 实际粒子密度: int = 粒子密度
	if 是否适配屏幕:
		var 视口尺寸: Vector2 = get_viewport().get_visible_rect().size
		粒子材质.emission_box_extents = Vector3(视口尺寸.x * 0.5, 视口尺寸.y * 0.5, 1.0)
		粒子节点.visibility_rect = Rect2(-视口尺寸 * 0.5 - Vector2(64.0, 64.0), 视口尺寸 + Vector2(128.0, 128.0))
		var 面积倍率: float = 视口尺寸.x * 视口尺寸.y / 120000.0
		实际粒子密度 = roundi(粒子密度 * 面积倍率 * 屏幕密度倍率)
	else:
		粒子材质.emission_box_extents = Vector3(300.0, 100.0, 1.0)
		粒子节点.visibility_rect = Rect2(-400.0, -400.0, 800.0, 800.0)
	粒子节点.amount = max(1, 实际粒子密度)
	var 实际风向: Vector2 = 风向.normalized() if not is_zero_approx(风向.length_squared()) else Vector2.DOWN
	粒子材质.gravity = Vector3(实际风向.x * 风力, 实际风向.y * 风力, 0.0)
	粒子材质.initial_velocity_min = 10.0 * 速度倍率
	粒子材质.initial_velocity_max = 20.0 * 速度倍率
	粒子材质.scale_min = 0.5 * 大小倍率
	粒子材质.scale_max = 0.75 * 大小倍率
	var 颜色渐变贴图: GradientTexture1D = 粒子材质.color_initial_ramp as GradientTexture1D
	if 颜色渐变贴图 == null:
		return
	颜色渐变贴图.gradient.colors = PackedColorArray([
		Color(粒子颜色.r, 粒子颜色.g, 粒子颜色.b, minf(1.0, 0.427451 * 粒子颜色.a * 粒子可见度倍率)),
		Color(粒子颜色.r, 粒子颜色.g, 粒子颜色.b, minf(1.0, 0.160784 * 粒子颜色.a * 粒子可见度倍率)),
	])


# 提供受控粒子节点引用，供宿主在不依赖场景相对路径时读取运行状态。
func 获取粒子() -> GPUParticles2D:
	return 粒子节点


# 仅在启用屏幕适配时响应窗口或视口尺寸变化，避免改写保真尘埃的源参数。
func _当视口尺寸变化() -> void:
	if 是否适配屏幕:
		应用参数()

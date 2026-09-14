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
## 绑定场景中的 GPUParticles2D；使用显式路径可保证外部实例也能正常解析。
@export var 粒子节点: GPUParticles2D


# 场景加载后将当前导出参数同步到粒子处理材质。
func _ready() -> void:
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


# 将公开参数映射到源粒子材质的密度、重力、速度、大小与颜色通道。
func 应用参数() -> void:
	if 粒子节点 == null:
		return
	粒子节点.amount = max(1, 粒子密度)
	var 粒子材质: ParticleProcessMaterial = 粒子节点.process_material as ParticleProcessMaterial
	if 粒子材质 == null:
		return
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
		Color(粒子颜色.r, 粒子颜色.g, 粒子颜色.b, 0.427451 * 粒子颜色.a),
		Color(粒子颜色.r, 粒子颜色.g, 粒子颜色.b, 0.160784 * 粒子颜色.a),
	])


# 提供受控粒子节点引用，供宿主在不依赖场景相对路径时读取运行状态。
func 获取粒子() -> GPUParticles2D:
	return 粒子节点

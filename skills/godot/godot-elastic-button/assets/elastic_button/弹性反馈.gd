extends Node


@export_range(1.0, 1.2, 0.01) var 悬停倍率: float = 1.04
@export_range(0.7, 1.0, 0.01) var 按压倍率: float = 0.93
@export_range(0.05, 0.5, 0.01) var 恢复时长: float = 0.22


var _目标节点: Control
var _基础缩放: Vector2 = Vector2.ONE
var _缩放补间: Tween
var _鼠标位于按钮上方: bool = false


# 注入受动画控制的根节点，并记录其初始缩放以避免覆盖布局缩放。
func 设置目标节点(目标节点: Control) -> void:
	_目标节点 = 目标节点
	_基础缩放 = 目标节点.scale


# 将根节点平滑放大，提供不改变按钮尺寸约束的悬停反馈。
func 播放悬停反馈() -> void:
	_鼠标位于按钮上方 = true
	_播放缩放(_基础缩放 * 悬停倍率, 0.12, Tween.TRANS_QUAD, Tween.EASE_OUT)


# 恢复基础缩放，保持离开按钮后的布局尺寸稳定。
func 播放离开反馈() -> void:
	_鼠标位于按钮上方 = false
	_播放缩放(_基础缩放, 0.12, Tween.TRANS_QUAD, Tween.EASE_OUT)


# 先短暂压缩，再以弹性曲线恢复为悬停或基础缩放。
func 播放按压反馈() -> void:
	if _目标节点 == null:
		return
	_终止当前补间()
	_缩放补间 = create_tween()
	_缩放补间.tween_property(_目标节点, "scale", _基础缩放 * 按压倍率, 0.06).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	var 恢复缩放: Vector2 = _基础缩放 * 悬停倍率 if _鼠标位于按钮上方 else _基础缩放
	_缩放补间.tween_property(_目标节点, "scale", 恢复缩放, 恢复时长).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)


# 中断旧动画，防止快速重复输入叠加多个缩放补间。
func _终止当前补间() -> void:
	if _缩放补间 != null and _缩放补间.is_running():
		_缩放补间.kill()


# 以单一入口创建缩放补间，确保所有状态切换都会清理前一帧动画。
func _播放缩放(目标缩放: Vector2, 持续时间: float, 过渡类型: Tween.TransitionType, 缓动类型: Tween.EaseType) -> void:
	if _目标节点 == null:
		return
	_终止当前补间()
	_缩放补间 = create_tween()
	_缩放补间.tween_property(_目标节点, "scale", 目标缩放, 持续时间).set_trans(过渡类型).set_ease(缓动类型)

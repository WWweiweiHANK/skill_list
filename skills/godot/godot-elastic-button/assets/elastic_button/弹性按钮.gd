class_name 弹性按钮
extends Control


signal 按钮已按下
signal 鼠标已进入
signal 鼠标已离开


## 显示在按钮中央的文本；宿主可通过设置文本方法在运行时安全更新。
@export_multiline var 按钮文本: String = "按钮"
## 点击后是否立即禁用按钮，适合提交、确认等单次操作。
@export var 是否点击后禁用: bool = false
## 是否禁用原生 Button 输入与视觉状态。
@export var 是否禁用: bool = false
## 用于正常状态的背景颜色，悬停与按压状态会从此色自动派生。
@export var 默认颜色: Color = Color("0071bd")
## 用于禁用状态的背景颜色。
@export var 禁用颜色: Color = Color("404040")
## 四态 StyleBox 共用的边框颜色。
@export var 边框颜色: Color = Color.WHITE
## 四态 StyleBox 共用的边框宽度。
@export_range(0.0, 12.0, 1.0) var 边框宽度: float = 2.0
## 正常状态 StyleBox 的投影颜色。
@export var 阴影颜色: Color = Color(0.0, 0.0, 0.0, 0.5)
## 正常状态 StyleBox 的投影尺寸。
@export_range(0.0, 16.0, 1.0) var 阴影尺寸: float = 4.0
## 正常状态 StyleBox 的投影偏移。
@export var 阴影偏移: Vector2 = Vector2(4.0, 4.0)
## 可选悬停音效；未设置时不播放声音。
@export var 悬停音效: AudioStream
## 可选点击音效；未设置时不播放声音。
@export var 点击音效: AudioStream


@onready var 按钮: Button = %按钮
@onready var 标签: Label = %标签
@onready var 弹性反馈: Node = %弹性反馈
@onready var 悬停播放器: AudioStreamPlayer = %悬停播放器
@onready var 点击播放器: AudioStreamPlayer = %点击播放器


# 初始化文本、四态样式、局部反馈目标与可选音效，避免依赖全局单例。
func _ready() -> void:
	标签.text = 按钮文本
	弹性反馈.设置目标节点(self)
	悬停播放器.stream = 悬停音效
	点击播放器.stream = 点击音效
	_刷新状态样式()
	设置禁用状态(是否禁用)


# 更新按钮文案，供本地化或运行时状态变化调用。
func 设置文本(新文本: String) -> void:
	按钮文本 = 新文本
	标签.text = 新文本


# 设置禁用状态，并在禁用时将缩放恢复到基础值。
func 设置禁用状态(新禁用状态: bool) -> void:
	是否禁用 = 新禁用状态
	按钮.disabled = 新禁用状态
	if 新禁用状态:
		弹性反馈.播放离开反馈()


# 为当前按钮应用默认、悬停、按压与禁用四态颜色及边框投影。
func _刷新状态样式() -> void:
	_设置样式盒("normal", 默认颜色, 阴影尺寸, 阴影偏移)
	_设置样式盒("hover", 默认颜色.lightened(0.25), 阴影尺寸, 阴影偏移)
	_设置样式盒("pressed", 默认颜色.darkened(0.25), 0.0, Vector2.ZERO)
	_设置样式盒("disabled", 禁用颜色, 0.0, Vector2.ZERO)


# 复制并写入目标状态的 StyleBox，避免多个按钮实例共享并互相污染样式资源。
func _设置样式盒(状态名称: StringName, 背景颜色: Color, 新阴影尺寸: float, 新阴影偏移: Vector2) -> void:
	var 原始样式盒: StyleBox = 按钮.get_theme_stylebox(状态名称)
	var 样式盒: StyleBoxFlat = 原始样式盒.duplicate() as StyleBoxFlat
	if 样式盒 == null:
		return
	样式盒.bg_color = 背景颜色
	样式盒.border_color = 边框颜色
	样式盒.border_width_left = int(边框宽度)
	样式盒.border_width_top = int(边框宽度)
	样式盒.border_width_right = int(边框宽度)
	样式盒.border_width_bottom = int(边框宽度)
	样式盒.shadow_color = 阴影颜色
	样式盒.shadow_size = int(新阴影尺寸)
	样式盒.shadow_offset = 新阴影偏移
	按钮.add_theme_stylebox_override(状态名称, 样式盒)


# 响应原生按压：播放本地反馈、按需禁用，并向拥有者发布统一信号。
func _当按钮按下() -> void:
	弹性反馈.播放按压反馈()
	if 点击播放器.stream != null:
		点击播放器.play()
	if 是否点击后禁用:
		设置禁用状态(true)
	按钮已按下.emit()


# 响应鼠标进入：播放可选音效与轻量缩放反馈，并向拥有者发布信号。
func _当鼠标进入() -> void:
	if 是否禁用:
		return
	弹性反馈.播放悬停反馈()
	if 悬停播放器.stream != null:
		悬停播放器.play()
	鼠标已进入.emit()


# 响应鼠标离开：恢复缩放，并向拥有者发布信号。
func _当鼠标离开() -> void:
	弹性反馈.播放离开反馈()
	鼠标已离开.emit()

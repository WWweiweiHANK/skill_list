extends Node


# 校验保真按钮可在独立工程中加载，并保留源布局和主题字体。
func _ready() -> void:
	await get_tree().process_frame
	var 按钮根节点: Node2D = get_node("Button2D") as Node2D
	var 可视按钮: Button = 按钮根节点.get_node("Button") as Button
	var 标签: Label = 可视按钮.get_node("Label") as Label
	if not 可视按钮.size.is_equal_approx(Vector2(180.0, 81.0)):
		push_error("源按钮尺寸没有保留：%s" % 可视按钮.size)
		get_tree().quit(1)
		return
	if 标签.text != "Button":
		push_error("源按钮文字没有保留：%s" % 标签.text)
		get_tree().quit(1)
		return
	var 主题字体: Font = 标签.get_theme_font("font")
	if 主题字体.resource_path != "res://button/fonts/Match 7.ttf":
		push_error("主题字体没有从组件目录加载：%s" % 主题字体.resource_path)
		get_tree().quit(1)
		return
	按钮根节点.press()
	print("faithful Button2D fixture verified")
	get_tree().quit()

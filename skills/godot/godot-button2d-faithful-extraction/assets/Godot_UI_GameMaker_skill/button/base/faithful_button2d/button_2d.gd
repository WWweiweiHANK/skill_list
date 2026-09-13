@tool
extends Node2D

signal pressed
signal mouse_entered
signal mouse_exited

@export_multiline var button_text: = "Button"
@export var disable_after_click: = false
@export var disabled: = false
@export var adjust_to_label_size: = false
@export var normal_color: = Color("0071bd")
@export var disabled_color: = Color("404040")
@export var border_color: = Color("ffffff")
@export var border_width: = 0.0
@export var shadow_color: = Color("000000", 0.5)
@export var shadow_size: = 0.0
@export var shadow_offset: = Vector2(2, 2)

@onready var button = $Button
@onready var label = $Button / Label
@onready var juice = $Juice
@onready var hover_sfx = $Hover
@onready var click_sfx = $Click

var normal_stylebox: StyleBox
var hover_stylebox: StyleBox
var pressed_stylebox: StyleBox
var disabled_stylebox: StyleBox

var is_mouse_over: = false
var should_update_style: = false

func _ready():
	if Engine.is_editor_hint():
		return

	var stylebox = button.get_theme_stylebox("normal")
	stylebox.shadow_color = shadow_color
	stylebox.shadow_size = shadow_size
	stylebox.shadow_offset = shadow_offset
	stylebox.border_width_left = border_width
	stylebox.border_width_top = border_width
	stylebox.border_width_right = border_width
	stylebox.border_width_bottom = border_width

	normal_stylebox = stylebox
	hover_stylebox = stylebox.duplicate()
	pressed_stylebox = stylebox.duplicate()
	disabled_stylebox = stylebox.duplicate()

	button.add_theme_stylebox_override("hover", hover_stylebox)
	button.add_theme_stylebox_override("pressed", pressed_stylebox)
	button.add_theme_stylebox_override("disabled", disabled_stylebox)

	if not Engine.is_editor_hint():
		update_button_style()

func _process(_delta):
	if not Engine.is_editor_hint() and should_update_style and visible:
		update_button_style()

	if adjust_to_label_size:
		button.custom_minimum_size = label.size
		label.text = " " + tr(button_text) + " "
	else:
		label.text = button_text

	button.disabled = disabled
	button.position = - button.size / 2

func update_button_style():
	should_update_style = false
	normal_stylebox.bg_color = normal_color
	hover_stylebox.bg_color = normal_color.lightened(0.25)
	pressed_stylebox.bg_color = normal_color.darkened(0.25)
	disabled_stylebox.bg_color = disabled_color

	normal_stylebox.border_color = border_color
	hover_stylebox.border_color = border_color
	pressed_stylebox.border_color = border_color
	disabled_stylebox.border_color = border_color

func press():
	click_sfx.play()
	juice.twist_random()
	juice.jiggle()
	if disable_after_click:
		disable()
	pressed.emit()

func enable():
	disabled = false

func disable():
	disabled = true

func spawn():
	juice.spawn()

func grab_focus():
	if InputManager.using_gamepad():
		button.grab_focus()

func _on_button_pressed():
	press()

func _on_button_mouse_entered():
	is_mouse_over = true
	hover_sfx.play()
	mouse_entered.emit()

func _on_button_mouse_exited():
	is_mouse_over = false
	mouse_exited.emit()


func set_border_color(color):
	border_color = color
	should_update_style = true

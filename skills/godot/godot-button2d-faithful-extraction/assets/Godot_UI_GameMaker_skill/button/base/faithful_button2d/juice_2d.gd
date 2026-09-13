extends Node2D
class_name Juice2D

signal initialized

@export var target_node: Node
@export var animate_rotation: = true
@export var animate_scale: = true
@export var animate_spawn: = false
@export var stabilize_scale: = false
@export var twist_animation: DampedSpringData
@export var jiggle_animation: DampedSpringData
@export var spawn_animation: DampedSpringData

@export var base_scale: = Vector2.ONE

var rot_tween: Tween

var jiggle_spring: DampedSpring1D = null
var spawn_spring: DampedSpring1D = null

func _ready():
	initialize.call_deferred()

func initialize():
	if animate_scale: jiggle_spring = DampedSprings.create_spring_1d(jiggle_animation.damping_ratio, jiggle_animation.frequency).rest_at(1.0)
	if animate_spawn: spawn_spring = DampedSprings.create_spring_1d(spawn_animation.damping_ratio, spawn_animation.frequency)

	if animate_scale:
		jiggle_spring.position = 1.0

	initialized.emit()

func _process(_delta):
	if target_node:
		if animate_scale:
			target_node.scale = base_scale * jiggle_spring.position

			if stabilize_scale:
				if target_node.scale.x > 0.995 and target_node.scale.x < 1.005:
					target_node.scale.x = 1.0
				if target_node.scale.y > 0.995 and target_node.scale.y < 1.005:
					target_node.scale.y = 1.0

			if animate_spawn:
				target_node.scale *= Vector2.ONE * (1.0 - spawn_spring.position)
				target_node.rotation_degrees = spawn_animation.intensity * spawn_spring.position

func twist(from: = 1.0, to: = 0.0):
	if animate_rotation:
		if rot_tween:
			rot_tween.kill()
		from *= twist_animation.intensity
		to *= twist_animation.intensity
		rot_tween = create_tween()
		rot_tween.tween_property(target_node, "rotation_degrees", to, 0.2).from(from).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		rot_tween.play()

func twist_random():
	var dir = [-1, 1].pick_random()
	twist(dir, 0.0)

func jiggle(scalar: = 1.0):
	if animate_scale and jiggle_spring != null:
		jiggle_spring.position = 1.0 + jiggle_animation.intensity * scalar

func spawn():
	if animate_spawn:
		spawn_spring.position = 1.0

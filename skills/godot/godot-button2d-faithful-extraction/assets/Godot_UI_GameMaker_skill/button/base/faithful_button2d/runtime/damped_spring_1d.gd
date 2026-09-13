extends RefCounted
class_name DampedSpring1D

var position: float
var velocity: float
var rest_pos: float

var spring_const: float
var damping_const: float

var update_callback: Callable

func _init(damping_ratio, frequency, _rest_pos: float = 0.0):
	position = 0.0
	velocity = 0.0
	rest_pos = _rest_pos
	spring_const = frequency * frequency
	damping_const = 2 * damping_ratio * frequency
	update_callback = Callable()

func update(delta):
	var displacement = position - rest_pos
	var force = - damping_const * velocity - spring_const * displacement
	velocity += force * delta
	position += velocity * delta

	if not update_callback.is_null():
		update_callback.callv([position])

func set_at(_pos: float) -> DampedSpring1D:
	position = _pos
	return self

func rest_at(_rest_pos: float) -> DampedSpring1D:
	rest_pos = _rest_pos
	return self

func callback(_callback: Callable) -> DampedSpring1D:
	update_callback = _callback
	return self

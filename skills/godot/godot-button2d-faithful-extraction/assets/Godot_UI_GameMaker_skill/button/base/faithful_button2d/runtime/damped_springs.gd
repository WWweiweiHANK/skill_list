extends Node

var enabled = true
var springs = []

func clear_springs():
	springs.clear()

func _physics_process(delta):
	if enabled:
		for i in range(springs.size() - 1, -1, -1):
			var spring = springs[i] as WeakRef
			if spring.get_ref():
				spring.get_ref().update(delta)
			else:
				springs.remove_at(i)

func create_spring_1d(damping_ratio: float, frequency: float, rest_pos: float = 0.0) -> DampedSpring1D:
	var spring = DampedSpring1D.new(damping_ratio, frequency, rest_pos)
	springs.append(weakref(spring))
	return spring

extends State
class_name FallState

func _ready() -> void:
	type = "FallState"

func can_exit() -> bool:
	return subject.is_on_floor()

func can_enter() -> bool:
	if subject.is_on_floor():
		return false
	return true

func process()->void:
	super.process()
	subject.velocity += subject.get_gravity() * subject.get_physics_process_delta_time()

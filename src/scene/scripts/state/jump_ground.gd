extends State
class_name  JumpGroundState

func _ready() -> void:
	type = "JumpGroundState"

func can_enter()->bool:
	return subject.get_jump_condition()

func can_exit()->bool:
	return get_runtime_in_sec()<exit_delay_sec

func process()->void:
	super.process()
	subject.velocity.y = subject.JUMP_VELOCITY
	subject.velocity.x = lerpf(subject.velocity.x,0,0.2)

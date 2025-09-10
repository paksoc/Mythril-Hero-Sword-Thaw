extends State
class_name DashState

func _ready() -> void:
	active_animation = "block_high"
	exit_delay_sec = .5

func process()->void:
	super.process()
	var stored_velocity := subject.velocity
	subject.velocity.x = subject.DASH_SPEED*subject.get_direction().x
	
	if get_runtime_in_sec() < exit_delay_sec:
		subject.velocity = stored_velocity
		transition_to(previous_state)
	

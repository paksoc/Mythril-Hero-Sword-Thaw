extends State
class_name  GroundStride


func _ready() -> void:
	type = "GroundStride"

func can_enter() -> bool:
	return (
		abs(subject.get_direction().x) > 0 
		or abs(subject.velocity.x) > 0
		)

func can_exit() -> bool:
	return (
		abs(subject.get_direction().x) == 0
		or !subject.is_on_floor()
		or subject.get_direction().y!=0
		)

func process()->void:
	super.process()
	var subject_dir:float=subject.get_direction().x
	if subject_dir < 0:
		subject.scaleSkinX(-1)
	if subject_dir > 0:
		subject.scaleSkinX(1)
	if subject_dir!=0:
		subject.velocity.x = subject.get_direction().x * subject.SPEED
	else:
		subject.velocity.x = move_toward(subject.velocity.x, 0, subject.SPEED)

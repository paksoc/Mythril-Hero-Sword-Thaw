extends State
class_name GroundIdleState

func _ready() -> void:
	type="GroundIdleState"
	pass

func can_enter() -> bool:
	return (
		subject.is_on_floor()
		and subject.velocity==Vector2.ZERO
		and subject.get_direction()==Vector2.ZERO)

func can_exit() -> bool:
	return (!subject.is_on_floor() or (abs(subject.get_direction())>Vector2.ZERO))

func process()->void:
	super.process()

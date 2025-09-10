extends State
class_name LandingGroundState

@export var airtime_sec:float = 0.5

func _ready() -> void:
	#active_animation = ""
	pass

#func can_exit()->bool:
	#return (get_runtime_in_sec()>exit_delay_sec
	 #or 
		#(!subject.is_on_floor() 
			#and 
			#get_runtime_in_sec() > exit_delay_sec)
		#)
#
#func can_enter() -> bool:
	#if subject.is_on_floor():
		#return true
	#return false

func can_enter() -> bool:
	return subject.is_on_floor() and subject.get_direction() > Vector2.ZERO

func can_exit() -> bool:
	return (get_runtime_in_sec() > exit_delay_sec 
	or (!subject.is_on_floor() 
	and get_runtime_in_sec() > exit_delay_sec))

func process()->void:
	super.process()
	#subject.velocity.x= lerpf(subject.velocity.x,0,.25)
	if subject.is_on_floor():
		if absi(subject.get_direction().x) == 0:
			subject.velocity.x = subject.velocity.x/1.75
	
	

extends CharacterBody2D

#class_name BaseBody2d

const SPEED = 650.0
const JUMP_VELOCITY = -900.0
const DASH_SPEED = 5000

var is_dashing:bool = false

@onready var AnimTree:AnimationTree = $AnimationTree
@onready var AnimTreePlayback : AnimationNodeStateMachinePlayback = (
	$AnimationTree.get("parameters/playback")
	)
@onready var AnimPlaylist:Array = $AnimationTree.get_animation_list()

func _physics_process(delta: float) -> void:
	
	$StateMachine.process(delta)
	
	var direction := Input.get_axis("ui_left", "ui_right")
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if direction<0:
		$Skin.scale.x = -1
	if direction>0:
		$Skin.scale.x = 1
	
	move_x(direction)
	if Input.is_action_just_pressed("ui_text_backspace"):
		dash()
	
	if is_dashing:
		velocity.x = lerpf(velocity.x, 0, .1)
		print(velocity)
		if abs(velocity.x) <50:
			is_dashing = false
		print(is_dashing)
	move_and_slide()

func dash() -> void:
	var direction = $Skin.scale.x
	velocity.x = DASH_SPEED*direction
	is_dashing = true

func move_x(direction) -> void:
	if is_dashing:
		return
	if direction:
		velocity.x = direction * SPEED
		set_animation_to("run_loop")
	else:
		set_animation_to("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)

func set_animation_to(value:String):
	if AnimPlaylist.find(value)<0:
		push_error("THE VALUE %s DOESNT EXIST IN THIS CHARARCTERS LIBRARY"%[value])
		return
	AnimTreePlayback.travel(value)

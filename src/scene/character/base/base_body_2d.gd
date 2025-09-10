extends CharacterBody2D
class_name BaseBody2d

enum controlType {INPUT, AI}

const SPEED = 650.0
const JUMP_VELOCITY = -900.0
const DASH_SPEED = 5000
var is_dashing:bool = false

#@onready var AnimTree:AnimationTree = $AnimationTree
#@onready var AnimTreePlayback : AnimationNodeStateMachinePlayback = (
	#$AnimationTree.get("parameters/playback")
	#)
@onready var AnimPlayer:AnimationPlayer = $AnimationPlayer
@onready var AnimPlaylist:Array = $AnimationPlayer.get_animation_list()

func _physics_process(delta: float) -> void:
	$StateMachine.process()
	move_and_slide()
	#print($StateMachine.active_state.name)

func get_direction(controller:controlType = controlType.INPUT) -> Vector2:
	match controller:
		controlType.INPUT:
			return Vector2(Input.get_axis("Left", "Right"),Input.get_axis("Jump", "Crouch"))
		controlType.AI:
			return Vector2.ZERO
	
	return Vector2.ZERO
	

func should_jump(controller:controlType = controlType.INPUT) -> bool:
	match controller:
		controlType.INPUT:
			return Input.is_action_pressed("Jump") and is_on_floor()
		controlType.AI:
			return false
	return false

func should_dash(controller:controlType = controlType.INPUT) -> bool:
	match controller:
		controlType.INPUT:
			return Input.is_action_just_pressed("Dash")
		controlType.AI:
			return false
	return false

func scaleSkinX(val:int) -> void:
	$Skin.scale.x = val
	

func set_animation_to(value:String):
	if AnimPlaylist.find(value)<0:
		push_error("THE VALUE %s DOESNT EXIST IN THIS CHARARCTERS LIBRARY"%[value])
		return
	print("travel to animation ",value)
	$AnimationPlayer.play(value)
	#AnimTreePlayback.travel(value)
	

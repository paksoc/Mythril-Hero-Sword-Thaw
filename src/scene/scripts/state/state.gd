@icon("res://src/assets/icon/state.svg")
extends Node
class_name State

#--- Editor Settings ---
@export var active_animation: String
@export var exit_delay_sec: float = .0
@export var transition_targets: Array[State] = []
@export var conditions : Array[Condition]

#--- Runtime Constants ---
##string of class_name due to godot having no native get_class_name
var type = "State"
##BaseBody2D controller character 
var subject: BaseBody2d
##State Machine
var FSM: StateMachine

#--- Runtime Variables ---
var active = false
var previous_state: State
var entered_frame: int = -1
var current_frame: int = -1
var exit_frame: int = -1


func _ready() -> void:
	if !FSM or !subject:
		push_error("FSM or subject is not assigned for state: %s" % name)


func process() -> void:
	if !active:
		return
	
	current_frame = Engine.get_physics_frames()
	
	if FSM.DEBUGGING:
		print("\ncan exit from %s? %s" % [name, can_exit()])
		print("%s can transition to %s" % [name, check_available_transitions()])
		print("current state is ", self.name)
	
	if can_exit():
		var next_state = get_next_state()
		if next_state: # check if next_state is not null
			transition_to(next_state)
		#else:
		#   #handle the case where there is no next state.  Do nothing?  Transition to a default state?
	if !active:
		return

func can_enter() -> bool:
	return false

func can_exit() -> bool:
	return false

func get_runtime_in_sec() -> float:
	return (current_frame - entered_frame) / Engine.get_frames_per_second()

func enter() -> void:
	entered_frame = Engine.get_physics_frames()
	if previous_state:
		previous_state.exit()
	active = true
	subject.set_animation_to(active_animation)
	FSM.active_state = self

func check_available_transitions() -> Array:
	var valid_transitions: Array[State] = []
	for state in transition_targets:
		if state and state.can_enter():
			valid_transitions.append(state)
	return valid_transitions

func get_next_state(priorities: Array = []) -> State:
	var available_states: Array[State] = check_available_transitions()
	if available_states.size() <= 0:
		##Returns if no available transitions
		push_error("No Available Transition State for %s" % [self.name])
		return null
	if priorities.size() > 1:
		for p in priorities:
			return available_states.filter(func(state): return state.type == p)[0]
	return available_states[0]

func exit() -> void:
	reset()
	active = false

func transition_to(new_state: State) -> void:
	if FSM == null: # add this check
		push_error("FSM NOT FOUND, cannot transition")
		return
	if new_state:
		new_state.previous_state = self
		new_state.enter()
	else:
		push_error("NULL STATE TRANSITION ERROR")

func reset() -> void:
	exit_frame = Engine.get_physics_frames()
	current_frame = -1
	entered_frame = -1

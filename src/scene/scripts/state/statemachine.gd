@icon("res://src/assets/icon/statemachine.svg")
extends Node
class_name StateMachine

@export var DEBUGGING:=false
@export var initial_state:NodePath
@export 

var state_subject:BaseBody2d
var previous_state: State
var active_state : State :
	get:
		return active_state
	set(val):
		if DEBUGGING:
			print("State changing from {0} to {1}".format([active_state,val]))
		previous_state = active_state
		active_state = val

func _ready() -> void:
	state_subject = get_parent()
	init_children()


func process() -> void:
	active_state.process() if active_state else push_error("No Active State Found")
	##Synchronizes animation to state
	if state_subject.AnimPlayer.current_animation!=active_state.active_animation:
		active_state.enter()


func init_children() -> void:
	if initial_state != null:
		var initial_state_node = get_node(initial_state)
		if initial_state_node is State:
			active_state = initial_state_node
			active_state.FSM = self
			active_state.subject = state_subject
		else:
			push_error("Initial state is not a State or does not exist")
			active_state = null
			return
	else:
		push_error("Initial state is not set in the editor!")
		active_state = null
		return

	for child in get_children():
		if child is State:
			var c:State= child
			c.FSM=self
			c.subject=state_subject

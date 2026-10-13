extends Node
class_name State_machine

@export var initial_state: State

var current_state: State
var states: Dictionary = {}
#var guard: Guard

func init(guard: Guard) -> void:
	#print("children:", get_children())
	for child in get_children():
		#print(child.name,"is in state:", child is State)
		if child is State:
			states[child.name.to_lower()] = child
			child.guard = guard
			child.Transitioned.connect(on_child_transition)
	
	if initial_state:
		initial_state.Enter()
		current_state = initial_state

#func _ready() -> void:
	#for child in get_children():
		#if child is State:
			#states[child.guard.to_lower()] = guard
			#child.Transitioned.connect(on_child_transition)
	#
	#if initial_state:
		#initial_state.Enter()
		#current_state = initial_state


func _process(delta: float) -> void:
	if current_state:
		current_state.Update(delta)


func _physics_process(delta: float) -> void:
	if current_state:
		current_state.Physics_Update(delta)


func on_child_transition(state, new_state_name):
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state:
		current_state.Exit()
	
	new_state.Enter()
	
	current_state = new_state

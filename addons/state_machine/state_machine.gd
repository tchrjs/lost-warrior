class_name StateMachine extends Node

@export var initial_state : State

var current_state : State
var states : Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(_on_child_transition)

func enter_initial_state() -> void:
	if initial_state:
		_enter_state(initial_state)

func  get_current_state_name() -> String:
	if current_state:
		return current_state.name.to_lower()
	else:
		return ""

func _process(delta) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta) -> void:
	if current_state:
		current_state.physics_update(delta)

func _on_child_transition(state: State, new_state_name: String) -> void:
	if state != current_state:
		return

	var new_state: State = states.get(new_state_name.to_lower())
	if !new_state:
		print("Warning: " + new_state_name + " does not exist.")
		return

	_enter_state(new_state)

func _enter_state(state: State) -> void:
	if current_state:
		current_state.exit()
		current_state.active = false

	current_state = state
	state.enter()
	current_state.active = true

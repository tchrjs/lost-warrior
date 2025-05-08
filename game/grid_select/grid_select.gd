class_name GridSelect extends Node2D

@export var game_map: GameMap
@export var player: Player
@export var action_buttons: ActionButtons

func _ready() -> void:
	player.move_component.connect("action_finished", hide)
	action_buttons.move_button.connect("toggled", toggle)
	action_buttons.attack_button.connect("toggled", toggle)
	action_buttons.defend_button.connect("toggled", toggle)
	toggle(false)
	hide()

func toggle(toggled_on: bool) -> void:
	set_process_input(toggled_on)
	set_process(toggled_on)
	action_buttons.update()

# Find path from player to mouse event click
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		var cell = game_map.get_map_position(event.position)
		if action_buttons.move_button.button_pressed:
			if player.move_component.has_cell_in_area(cell):
				$Select.play()
				action_buttons.set_disabled(true)
				_on_move(cell, event.position)
		elif action_buttons.attack_button.button_pressed:
			if player.attack_component.has_cell_in_area(cell):
				action_buttons.set_disabled(true)
				_on_attack(cell, event.position)
		elif action_buttons.defend_button.button_pressed:
			if player.defend_component.has_cell_in_area(cell):
				action_buttons.set_disabled(true)
				_on_defend(cell, event.position)

func _on_move(cell: Vector2i, mouse_position: Vector2i) -> void:
	if not player.move_component.has_cell_in_area(cell):
		return
	player.move(game_map.find_path(player.position, mouse_position))
	global_position = game_map.get_snap_position(mouse_position)
	action_buttons.move_button.set_pressed_no_signal(false)
	toggle(false)

func _on_attack(cell: Vector2i, _mouse_position: Vector2i) -> void:
	if not player.attack_component.has_cell_in_area(cell):
		return
	action_buttons.attack_button.set_pressed_no_signal(false)
	player.attack(cell)
	toggle(false)
	hide()

func _on_defend(cell: Vector2i, _mouse_position: Vector2i) -> void:
	if not player.defend_component.has_cell_in_area(cell):
		return
	action_buttons.defend_button.set_pressed_no_signal(false)
	player.defend(cell)
	toggle(false)
	hide()

func _process(_delta: float) -> void:
	var mouse_position = get_global_mouse_position()
	if game_map.is_within_grid(mouse_position):
		global_position = game_map.get_snap_position(mouse_position)
		show()
	else:
		hide()

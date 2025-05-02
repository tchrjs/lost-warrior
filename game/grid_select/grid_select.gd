class_name GridSelect extends Node2D

@export var game_map: GameMap
@export var player: Player
@export var action_buttons: ActionButtons

func _ready() -> void:
	player.move_component.connect("finished_moving", hide)
	action_buttons.move_button.connect("toggled", toggle)
	action_buttons.attack_button.connect("toggled", toggle)
	toggle(false)
	hide()

func toggle(toggled_on: bool) -> void:
	set_process_input(toggled_on)
	set_process(toggled_on)

# Find path from player to mouse event click
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if action_buttons.move_button.button_pressed:
			var cell = game_map.get_map_position(event.position)
			if game_map.is_point_walkable(cell):
				if player.move_component.has_cell_in_area(cell):
					_on_action_button_toggled(cell, event.position)
		elif action_buttons.attack_button.button_pressed:
			return
		elif action_buttons.defend_button.button_pressed:
			return

func _on_action_button_toggled(cell: Vector2i, mouse_position: Vector2i) -> void:
	if not player.move_component.has_cell_in_area(cell):
		return
	player.move_along_path(game_map.find_path(player.position, mouse_position))
	global_position = game_map.get_snap_position(mouse_position)
	action_buttons.move_button.set_pressed_no_signal(false)
	player.move_component.toggle_move_range(false)
	toggle(false)

func _process(_delta: float) -> void:
	var mouse_position = get_global_mouse_position()
	if game_map.is_within_grid(mouse_position):
		global_position = game_map.get_snap_position(mouse_position)
		show()
	else:
		hide()

class_name GridSelect extends Node2D

@export var game_map: GameMap
@export var player: Player
@export var action_buttons: ActionButtons

func _ready() -> void:
	player.connect("finished_moving", hide)
	action_buttons.move_button.connect("toggled", toggle)
	toggle(false)
	hide()

func toggle(toggled_on: bool) -> void:
	set_process_input(toggled_on)
	set_process(toggled_on)

# Find path from player to mouse event click
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if game_map.is_point_walkable(event.position):
			player.move_along_path(game_map.find_path(player.position, event.position))
			global_position = game_map.get_snap_position(event.position)
			action_buttons.move_button.set_pressed_no_signal(false)
			toggle(false)

func _process(_delta: float) -> void:
	var mouse_position = get_global_mouse_position()
	if game_map.is_point_walkable(mouse_position):
		global_position = game_map.get_snap_position(mouse_position)
		show()
	else:
		hide()

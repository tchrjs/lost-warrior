class_name Player extends Node2D

@export var game_map: GameMap

var path: Array[Vector2i]

# Find path from player to mouse event click
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if game_map.is_point_walkable(event.position):
			path = game_map.find_path(position, event.position)

# Move towards selected position.
func _physics_process(_delta: float) -> void:
	if path.is_empty():
		return

	var target_position: Vector2 = game_map.get_target_position(path.front())
	global_position = global_position.move_toward(target_position, 1)
	if global_position == target_position:
		path.pop_front()

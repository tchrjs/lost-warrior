class_name Player extends Node2D

const CHARACTER_SPEED: int = 1

@export var sprite: Sprite2D
@export var game_map: GameMap
@export var grid_select: GridSelect

var path: Array[Vector2i]

func move_along_path(_path: Array[Vector2i]) -> void:
	path = _path
	var front: Vector2i = path.front()
	var back: Vector2i = path.back()
	if front != back:
		sprite.flip_h = front > back

	if path.is_empty():
		return

	grid_select.set_process(false)
	grid_select.set_process_input(false)

# Move towards selected position.
func _physics_process(_delta: float) -> void:
	if path.is_empty():
		grid_select.hide()
		grid_select.set_process(true)
		grid_select.set_process_input(true)
		return

	var target_position: Vector2 = game_map.get_target_position(path.front())
	global_position = global_position.move_toward(target_position, CHARACTER_SPEED)
	if global_position == target_position:
		path.pop_front()

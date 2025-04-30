class_name Unit extends Node2D

signal finished_moving

@export var sprite: Sprite2D
@export var unit_overlay: UnitOverlay
@export var game_map: GameMap

@export_category("Unit Stats")
@export var move_speed: float = 1.5
@export var move_distance: int = 3

var path: Array[Vector2i]
var area: Array[Vector2i]
var cell: Vector2i

func set_cell_position(_cell: Vector2i) -> void:
	cell = _cell
	global_position = game_map.get_local_position(cell)

func move_along_path(_path: Array[Vector2i]) -> void:
	path = _path
	var front: Vector2i = path.front()
	var back: Vector2i = path.back()
	if front != back:
		sprite.flip_h = front > back

func toggle_move_range(toggled_on: bool) -> void:
	if toggled_on:
		area = game_map.flood_fill(cell, move_distance)
		unit_overlay.draw(area)
		unit_overlay.show()
	else:
		area = []
		unit_overlay.clear()
		unit_overlay.hide()

# Move towards selected position.
func _physics_process(_delta: float) -> void:
	if path.is_empty():
		return

	var target_position: Vector2 = game_map.get_local_position(path.front())
	if cell != path.front():
		global_position = global_position.move_toward(target_position, move_speed)

	if global_position == target_position:
		cell = path.front()
		path.pop_front()
		if path.is_empty():
			emit_signal("finished_moving")

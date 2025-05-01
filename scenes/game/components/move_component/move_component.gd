class_name MoveComponent extends Node

signal finished_moving

@export var grid_overlay: GridOverlay

@export var turn_count: int = 1
@export var speed: float = 1.5
@export var distance: int = 3

var path: Array[Vector2i]

@onready var unit: Unit = get_parent()

# Toggle grid overlay of cells the unit can move to.
func toggle_move_range(toggled_on: bool) -> void:
	if toggled_on:
		grid_overlay.draw(unit.game_map.flood_fill(unit.cell, distance))
		grid_overlay.show()
	else:
		grid_overlay.clear()
		grid_overlay.hide()

func has_cell_in_area(cell: Vector2i) -> bool:
	return grid_overlay.area.has(cell)

# Sets path towards new destination.
func move_along_path(_path: Array[Vector2i]) -> void:
	path = _path
	var front: Vector2i = path.front()
	var back: Vector2i = path.back()
	if front != back:
		unit.sprite.flip_h = front > back

# Move towards selected position.
func _physics_process(_delta: float) -> void:
	if path.is_empty():
		return

	var target_position: Vector2 = unit.game_map.get_local_position(path.front())
	if unit.cell != path.front():
		unit.global_position = unit.global_position.move_toward(target_position, speed)

	if unit.global_position == target_position:
		unit.set_cell_position(path.front())
		path.pop_front()
		if path.is_empty():
			emit_signal("finished_moving")

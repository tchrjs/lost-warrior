class_name MoveComponent extends Node

signal action_finished

const DIRECTIONS = [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]

@export var grid_overlay: GridOverlay

@export var max_turn_count: int = 1
@export var speed: float = 1.5
@export var distance: int = 3

var path: Array[Vector2i]

@onready var unit: Unit = get_parent()
@onready var turn_count: int = max_turn_count

func reset() -> void:
	turn_count = max_turn_count

# Toggle grid overlay of cells the unit can move to.
func toggle_range(toggled_on: bool) -> void:
	if toggled_on:
		grid_overlay.draw(unit.game_map.flood_fill(unit.cell, distance, false))
		grid_overlay.show()
	else:
		grid_overlay.clear()
		grid_overlay.hide()

func has_cell_in_area(cell: Vector2i) -> bool:
	return grid_overlay.area.has(cell)

func perform_action(_path: Array[Vector2i]) -> void:
	toggle_range(false)

	turn_count -= 1
	if turn_count < 0:
		turn_count = 0

	path = _path

func can_perform_action() -> bool:
	return turn_count >= 0

func get_closest_point(cell: Vector2i) -> Vector2i:
	grid_overlay.draw(unit.game_map.flood_fill(unit.cell, distance, false))
	var closest_point: Vector2i = unit.cell
	var min_dist := INF

	for direction in DIRECTIONS:
		if closest_point == cell + direction:
			return closest_point

	for point in grid_overlay.area:
		for direction in DIRECTIONS:
			var dist = point.distance_to(cell + direction)
			if dist < min_dist:
				min_dist = dist
				closest_point = point
	return closest_point

# Move towards selected position.
func _physics_process(_delta: float) -> void:
	if path.is_empty():
		return

	var target_position: Vector2 = unit.game_map.get_local_position(path.front())
	var front: Vector2i = path.front()

	if front != unit.cell and front.x != unit.cell.x:
		unit.sprite.flip_h = front.x < unit.cell.x

	if unit.cell != path.front():
		unit.global_position = unit.global_position.move_toward(target_position, speed)

	if unit.global_position == target_position:
		unit.set_cell_position(path.front())
		path.pop_front()
		if path.is_empty():
			emit_signal("action_finished")

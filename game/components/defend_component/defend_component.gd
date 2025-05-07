class_name DefendComponent extends Node2D

signal action_finished

@export var range_overlay: GridOverlay
@export var defend_overlay: GridOverlay

@export var max_turn_count: int = 1
@export var damage: int = 1
@export var distance: int = 1

var cell: Vector2i

@onready var unit: Unit = get_parent()
@onready var turn_count: int = max_turn_count

func reset() -> void:
	turn_count = max_turn_count
	clear_cell()

# Toggle grid overlay of cells the unit can move to.
func toggle_range(toggled_on: bool) -> void:
	if toggled_on:
		range_overlay.draw(unit.game_map.flood_fill(unit.cell, distance))
		range_overlay.show()
	else:
		range_overlay.clear()
		range_overlay.hide()

func has_cell_in_area(_cell: Vector2i) -> bool:
	return range_overlay.area.has(_cell)

func clear_cell() -> void:
	cell = Vector2i.ZERO
	defend_overlay.clear()
	defend_overlay.hide()

func perform_action(_cell: Vector2i) -> void:
	toggle_range(false)

	turn_count -= 1
	if turn_count < 0:
		turn_count = 0

	cell = _cell
	defend_overlay.draw([cell])
	defend_overlay.show()
	if cell != unit.cell and cell.x != unit.cell.x:
		unit.sprite.flip_h = cell.x < unit.cell.x
	emit_signal("action_finished")

func can_perform_action() -> bool:
	return turn_count >= 0

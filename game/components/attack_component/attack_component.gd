class_name AttackComponent extends Node2D

signal action_finished

@export var grid_overlay: GridOverlay
@export var hit: AudioStreamPlayer
@export var block: AudioStreamPlayer

@export var max_turn_count: int = 1
@export var damage: int = 1
@export var distance: int = 1

@onready var unit: Unit = get_parent()
@onready var turn_count: int = max_turn_count

func reset() -> void:
	turn_count = max_turn_count

# Toggle grid overlay of cells the unit can move to.
func toggle_range(toggled_on: bool) -> void:
	if toggled_on:
		grid_overlay.draw(unit.game_map.flood_fill(unit.cell, distance))
		grid_overlay.show()
	else:
		grid_overlay.clear()
		grid_overlay.hide()

func has_cell_in_area(cell: Vector2i) -> bool:
	return grid_overlay.area.has(cell)

func get_range() -> Array:
	grid_overlay.draw(unit.game_map.flood_fill(unit.cell, distance))
	return grid_overlay.area

func perform_action(cell: Vector2i, success: bool = false) -> void:
	toggle_range(false)

	turn_count -= 1
	if turn_count < 0:
		turn_count = 0

	if cell != null:
		if cell != unit.cell and cell.x != unit.cell.x:
			unit.sprite.flip_h = cell.x < unit.cell.x

		var target: Unit = unit.game_map.get_unit_at(cell)
		if target != null and grid_overlay.area.has(cell):
			if success:
				hit.play()
			else:
				block.play()
			target.health_component.damage(damage if success else 0, unit)
			await play_attack_animation(target)
	emit_signal("action_finished")

func play_attack_animation(target: Unit) -> void:
	var start_pos := unit.position
	var x = 0
	if target.cell.x < unit.cell.x:
		x = 5
	elif target.cell.x > unit.cell.x:
		x = -5
	else:
		x = 0

	var y = 0
	if target.cell.y < unit.cell.y:
		y = 5
	elif target.cell.y > unit.cell.y:
		y = -5
	else:
		y = 0

	var peak_pos := start_pos - Vector2(x, y)
	var end_pos := start_pos

	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(unit, "position", peak_pos, 0.15)
	tween.tween_property(unit, "position", end_pos, 0.15).set_ease(Tween.EASE_IN)
	await tween.finished

func can_perform_action() -> bool:
	return turn_count >= 0

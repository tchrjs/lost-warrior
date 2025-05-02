class_name AttackComponent extends Node2D

@export var grid_overlay: GridOverlay

@export var turn_count: int = 1
@export var damage: int = 1
@export var distance: int = 1

@onready var unit: Unit = get_parent()

# Toggle grid overlay of cells the unit can move to.
func toggle_attack_range(toggled_on: bool) -> void:
	if toggled_on:
		grid_overlay.draw(unit.game_map.flood_fill(unit.cell, distance))
		grid_overlay.show()
	else:
		grid_overlay.clear()
		grid_overlay.hide()

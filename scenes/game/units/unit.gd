class_name Unit extends Node2D

@export var sprite: Sprite2D
@export var game_map: GameMap

var cell: Vector2i

func set_cell_position(_cell: Vector2i) -> void:
	cell = _cell
	global_position = game_map.get_local_position(cell)

class_name Game extends Node

@export var game_map: GameMap
@export var player: Player

func _ready() -> void:
	player.set_cell_position(game_map.get_origin_position() + Vector2i(1, 1))

class_name Game extends Node

@export var game_map: GameMap
@export var player: Player
@export var units: Node

@onready var goblin_scene: PackedScene = load("res://game/units/goblin/goblin.tscn")

func _ready() -> void:
	player.set_cell_position(game_map.get_origin_position() + Vector2i(5, 3))

	var goblin: Goblin = goblin_scene.instantiate()
	goblin.game_map = game_map
	units.add_child(goblin)
	goblin.set_cell_position(game_map.get_origin_position() + Vector2i(8, 3))
	goblin.sprite.flip_h = goblin.cell > player.cell

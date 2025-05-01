class_name Game extends Node

@export var game_map: GameMap
@export var player: Player
@export var enemy_container: Node

var enemies: Array[Unit] = []

@onready var goblin_scene: PackedScene = load("res://scenes/game/units/goblin/goblin.tscn")

func _ready() -> void:
	player.set_cell_position(game_map.get_origin_position() + Vector2i(5, 3))

	var goblin: Goblin = goblin_scene.instantiate()
	goblin.game_map = game_map
	enemy_container.add_child(goblin)
	goblin.set_cell_position(game_map.get_origin_position() + Vector2i(8, 3))
	goblin.sprite.flip_h = goblin.cell > player.cell

class_name Game extends Node

@export var state_machine: StateMachine
@export var game_map: GameMap
@export var player: Player
@export var enemy_group: Node2D

var enemies: Array = []

@onready var goblin_scene: PackedScene = load("res://game/units/goblin/goblin.tscn")

func _ready() -> void:
	SignalBus.connect("game_over", _on_game_over)
	player.set_cell_position(game_map.get_origin_position() + Vector2i(5, 3))
	state_machine.enter_initial_state()

	var goblin: Goblin = goblin_scene.instantiate()
	goblin.player = player
	goblin.game_map = game_map
	enemies.append(goblin)
	enemy_group.add_child(goblin)
	goblin.set_cell_position(game_map.get_origin_position() + Vector2i(8, 3))
	goblin.sprite.flip_h = goblin.cell > player.cell

func _on_game_over() -> void:
	print("game over")
	pass

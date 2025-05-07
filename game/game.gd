class_name Game extends Node

@export var state_machine: StateMachine
@export var game_map: GameMap
@export var player: Player
@export var enemy_spawner: EnemySpawner
@export var game_over_screen: Control

func _ready() -> void:
	SignalBus.connect("game_over", _on_game_over)
	player.set_cell_position(game_map.get_origin_position() + Vector2i(5, 3))
	state_machine.enter_initial_state()
	enemy_spawner.init()

func _on_game_over() -> void:
	game_over_screen.show()

func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()

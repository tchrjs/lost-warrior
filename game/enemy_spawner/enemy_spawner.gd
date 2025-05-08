class_name EnemySpawner extends Node

@export var game_map: GameMap
@export var player: Player
@export var enemy_group: Node2D
@export var level_counter: LevelCounter
@export var sound: AudioStreamPlayer

var enemies: Array = []

@onready var goblin_scene: PackedScene = load("res://game/units/goblin/goblin.tscn")
@onready var ghost_scene: PackedScene = load("res://game/units/ghost/ghost.tscn")
@onready var zombie_scene: PackedScene = load("res://game/units/zombie/zombie.tscn")

func init() -> void:
	spawn_goblin(game_map.get_origin_position() + Vector2i(8, 3))

func spawn_enemies(level: int) -> void:
	for i in level:
		if i == 0:
			spawn_goblin(game_map.get_random_walkable_cell(), true)
		else:
			var rand = randi() % 3
			if rand == 0:
				spawn_goblin(game_map.get_random_walkable_cell(), true)
			elif rand == 1:
				spawn_ghost(game_map.get_random_walkable_cell(), true)
			elif rand == 2:
				spawn_zombie(game_map.get_random_walkable_cell(), true)
		sound.play()
		await get_tree().create_timer(0.25).timeout

func spawn_ghost(cell: Vector2i, play_animation: bool = false) -> void:
	var ghost: Ghost = ghost_scene.instantiate()
	ghost.player = player
	ghost.game_map = game_map
	enemies.append(ghost)
	enemy_group.add_child(ghost)
	ghost.set_cell_position(cell)
	ghost.sprite.flip_h = ghost.cell > player.cell
	if play_animation:
		jump(ghost)

func spawn_goblin(cell: Vector2i, play_animation: bool = false) -> void:
	var goblin: Goblin = goblin_scene.instantiate()
	goblin.player = player
	goblin.game_map = game_map
	enemies.append(goblin)
	enemy_group.add_child(goblin)
	goblin.set_cell_position(cell)
	goblin.sprite.flip_h = goblin.cell > player.cell
	if play_animation:
		jump(goblin)

func spawn_zombie(cell: Vector2i, play_animation: bool = false) -> void:
	var zombie: Zombie = zombie_scene.instantiate()
	zombie.player = player
	zombie.game_map = game_map
	enemies.append(zombie)
	enemy_group.add_child(zombie)
	zombie.set_cell_position(cell)
	zombie.sprite.flip_h = zombie.cell > player.cell
	if play_animation:
		jump(zombie)

func jump(unit: Unit) -> void:
	var start_pos := unit.position
	var peak_pos := start_pos - Vector2(0, 10)
	var end_pos := start_pos

	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(unit, "position", peak_pos, 0.15)
	tween.tween_property(unit, "position", end_pos, 0.15).set_ease(Tween.EASE_IN)

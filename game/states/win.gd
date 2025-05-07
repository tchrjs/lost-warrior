class_name Win extends State

@export var level_counter: LevelCounter
@export var enemy_spawner: EnemySpawner

func enter() -> void:
	level_counter.incr()
	await enemy_spawner.spawn_enemies(level_counter.counter)
	transitioned.emit(self, "playerturn")

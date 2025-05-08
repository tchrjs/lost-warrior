class_name Win extends State

@export var level_counter: LevelCounter
@export var enemy_spawner: EnemySpawner
@export var sound: AudioStreamPlayer

func enter() -> void:
	level_counter.incr()
	sound.play()
	await get_tree().create_timer(0.5).timeout
	await enemy_spawner.spawn_enemies(level_counter.counter)
	transitioned.emit(self, "playerturn")

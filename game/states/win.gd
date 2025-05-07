class_name Win extends State

@export var level_counter: LevelCounter

func enter() -> void:
	level_counter.incr()

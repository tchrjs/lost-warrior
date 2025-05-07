class_name HealthComponent extends Node2D

signal was_damaged
signal has_died

@export var max_health: int = 1

@onready var health: int = max_health

func damage(_damage: int) -> void:
	health -= _damage
	emit_signal("was_damaged")
	if health <= 0:
		emit_signal("has_died")

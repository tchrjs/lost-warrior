class_name HealthComponent extends Node2D

signal has_died

@export var max_health: int = 1

@onready var health: int = max_health

func damage(_damage: int) -> void:
	health -= _damage
	if health <= 0:
		print("has_died")
		emit_signal("has_died")

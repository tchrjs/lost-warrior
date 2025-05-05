class_name HealthComponent extends Node2D

@export var max_health: int = 1

@onready var health: int = max_health

func damage(attack: AttackComponent) -> void:
	health -= attack.damage

class_name HealthComponent extends Node2D

@export var max_health: int = 1
var health: int = 1

func _ready():
	health = max_health

func damage(attack: AttackComponent) -> void:
	health -= attack.damage

class_name HealthComponent extends Node2D

signal was_damaged(unit: Unit)
signal has_died

@export var max_health: int = 1
@export var heart_container: Control

@onready var unit: Unit = get_parent()
@onready var health: int = max_health
@onready var heart_scene: PackedScene = load("res://game/heart/heart.tscn")

func _ready() -> void:
	for i in max_health:
		var heart: Node = heart_scene.instantiate()
		heart_container.add_child(heart)

func damage(_damage: int, attacker: Unit) -> void:
	health -= _damage
	if _damage > 0:
		emit_signal("was_damaged", attacker)
		_on_damaged()
		for i in _damage:
			remove_heart()
	else:
		_on_block()

	if health <= 0:
		emit_signal("has_died")

func remove_heart() -> void:
	var count = heart_container.get_child_count()
	if count <= 0:
		return
	var heart: Node = heart_container.get_child(0)
	heart.queue_free()
	heart_container.remove_child(heart)

func _on_damaged() -> void:
	var tween = create_tween()
	tween.tween_property(unit.sprite, "modulate", Color.DARK_RED, 0.1)
	tween.tween_property(unit.sprite, "modulate", Color(1, 1, 1, 1), 0.2)

func _on_block() -> void:
	var tween = create_tween()
	tween.tween_property(unit.sprite, "modulate", Color.SKY_BLUE, 0.05)
	tween.tween_property(unit.sprite, "modulate", Color(1, 1, 1, 1), 0.1)

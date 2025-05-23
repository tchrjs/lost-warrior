class_name Player extends Unit

signal action_finished

# Components.
@export var move_component: MoveComponent
@export var attack_component: AttackComponent
@export var defend_component: DefendComponent

func _ready() -> void:
	move_component.connect("action_finished", _on_action_finished)
	attack_component.connect("action_finished", _on_action_finished)
	defend_component.connect("action_finished", _on_action_finished)
	health_component.connect("has_died", _on_death)
	health_component.connect("was_damaged", _on_damaged)

func move(path: Array[Vector2i]) -> void:
	move_component.perform_action(path)

func attack(_cell: Vector2i) -> void:
	attack_component.perform_action(_cell, true)

func defend(_cell: Vector2i) -> void:
	defend_component.perform_action(_cell)

func reset() -> void:
	move_component.reset()
	attack_component.reset()
	defend_component.reset()

func _on_action_finished() -> void:
	emit_signal("action_finished")

func _on_death() -> void:
	queue_free()

func _on_damaged(attacker: Unit) -> void:
	if attacker.cell == defend_component.cell:
		defend_component.clear_cell()

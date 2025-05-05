class_name Player extends Unit

signal action_finished

# Components.
@export var health_component: HealthComponent
@export var move_component: MoveComponent
@export var attack_component: AttackComponent
@export var defend_component: DefendComponent

func _ready() -> void:
	move_component.connect("action_finished", _on_action_finished)
	attack_component.connect("action_finished", _on_action_finished)
	defend_component.connect("action_finished", _on_action_finished)

func move(path: Array[Vector2i]) -> void:
	move_component.perform_action(path)

func attack(_cell: Vector2i) -> void:
	attack_component.perform_action(_cell)

func defend(_cell: Vector2i) -> void:
	defend_component.perform_action(_cell)

func reset() -> void:
	move_component.reset()
	attack_component.reset()
	defend_component.reset()

func _on_action_finished() -> void:
	emit_signal("action_finished")

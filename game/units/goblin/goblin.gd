class_name Goblin extends Unit

signal actions_finished

@export var player: Player
@export var move_component: MoveComponent
@export var attack_component: AttackComponent

var actions = ["move"]

func _ready() -> void:
	move_component.connect("action_finished", _check_all_actions_performed)
	attack_component.connect("action_finished", _check_all_actions_performed)
	health_component.connect("has_died", _on_death)

func move(destination: Vector2i) -> void:
	var walk_point: Vector2i = move_component.get_closest_point(destination)
	move_component.perform_action(game_map.find_path(position, game_map.get_local_position(walk_point)))

func attack() -> void:
	if attack_component.get_range().has(player.cell):
		attack_component.perform_action(player.cell)
	else:
		attack_component.perform_action(Vector2i.ZERO)

func reset() -> void:
	move_component.reset()
	attack_component.reset()

func _check_all_actions_performed() -> void:
	await get_tree().create_timer(0.25).timeout
	if move_component.turn_count != 0:
		move(player.cell)
		return
	if attack_component.turn_count != 0:
		attack()
		return
	emit_signal("actions_finished")

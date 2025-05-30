class_name PlayerTurn extends State

@export var action_buttons: ActionButtons
@export var player: Player
@export var enemy_group: Node2D

func _ready() -> void:
	player.connect("action_finished", _on_action_finished)

func enter() -> void:
	player.reset()
	action_buttons.update()
	action_buttons.set_disabled(false)

func exit() -> void:
	action_buttons.set_disabled(true)

func _on_action_finished() -> void:
	if player.defend_component.turn_count == 0:
		action_buttons.set_disabled(true)
		transitioned.emit(self, "enemyturn")
	elif enemy_group.get_child_count() <= 0:
			action_buttons.set_disabled(false)
			transitioned.emit(self, "win")
	else:
		action_buttons.set_disabled(false)

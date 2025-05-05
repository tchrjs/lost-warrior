class_name ActionButtons extends Control

@export var player: Player

@export var move_button: Button
@export var attack_button: Button
@export var defend_button: Button

func _ready() -> void:
	var button_group = ButtonGroup.new()
	move_button.button_group = button_group
	attack_button.button_group = button_group
	defend_button.button_group = button_group

	move_button.connect("toggled", player.move_component.toggle_range)
	attack_button.connect("toggled", player.attack_component.toggle_range)
	defend_button.connect("toggled", player.defend_component.toggle_range)

func set_disabled(toggled_on: bool) -> void:
	move_button.disabled = toggled_on or player.move_component.turn_count <= 0
	attack_button.disabled = toggled_on or player.attack_component.turn_count <= 0
	defend_button.disabled = toggled_on or player.defend_component.turn_count <= 0

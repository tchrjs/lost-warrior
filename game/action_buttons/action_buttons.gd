class_name ActionButtons extends Control

@export var move_button: Button
@export var attack_button: Button
@export var defend_button: Button
@export var end_button: Button

func _ready() -> void:
	var button_group = ButtonGroup.new()
	move_button.button_group = button_group
	attack_button.button_group = button_group
	defend_button.button_group = button_group

func set_disabled(toggled_on: bool) -> void:
	move_button.disabled = toggled_on
	attack_button.disabled = toggled_on
	defend_button.disabled = toggled_on
	end_button.disabled = toggled_on

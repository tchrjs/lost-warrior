class_name Player extends Unit

@export var action_buttons: ActionButtons

func _ready() -> void:
	action_buttons.move_button.connect("toggled", toggle_move_range)

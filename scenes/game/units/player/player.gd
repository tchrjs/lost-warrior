class_name Player extends Unit

@export var action_buttons: ActionButtons
@export var move_component: MoveComponent

func _ready() -> void:
	action_buttons.move_button.connect("toggled", move_component.toggle_move_range)

func move_along_path(path: Array[Vector2i]) -> void:
	move_component.move_along_path(path)

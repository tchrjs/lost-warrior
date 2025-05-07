class_name LevelCounter extends Control

@export var label: Label

var counter: int = 1

func incr() -> void:
	counter = counter + 1
	label.text = "Level: " + str(counter)

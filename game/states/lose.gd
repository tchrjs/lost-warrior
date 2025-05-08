class_name Lose extends State

@export var sound: AudioStreamPlayer

func enter() -> void:
	SignalBus.emit_signal("game_over")
	sound.play()

class_name Lose extends State

func enter() -> void:
	SignalBus.emit_signal("game_over")

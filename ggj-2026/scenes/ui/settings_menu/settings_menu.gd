extends Control

func _on_close_button_pressed() -> void:
	# Unpausa gioco
	SignalBus.resume_game.emit()
	queue_free()


func _go_to_level(level: int) -> void:
	print("Il livello è: ", level)
	SignalBus.go_to_level.emit(level)
	queue_free()

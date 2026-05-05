extends Control

var unblocked_level_scene_path = "res://scenes/ui/levels_menu/level_unblocked.tscn"
var blocked_level_scene_path = "res://scenes/ui/levels_menu/level_blocked.tscn"


func set_levels(unblocked: int, blocked: int) -> void:
	for i in unblocked:
		var btn = load(unblocked_level_scene_path).instantiate()
		btn.set_level_index(i)
		btn.pressed_indx.connect(_go_to_level)
		$GridContainer.add_child(btn)
	for i in blocked:
		var btn = load(blocked_level_scene_path).instantiate()
		btn.set_level_index(unblocked + i)
		#btn.pressed_indx.connect(_go_to_level)
		$GridContainer.add_child(btn)


func _on_close_button_pressed() -> void:
	# Unpausa gioco
	SignalBus.resume_game.emit()
	queue_free()


func _go_to_level(level: int) -> void:
	print("Il livello è: ", level)
	SignalBus.go_to_level.emit(level)
	queue_free()

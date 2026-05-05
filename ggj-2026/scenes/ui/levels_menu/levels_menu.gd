extends Control

var unblocked_level_scene_path = "res://scenes/ui/levels_menu/level_unblocked.tscn"
var blocked_level_scene_path = "res://scenes/ui/levels_menu/level_blocked.tscn"

func set_levels(unblocked: int, blocked: int) -> void:
	for i in range(0, unblocked):
		var btn = load(unblocked_level_scene_path).instantiate()
		btn.set_level_index(i)
		$GridContainer.add_child(btn)
	for i in range(0, blocked):
		var btn = load(blocked_level_scene_path).instantiate()
		btn.set_level_index(unblocked + i)
		$GridContainer.add_child(btn)


func _on_button_pressed() -> void:
	# Unpausa gioco
	SignalBus.resume_game.emit()
	queue_free()

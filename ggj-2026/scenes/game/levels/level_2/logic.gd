extends Node

var level: Level
var dialog: Dialog
var show_dialog: bool = true


func init() -> void:
	if (show_dialog):
		level.player.deactivate()
		
		SignalBus.start_line.connect(_on_start_line)
		SignalBus.dialog_finished.connect(_on_dialog_finished)
		
		dialog = load("res://scenes/ui/Dialog.tscn").instantiate()
		add_child(dialog)
		dialog.size = Vector2(1000.0, 250.0)
		dialog.position = Vector2(163.5, 800)
		
		var text_data = load("res://resources/text/tutorial_2.tres")
		text_data.init()
		dialog.text_data = text_data
		dialog.start_dialog()
	else:
		# attiva subito le funzioni che attiveresti durante il tutorial
		var layer: RowLayer = get_parent().get_child(0).get_row_layer(3)
		var mask_container: MaskContainer = layer.get_mask_container()
		mask_container.rotation_disabled = false
		for i in range(1, 3):
			var layer2: RowLayer = get_parent().get_child(0).get_row_layer(i)
			var mask_container2: MaskContainer = layer2.get_mask_container()
			mask_container2.rotation_disabled = false


func reset() -> void:
	if SignalBus.start_line.is_connected(_on_start_line):
		SignalBus.start_line.disconnect(_on_start_line)
	if SignalBus.dialog_finished.is_connected(_on_dialog_finished):
		SignalBus.dialog_finished.disconnect(_on_dialog_finished)
	
	for child in get_children():
		child.queue_free()
	dialog = null


func _on_start_line(text_id: String) -> void:
	if text_id == "TUTORIAL_12":
		var highlight_button: TextureRect = load("res://scenes/game/components/tutorial/highlight_button.tscn").instantiate()
		highlight_button.position = Vector2(1700.0, 750.0)
		highlight_button.material.set_shader_parameter("color", Color("#F2FF49"))
		add_child(highlight_button)
		SignalBus.mask_rotated.connect(_on_mask_rotated)
		var layer: RowLayer = get_parent().get_child(0).get_row_layer(3)
		var mask_container: MaskContainer = layer.get_mask_container()
		mask_container.rotation_disabled = false
	elif text_id == "TUTORIAL_13":
		remove_child(get_child(1))
		for i in range(1, 3):
			var layer: RowLayer = get_parent().get_child(0).get_row_layer(i)
			var mask_container: MaskContainer = layer.get_mask_container()
			mask_container.rotation_disabled = false


func _on_mask_rotated(_mask: Mask, layer: int) -> void:
	if layer == 3:
		SignalBus.mask_rotated.disconnect(_on_mask_rotated)
		dialog.continue_dialog()


func _on_dialog_finished() -> void:
	dialog.queue_free()
	dialog = null
	level.player.activate()

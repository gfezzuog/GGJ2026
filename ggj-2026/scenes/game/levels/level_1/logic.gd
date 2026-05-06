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
	
		var text_data = load("res://resources/text/tutorial_1.tres")
		text_data.init()
		dialog.text_data = text_data
		dialog.start_dialog()
		
	else:
		print("skipping dialog")
		# attiva subito le funzioni che attiveresti durante il tutorial
		# ...
		

func reset() -> void:
	SignalBus.start_line.disconnect(_on_start_line)
	SignalBus.dialog_finished.disconnect(_on_dialog_finished)
	for child in get_children():
		child.queue_free()
	dialog = null


func _on_start_line(text_id: String) -> void:
	if text_id == "TUTORIAL_7":
		var arrow: Node2D = load("res://scenes/game/components/tutorial/arrow.tscn").instantiate()
		arrow.position = Vector2(1625.0, 415.0)
		SignalBus.mask_activated.connect(_on_mask_activated)
		add_child(arrow)
	elif text_id == "TUTORIAL_8":
		remove_child(get_child(1))
		var highlight_layer: TextureRect = load("res://scenes/game/components/tutorial/highlight_layer.tscn").instantiate()
		highlight_layer.size = Vector2(216.0, 216.0)
		highlight_layer.position = Vector2(1546.0, 246.0)
		highlight_layer.material.set_shader_parameter("color", Color("#F2FF49"))
		add_child(highlight_layer)
	elif text_id == "TUTORIAL_9":
		var highlight_layer: TextureRect = get_child(1)
		highlight_layer.position.x = 1259.0
	elif text_id == "TUTORIAL_10":
		remove_child(get_child(1))


func _on_mask_activated(_mask: Mask, layer: int) -> void:
	if layer == 1:
		SignalBus.mask_activated.disconnect(_on_mask_activated)
		dialog.continue_dialog()


func _on_dialog_finished() -> void:
	dialog.queue_free()
	dialog = null
	level.player.activate()

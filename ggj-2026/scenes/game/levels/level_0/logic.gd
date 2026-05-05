extends Node

var level: Level
var dialog: Dialog


func init() -> void:
	level.player.deactivate()
	level = get_parent().get_child(1).get_child(0)
	SignalBus.start_line.connect(_on_start_line)
	dialog = load("res://scenes/ui/Dialog.tscn").instantiate()
	add_child(dialog)
	dialog.size = Vector2(1000.0, 250.0)
	dialog.position = Vector2(163.5, 800)
	SignalBus.dialog_finished.connect(_on_dialog_finished)
	
	var text_data = load("res://resources/text/tutorial_0.tres")
	text_data.init()
	dialog.text_data = text_data
	dialog.start_dialog()


func _on_start_line(text_id: String) -> void:
	if text_id == "TUTORIAL_1":
		var material := ShaderMaterial.new()
		material.shader = load("res://resources/shaders/mask.gdshader")
		material.set_shader_parameter("highlight_color", Color("#F2FF49"))
		material.set_shader_parameter("highlight_enabled", 1.0)
		level.change_child_material("SubViewport/Layers/Layer0/Door", material)
	
	elif text_id == "TUTORIAL_2":
		level.reset_child_material("SubViewport/Layers/Layer0/Door")
		var tutorial_target = level.get_node("SubViewport/TutorialTarget")
		tutorial_target.show()
		tutorial_target.get_child(0).monitoring = true
		tutorial_target.get_child(0).body_entered.connect(_on_target_reached)
		level.player.activate()
	
	elif text_id == "TUTORIAL_4":
		SignalBus.mask_activated.connect(_on_mask_connected)
		var highlight_button: TextureRect = load("res://scenes/game/components/tutorial/highlight_button.tscn").instantiate()
		highlight_button.position = Vector2(1700.0, 250)
		highlight_button.material.set_shader_parameter("color", Color("#F2FF49"))
		add_child(highlight_button)
		var layer: RowLayer = get_parent().get_child(0).get_row_layer(1)
		var mask_container: MaskContainer = layer.get_mask_container()
		mask_container.visibility_disabled = false
	
	
	elif text_id == "TUTORIAL_5":
		remove_child(get_child(1))


func _on_target_reached(_body) -> void:
	var tutorial_target = level.get_node("SubViewport/TutorialTarget")
	tutorial_target.hide()
	var area = tutorial_target.get_child(0)
	area.set_deferred("monitoring", false)
	dialog.continue_dialog()


func _on_mask_connected(_maks, _indx) -> void:
	SignalBus.mask_activated.disconnect(_on_mask_connected)
	dialog.continue_dialog()


func _on_dialog_finished() -> void:
	dialog.queue_free()
	dialog = null
	SignalBus.start_line.disconnect(_on_start_line)
	SignalBus.dialog_finished.disconnect(_on_dialog_finished)

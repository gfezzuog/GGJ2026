class_name Dialog extends VBoxContainer


var text_data: TextData
var current_tween: Tween
var current_block: TextData.TextBlock

var writing: bool = false
var inside: bool = false

var not_clickable: bool = false
var timer: Timer


func _ready() -> void:
	timer = Timer.new()
	timer.wait_time = 0.01
	timer.autostart = false
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and inside and not not_clickable:
		_manage_pressed()
		not_clickable = true
		timer.start()


func start_dialog() -> void:
	var text_block: TextData.TextBlock = text_data.get_next_text()
	write_text(text_block)


func continue_dialog() -> void:
	$PanelContainer/VBoxContainer/RichTextLabel.mouse_filter = MOUSE_FILTER_PASS
	$FakeButton.start()
	
	var text_block: TextData.TextBlock = text_data.get_next_text()
	if text_block != null:
		write_text(text_block)
	else:
		$PanelContainer/VBoxContainer/RichTextLabel.text = ""
		SignalBus.dialog_finished.emit()


func write_text(text_block: TextData.TextBlock) -> void:
	var speaker := text_block.speaker
	var text_to_write := text_block.text
	var text_id := text_block.id
	
	current_block = text_block
	
	var header: String = "[color=#26a268]"+speaker+"[/color]:~$ "
	$PanelContainer/VBoxContainer/RichTextLabel.text = header + text_to_write
	$PanelContainer/VBoxContainer/RichTextLabel.visible_characters = 4+len(speaker)
	
	writing = true
	SignalBus.start_line.emit(text_id)
	current_tween = get_tree().create_tween()
	current_tween.tween_property($PanelContainer/VBoxContainer/RichTextLabel, "visible_ratio", 1.0, len(text_to_write) * 0.02)
	current_tween.tween_callback(end)


func end() -> void:
	if not current_block.auto_progess:
		inside = false
		$PanelContainer/VBoxContainer/RichTextLabel.mouse_filter = MOUSE_FILTER_STOP
	SignalBus.end_line.emit(current_block.id)
	current_block = null
	writing = false
	$FakeButton.stop()


func stop() -> void:
	current_tween.stop()
	$PanelContainer/VBoxContainer/RichTextLabel.visible_ratio = 1.0
	end()


func _manage_pressed() -> void:
	if writing:
		stop()
	else:
		continue_dialog()


func _on_panel_container_mouse_entered() -> void:
	inside = true


func _on_panel_container_mouse_exited() -> void:
	inside = false


func _on_timer_timeout() -> void:
	not_clickable = false

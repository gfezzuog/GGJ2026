extends Node2D

@export var text = "Testo del popup"
@export var default_position = Vector2(630.0, 534.0)


func _ready() -> void:
	SignalBus.open_popup_ok.connect(open_popup_ok)
	SignalBus.open_popup_yes_no.connect(open_popup_yes_no)


func reset_position():
	self.position = default_position


func set_new_position(pos: Vector2):
	self.position = pos


func open_popup_ok(new_text: String):
	set_text(new_text)
	$Content/PanelContainer/Button_ok.show()
	$Content/PanelContainer/Button_no.hide()
	$Content/PanelContainer/Button_yes.hide()
	$Content.show()


func open_popup_yes_no(new_text: String):
	set_text(new_text)
	$Content/PanelContainer/Button_ok.hide()
	$Content/PanelContainer/Button_no.show()
	$Content/PanelContainer/Button_yes.show()
	$Content.show()


func close_popup():
	SignalBus.close_popup.emit()
	$Content.hide()


func set_text(new_text: String):
	text = new_text
	$Content/PanelContainer/Label.text = text


# Premi ok
func _on_button_pressed() -> void:
	close_popup()


# Premi yes
func _on_button_yes_pressed() -> void:
	SignalBus.popup_pressed_yes.emit()
	close_popup()


# Premi no
func _on_button_no_pressed() -> void:
	SignalBus.popup_pressed_no.emit()
	close_popup()

extends Node2D

@export var text = "Testo del popup"

@export var default_position = Vector2(630.0, 534.0)

func _ready() -> void:
	SignalBus.connect("open_popup_ok", openPopupOk)
	SignalBus.connect("open_popup_yes_no", openPopupYesNo)

func reset_position():
	self.position = default_position
	
func set_new_position(pos: Vector2):
	self.position = pos

func openPopupOk(newText):
	setText(newText)
	$Content/PanelContainer/Button_ok.show()
	$Content/PanelContainer/Button_no.hide()
	$Content/PanelContainer/Button_yes.hide()
	$Content.show()
	
	
func openPopupYesNo(newText):
	setText(newText)
	$Content/PanelContainer/Button_ok.hide()
	$Content/PanelContainer/Button_no.show()
	$Content/PanelContainer/Button_yes.show()
	$Content.show()

func closePopup():
	SignalBus.emit_signal("close_popup")
	print("popup chiuso")
	$Content.hide()
	pass
	

func setText(newText):
	text = newText
	$Content/PanelContainer/Label.text = text


# Premi ok
func _on_button_pressed() -> void:
	closePopup()
	pass # Replace with function body.

# Premi yes
func _on_button_yes_pressed() -> void:
	SignalBus.emit_signal("popup_pressed_yes")
	closePopup()
	pass # Replace with function body.

# Premi no
func _on_button_no_pressed() -> void:
	SignalBus.emit_signal("popup_pressed_no")
	closePopup()
	pass # Replace with function body.

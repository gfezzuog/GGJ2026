extends Node2D

@export var text = "Testo del popup"

@export var default_position = Vector2(630.0, 534.0)

func _ready() -> void:
	SignalBus.connect("open_popup", openPopup)

func reset_position():
	self.position = default_position
	
func set_new_position(pos: Vector2):
	self.position = pos

func openPopup(newText):
	setText(newText)
	print("showing popup")
	$Content.show()
	

func closePopup():
	SignalBus.emit_signal("close_popup")
	print("popup chiuso")
	$Content.hide()
	pass


func setText(newText):
	text = newText
	$Content/PanelContainer/Label.text = text


func _on_button_pressed() -> void:
	closePopup()
	pass # Replace with function body.

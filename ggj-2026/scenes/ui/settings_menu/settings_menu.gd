extends Control


@onready var language_picker = $Language/Language/OptionButton


func _ready() -> void:
	var locale = TranslationServer.get_locale()
	var locale_id = _locale_to_id(locale)
	print(locale_id)
	language_picker.select(locale_id)
	

func _locale_to_id(locale: String) -> int:
	if (locale.begins_with("en")):
		return 0
	elif (locale.begins_with("it")):
		return 1
	else:
		return -1
		
func _id_to_locale(id: int) -> String:
	if (id == 0):
		return "en"
	elif (id == 1):
		return "it"
	else:
		return OS.get_locale_language()
	

# Cambio lingua
func _on_option_button_item_selected(index: int) -> void:
	TranslationServer.set_locale(_id_to_locale(index))
	
	
	
# Chiudi menu
func _on_close_button_pressed() -> void:
	# Unpausa gioco
	SignalBus.resume_game.emit()
	queue_free()

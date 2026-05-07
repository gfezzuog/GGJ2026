extends Control


@onready var language_picker = $Language/Language/OptionButton
@onready var volume_slider_music = $Volume/Music/HBoxContainer/HSlider
@onready var volume_slider_effects = $Volume/SoundEffects/HBoxContainer/HSlider

# PARAMETRI
const volume_max = 24.0		# guadagno massimo in generale
const volume_min = - volume_max
const volume_slider_ticks = 11
const volume_slider_step = (volume_max - volume_min) / (volume_slider_ticks - 1)


func _ready() -> void:
	language_picker.select(_locale_to_id(TranslationServer.get_locale()))	
	volume_slider_music.value = Constants.volume_music
	volume_slider_effects.value = Constants.volume_effects
	
	volume_slider_music.max_value = volume_max
	volume_slider_music.min_value = volume_min
	volume_slider_music.tick_count = volume_slider_ticks
	volume_slider_music.step = volume_slider_step
	
	volume_slider_effects.max_value = volume_max
	volume_slider_effects.min_value = volume_min
	volume_slider_effects.tick_count = volume_slider_ticks
	volume_slider_effects.step = volume_slider_step
	

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


# Cambio volume musica
func _on_volume_music_slider_drag_ended(value_changed: bool) -> void:
	if (value_changed):
		print("nuovo volume music: " +  str(volume_slider_music.value))
		SignalBus.set_volume_music.emit(volume_slider_music.value)
		Constants.volume_music = volume_slider_music.value
	
	
# Cambio volume effetti
func _on_volume_effects_slider_drag_ended(value_changed: bool) -> void:
	if (value_changed):
		print("nuovo volume effects: " +  str(volume_slider_effects.value))
		SignalBus.set_volume_effects.emit(volume_slider_effects.value)
		Constants.volume_effects = volume_slider_effects.value
	
	
# Chiudi menu
func _on_close_button_pressed() -> void:
	# Unpausa gioco
	SignalBus.resume_game.emit()
	queue_free()

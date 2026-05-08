extends Control


@onready var language_picker = $Language/Language/OptionButton

@onready var volume_slider_music = $Volume/Music/HBoxContainer/HSlider
@onready var volume_slider_effects = $Volume/SoundEffects/HBoxContainer/HSlider


# PARAMETRI
const volume_max = 0.0		# guadagno massimo in generale
const volume_min = - 30.0
const volume_slider_ticks = 11
const volume_slider_step = (volume_max - volume_min) / (volume_slider_ticks - 1)


func _ready() -> void:
	
	#volume_slider_music = get_node("Volume/Music/HBoxContainer/HSlider")
	
	language_picker.select(_locale_to_id(TranslationServer.get_locale()))	
	
	# Imposta parametri
	volume_slider_music.max_value = volume_max
	volume_slider_music.min_value = volume_min
	volume_slider_music.tick_count = volume_slider_ticks
	volume_slider_music.step = volume_slider_step
	
	volume_slider_effects.max_value = volume_max
	volume_slider_effects.min_value = volume_min
	volume_slider_effects.tick_count = volume_slider_ticks
	volume_slider_effects.step = volume_slider_step
	
	
	#print("all'apertura risulta volume musica " + str(Constants.volume_music) + " e volume effetti " + str(Constants.volume_effects))
	
	# Imposta i valori degli slider
	volume_slider_music.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index(Constants.AUDIO_BUS_MUSIC_NAME))
	volume_slider_effects.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index(Constants.AUDIO_BUS_EFFECTS_NAME))
	

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
		var bus_idx = AudioServer.get_bus_index(Constants.AUDIO_BUS_MUSIC_NAME)
		AudioServer.set_bus_volume_db(bus_idx, volume_slider_music.value)				# imposta volume
		AudioServer.set_bus_mute(bus_idx, volume_slider_music.value <= volume_min)		# muta / attiva se raggiungi o no il volume minimo
				
	
# Cambio volume effetti
func _on_volume_effects_slider_drag_ended(value_changed: bool) -> void:
	if (value_changed):
		var bus_idx = AudioServer.get_bus_index(Constants.AUDIO_BUS_EFFECTS_NAME)
		AudioServer.set_bus_volume_db(bus_idx, volume_slider_effects.value)				# imposta volume
		AudioServer.set_bus_mute(bus_idx, volume_slider_effects.value <= volume_min)		# muta / attiva se raggiungi o no il volume minimo

	
	
# Chiudi menu
func _on_close_button_pressed() -> void:
	# Unpausa gioco
	SignalBus.resume_game.emit()
	queue_free()

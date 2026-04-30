extends Node2D


## Lista delle scene dei livelli
@export var levels: Array[PackedScene]

## Lista dei nomi dei livelli da tenere coerente con la lista sopra
@export var level_names: Array[String]

## Nodo della tab di un livello
@export var levelTabScene: PackedScene

## indice livello attivo
var current_level_index: int = -1

## istanza livello attivo
var current_level = null

## colore tab attiva
var active_tab_color = Color.WHITE
var style_active_tab: StyleBoxFlat = null


func _reload_current_level() -> void:
	if current_level == null:
		return

	print("Reload level ", current_level_index)

	# Distruggi livello corrente
	current_level.queue_free()
	current_level = null

	# Istanzia di nuovo lo stesso livello
	current_level = levels[current_level_index].instantiate()
	$LevelContainer.call_deferred("add_child", current_level)


func _ready() -> void:
	## Inizializza i livelli
	_go_to_next_level()
	
	## Inizializza tab
	_initiate_level_tabs()
	
	## Connetti i segnali
	SignalBus.door_reached.connect(_go_to_next_level)
	SignalBus.game_over.connect(_on_game_over)
	
	#SignalBus.open_popup_ok.emit("Stai iniziando un livello")


func _on_game_over():
	_reload_current_level()


## Per ogni livello disegna una tab sopra col nome del livello
func _initiate_level_tabs() -> void:
	
	for i in range(current_level_index, levels.size()):
		## Istanzia tab
		var newTab = levelTabScene.instantiate()
		
		## Cambia il nome del livello nella tab
		newTab.get_node("Name").text = _get_level_name(i)
		
		## Rendi colorato il pannello del livello attivo
		if (i == current_level_index):
			style_active_tab = newTab.get_theme_stylebox("panel").duplicate()
			style_active_tab.set("bg_color", active_tab_color)
			newTab.add_theme_stylebox_override("panel", style_active_tab)
			
		## Aggiungi tab come figlia di LevelTabs
		$LevelTabs.add_child(newTab)


## da cambiare con funzione che prende il campo col nome dall'oggetto livello
func _get_level_name(index: int) -> String:
	if (index >= 0 && index < level_names.size()):
		return level_names[index]
	return("")


func _go_to_next_level() -> void:
	current_level_index += 1
	
	# se hai finito
	if (current_level_index > levels.size() -1):
		current_level.queue_free()
		var tabs = $LevelTabs.get_children()
		tabs[current_level_index - 1].queue_free()
		finish_game()
	else:
		print("loading level " + str(current_level_index))
		
		# prendi le tabs
		var tabs = $LevelTabs.get_children()
		
		# distruggi livello precedente
		if (current_level != null):
			current_level.queue_free()
			# distruggi tab
			tabs[current_level_index - 1].queue_free()
		
		# istanzia nuovo livello come figlio del container per i livelli
		current_level = levels[current_level_index].instantiate()
		$LevelContainer.call_deferred("add_child", current_level)

		# cambia colore della nuova tab
		if (current_level_index < tabs.size()):
			tabs[current_level_index].add_theme_stylebox_override("panel", style_active_tab)


func finish_game():
	SignalBus.open_popup_ok.emit("Hai vinto!!!!!")


## Pulsante reload livello
func _on_pulsante_reload_livello_pressed() -> void:
	_reload_current_level()


## Pulsante chiusura gioco
func _on_pulsante_chiusura_gioco_pressed() -> void:
	## Prima mi connetto alle risposte
	SignalBus.popup_pressed_yes.connect(close_game)
	SignalBus.popup_pressed_no.connect(do_not_close_game)
	
	## Poi mando il segnale
	SignalBus.open_popup_yes_no.emit("Are you sure you want to quit the game?")


func close_game():
	get_tree().quit()


func do_not_close_game():
	SignalBus.popup_pressed_yes.disconnect(close_game)
	SignalBus.popup_pressed_no.disconnect(do_not_close_game)

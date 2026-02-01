extends Node2D


# Lista delle scene dei livelli
@export var levels: Array[PackedScene]
# Lista dei nomi dei livelli da tenere coerente con la lista sopra
@export var levelNames: Array[String]

# Nodo della tab di un livello
@export var levelTabScene: PackedScene

# indice livello attivo
var currentLevelIndex: int = -1
# istanza livello attivo
var currentLevel = null

# colore tab attiva
var activeTabColor = Color(0.231, 0.47, 0.465, 1.0)
var styleActiveTab: StyleBoxFlat = null


func _ready() -> void:
	
	# Inizializza i livelli
	_goToNextLevel()
	
	# Inizializza tab
	_initiateLevelTabs()
	
	# Connetti i segnali
	SignalBus.connect("doorReached", _goToNextLevel)
	SignalBus.connect("game_over", _on_game_over)
	
func _on_game_over():
	print("Reinstanziando scena...")
	get_tree().reload_current_scene()

# Per ogni livello disegna una tab sopra col nome del livello
func _initiateLevelTabs() -> void:
	#var levelTabs: Array[Node] = []
	
	for i in range(currentLevelIndex, levels.size()):
		# Istanzia tab
		var newTab = levelTabScene.instantiate()
		
		# Cambia il nome del livello nella tab
		newTab.get_node("Name").text = _getLevelName(i)
		
		# Rendi colorato il pannello del livello attivo
		if (i == currentLevelIndex):
			styleActiveTab = newTab.get_theme_stylebox("panel").duplicate()
			styleActiveTab.set("bg_color", activeTabColor)
			newTab.add_theme_stylebox_override("panel", styleActiveTab)
			
		# Aggiungi tab come figlia di LevelTabs
		$LevelTabs.add_child(newTab)


# da cambiare con funzione che prende il campo col nome dall'oggetto livello
func _getLevelName(index: int) -> String:
	if (index >= 0 && index < levelNames.size()):
		return levelNames[index]
	return("")


func _goToNextLevel() -> void:
	currentLevelIndex += 1
	
	# se hai finito
	if (currentLevelIndex > levels.size() -1):
		finishGame()
	else:
		print("loading level " + str(currentLevelIndex))
		
		# prendi le tabs
		var tabs = $LevelTabs.get_children()
		
		# distruggi livello precedente
		if (currentLevel != null):
			currentLevel.queue_free()
			# distruggi tab
			tabs[0].queue_free()
		
		# istanzia nuovo livello come figlio del container per i livelli
		currentLevel = levels[currentLevelIndex].instantiate()
		$LevelContainer.add_child(currentLevel)
		
		# cambia colore della nuova tab
		if (currentLevelIndex < tabs.size()):
			tabs[currentLevelIndex].add_theme_stylebox_override("panel", styleActiveTab)


func finishGame():
	print("hai vinto")
	pass

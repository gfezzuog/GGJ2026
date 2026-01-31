extends Node2D

#@export var levels: Array[Node2D] = []
@export var levels: Array[String] = ["ciao","livello 2","livello 3"]

# Nodo della tab di un livello
@export var levelTabScene: PackedScene

# indice livello attivo
var currentLevel: int = 0

# colore tab attiva
var activeTabColor = Color(0.231, 0.47, 0.465, 1.0)
var styleActiveTab: StyleBoxFlat = null

# Per ogni livello disegna un trapezio sopra col nome del livello
func _ready() -> void:
	# Inizializza tab
	_initiateLevelTabs()
	
	# TEMP: se clicchi sul pulsante vai al livello dopo
	$Button.pressed.connect(goToNextLevel)
	
	pass


func _initiateLevelTabs() -> void:
	#var levelTabs: Array[Node] = []
	
	for i in range(currentLevel, levels.size()):
		# Istanzia tab
		var newTab = levelTabScene.instantiate()
		
		# Cambia il nome del livello nella tab
		newTab.get_node("Name").text = _getLevelName(i)
		
		# Rendi colorato il pannello del livello attivo
		if (i == currentLevel):
			styleActiveTab = newTab.get_theme_stylebox("panel").duplicate()
			styleActiveTab.set("bg_color", activeTabColor)
			newTab.add_theme_stylebox_override("panel", styleActiveTab)
			
		# Aggiungi tab come figlia di LevelTabs
		$LevelTabs.add_child(newTab)

# da cambiare con funzione che prende il campo col nome dall'oggetto livello
func _getLevelName(index: int) -> String:
	if (index >= 0 && index < levels.size()):
		return levels[index]
	return("")


func goToNextLevel() -> void:
	currentLevel += 1
	
	# se hai finito
	if (currentLevel > levels.size() -1):
		finishGame()
	else:
		loadLevel(currentLevel)
		
	
func loadLevel(level: int) -> void:
	print("loading level " + str(level))
	# istanzia nuovo livello
	
	# distruggi livello attuale
	
	# distruggi tab e cambia colore della tab dopo
	var tabs = $LevelTabs.get_children()
	if (tabs.size() > 1):
		tabs[1].add_theme_stylebox_override("panel", styleActiveTab)
	tabs[0].queue_free()

	# ridisegna trapezi
	# ...
	pass
		
func finishGame():
	print("hai vinto")
	pass

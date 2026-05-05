@tool
extends Control

@export var level_indx: int = 0 : set = _set_level_indx
@export var levels: int = 3		# quantita' totale di livelli
var player: Player
var level: Level

var menu_levels_scene_path = "res://scenes/ui/levels_menu/levels_menu.tscn"

var latest_level_unblocked: int = 0


func _ready() -> void:
	SignalBus.door_reached.connect(_on_door_reached)
	SignalBus.door_reached_animation_ended.connect(_on_door_reached_animation_ended)
	
	SignalBus.resume_game.connect(_resume_game)
	SignalBus.restart_level.connect(_restart_level)
	SignalBus.open_menu_levels.connect(_open_menu_levels)
	SignalBus.go_to_level.connect(_go_to_level)
	
	
	player = load("res://scenes/old_components/player/player.tscn").instantiate()
	_load_level(level_indx)
	_preload_level(level_indx+1)


func _set_level_indx(new_value: int) -> void:
	level_indx = new_value
	if is_inside_tree():
		_load_level(level_indx)
		_preload_level(level_indx+1)


func _set_player() -> void:
	level.add_player(player)


func _preload_level(indx: int) -> void:
	var l_name: String = "level_" + str(indx)
	var resource_path: String = "res://resources/levels/" + l_name + ".tres"
	var level_path: String = "res://scenes/game/levels/" + l_name + "/" + l_name + ".tscn"
	if FileAccess.file_exists(resource_path) and FileAccess.file_exists(level_path):
		ResourceLoader.load_threaded_request(resource_path)
		ResourceLoader.load_threaded_request(level_path)


func _restart_level() -> void:
	### TODO: se restarti quando sei posato sopra delle spine nascoste da una maschera,
	### quando rimette 
	level.put_player_in_starting_position()
	_reset_masks()


func _reset_masks() -> void:
	for l in $NewUI.n_layers:
		level.reset_mask(l)
		

func _load_level(indx: int) -> void:
	latest_level_unblocked = max(latest_level_unblocked, indx)
	
	var l_name: String = "level_" + str(indx)
	
	$NewUI.reset()
	var resource_path: String = "res://resources/levels/" + l_name + ".tres"
	var level_path: String = "res://scenes/game/levels/" + l_name + "/" + l_name + ".tscn"
	
	if FileAccess.file_exists(resource_path) and FileAccess.file_exists(level_path):
		var resource: LevelData = load(resource_path)
		level = load(level_path).instantiate()
		
		$NewUI.set_n_layers(resource.layers.size())
		$NewUI.set_disability(resource.layers)
		$NewUI.set_textures(resource.layers_textures)
		$NewUI.set_masks(resource.masks)
		
		$LevelContainer.add_child(level)
	
	var logic_path = "res://scenes/game/levels/level_"+str(indx)+"/logic.gd"
	if FileAccess.file_exists(logic_path):
		var script: Script = load(logic_path)
		$Logic.set_script(script)
		$Logic.init()

	level.add_player(player)


func _open_menu_levels() -> void:
	_pause_game()
	var menu = load(menu_levels_scene_path).instantiate()
	var unblocked = latest_level_unblocked + 1
	menu.set_levels(unblocked, levels - unblocked)
	add_child(menu)
	

func _on_door_reached(door_x, _door_y) -> void:
	player.animate_toward_door(door_x)


func _on_door_reached_animation_ended() -> void:
	_go_to_level(level_indx + 1)


func _go_to_level(indx: int) -> void:
	if (indx != level_indx):
		level.remove_player()
		$LevelContainer.get_child(0).queue_free()
		_set_level_indx.call_deferred(indx)


func _pause_game() -> void:
	print("gioco in pausa")
	player.deactivate()
	
func _resume_game() -> void:
	print("gioco ripreso")
	player.activate()

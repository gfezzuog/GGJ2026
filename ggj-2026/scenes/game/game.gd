@tool
extends Control

@export var level_indx: int = 0 : set = _set_level_indx
@export var levels: int = 3 ## Quantita' totale di livelli
var player: Player
var level: Level
var logic: Logic
var menu_levels_scene_path = "res://scenes/ui/levels_menu/levels_menu.tscn"
var menu_settings_scene_path = "res://scenes/ui/settings_menu/settings_menu.tscn"
var latest_level_unblocked: int = 0


func _ready() -> void:
	SignalBus.door_reached.connect(_on_door_reached)
	SignalBus.door_reached_animation_ended.connect(_on_door_reached_animation_ended)
	
	SignalBus.resume_game.connect(_resume_game)
	SignalBus.restart_level.connect(_restart_level)
	SignalBus.open_menu_levels.connect(_open_menu_levels)
	SignalBus.open_menu_settings.connect(_open_menu_settings)
	SignalBus.go_to_level.connect(_change_level)
	
	player = load("res://scenes/game/components/player/player.tscn").instantiate()
	
	# Imposta volumi iniziali
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(Constants.AUDIO_BUS_MUSIC_NAME), Constants.INITIAL_VOLUME_MUSIC)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(Constants.AUDIO_BUS_EFFECTS_NAME), Constants.INITIAL_VOLUME_EFFECTS)
	
	if level_indx == -1:
		_start_main_page()
	else:
		if level_indx <= levels - 1:
			_start_level(level_indx)
	if level_indx < levels - 1:
		_load_resources(_get_level_resource_paths(level_indx+1))


func _set_level_indx(new_value: int) -> void:
	level_indx = new_value
	if is_inside_tree():
		if level_indx == -1:
			_start_main_page()
		else:
			if level_indx <= levels - 1:
				_start_level(level_indx)
		if level_indx < levels - 1:
			_load_resources(_get_level_resource_paths(level_indx +1))


#region LOAD

func _load_resources(paths: Array[String]) -> void:
	for p in paths:
		ResourceLoader.load_threaded_request(p)


func _check_load(resources_path: Array[String]) -> bool:
	for p in resources_path:
		var status = ResourceLoader.load_threaded_get_status(p)
		
		if status == ResourceLoader.THREAD_LOAD_FAILED:
			push_error("Failed loading: " + p)
			return false
		
		if status != ResourceLoader.THREAD_LOAD_LOADED:
			return false
	
	return true


func _get_level_resource_paths(indx: int) -> Array[String]:
	var paths: Array[String] = []
	
	var l_name: String = "level_" + str(indx)
	paths.push_back("res://resources/levels/" + l_name + ".tres")
	paths.push_back("res://scenes/game/levels/" + l_name + "/" + l_name + ".tscn")
	if ResourceLoader.exists("res://scenes/game/levels/level_"+str(indx)+"/logic.gd"):
		paths.push_back("res://scenes/game/levels/level_"+str(indx)+"/logic.gd")
	
	return paths

#endregion


#region START

func _start_main_page() -> void:
	$LevelContainer.hide()
	$NewUI.empty_visualitazion = true


func _start_level(indx: int) -> void:
	latest_level_unblocked = max(latest_level_unblocked, indx)
	
	var resources_paths: Array[String] = _get_level_resource_paths(indx)
	_load_resources(resources_paths)
	while not _check_load(resources_paths):
		await get_tree().process_frame
	
	var level_data: LevelData = load(resources_paths[0])
	$NewUI.level_data = level_data
	
	level = load(resources_paths[1]).instantiate()
	$LevelContainer.add_child(level)
	
	logic = Logic.new()
	if resources_paths.size() == 3:
		var script: Script = load(resources_paths[2])
		logic.set_script(script)
		logic.level = level
	$Logic.add_child(logic)
	
	level.add_player(player)
	level.init()
	logic.init()
	$NewUI.init_level()


func _restart_level() -> void:
	logic.reset()
	$NewUI.reset_level()
	level.reset()
	level.init()
	$NewUI.init_level()
	logic.init()


func _change_level(indx: int, _show_dialog: bool = true) -> void:
	$NewUI.reset()
	#level.reset()
	#logic.reset()
	$Logic.remove_child(logic)
	logic.queue_free()
	logic = null
	
	level.remove_player()		# sgancia player come figlio di level cosi' non viene eliminato insieme a level
	$LevelContainer.remove_child(level)
	level.queue_free()
	
	_set_level_indx.call_deferred(indx)

#endregion


#region GAME-UI INTERACTIONS

func _open_menu_levels() -> void:
	_pause_game()
	var menu = load(menu_levels_scene_path).instantiate()
	var unblocked = latest_level_unblocked + 1
	menu.set_levels(unblocked, levels - unblocked)
	add_child(menu)
	
	
func _open_menu_settings() -> void:
	_pause_game()
	var menu = load(menu_settings_scene_path).instantiate()
	add_child(menu)


func _on_door_reached(door_x, _door_y) -> void:
	player.animate_toward_door(door_x)


func _on_door_reached_animation_ended() -> void:
	_change_level(level_indx + 1, true)


func _pause_game() -> void:
	player.deactivate()


func _resume_game() -> void:
	player.activate()


func _on_start_button_pressed() -> void:
	$MainPage.queue_free()
	$StartButton.queue_free()
	if level_indx == -1:
		$LevelContainer.show()
		$NewUI.empty_visualitazion = false
		level_indx = 0

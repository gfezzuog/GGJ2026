class_name Level extends Control

const GRID_SIZE := 21
const CELL_SIZE := 46
const SCREEN_SIZE := 966  # opzionale, solo per controllo

@export var level_id: int = 0
var grid := []


func _ready():
	init_grid()
	
	for child in $HBoxContainer/Canvas/Objs.get_children():
		place_object(child)
	
	# collega segnale su maschera abilitata
	SignalBus.mask_enabled.connect(apply_mask)
	SignalBus.mask_disabled.connect(disable_mask)
	
	var levelInfo: LevelInfo = load("res://resources/data/data_loader.tres")
	var level1 = levelInfo.get_level_info(level_id)
	
	# Crea maschera
	%LayersMenu.mask_textures = [[], [], [], [], []]
	
	var masks = level1["masks"]
	for mask in masks:
		var coordinates: Array[Vector2i]
		for coord in mask["coordinates"]:
			coordinates.push_back(Vector2i(int(coord.y), int(coord.x)))
		%LayersMenu.mask_textures[mask["starting-layer"]] = coordinates
	%LayersMenu.create_masks()


func init_grid():
	grid.clear()
	
	for y in GRID_SIZE:
		var row := []
		for x in GRID_SIZE:
			row.append([])
		grid.append(row)


func place_object(obj: Obj) -> bool:
	if ((obj.pos.x + obj.size.x > GRID_SIZE) or (obj.pos.y + obj.size.y > GRID_SIZE)):
		printerr("stai posizionando un oggetto fuori dalla griglia")
	
	obj.position = obj.pos * CELL_SIZE
	obj.get_child(0).position = -obj.position
	
	for i in obj.size.y:
		for j in obj.size.x:
			var obj_abs_pos = obj.pos + obj.collision_pos
			grid[obj_abs_pos.y+ i][obj_abs_pos.x + j].append(obj)
	
	return true


## Level si connette al segnale mask_enabled che ci passa la maschera, e il layer su cui e' attiva
func apply_mask(mask: Mask, layer: int):
	var objects_that_must_be_removed = []
	
	for coord in mask.coords:
		var list_ob = grid[coord.y][coord.x]
		for ob in list_ob:
			if (ob and ob.layer == layer):
				if ob not in objects_that_must_be_removed:
					objects_that_must_be_removed.append(ob)
	
	for ob in objects_that_must_be_removed:
		ob.apply_mask(mask.coords)


func disable_mask(mask: Mask, layer: int):
	var objects_that_must_be_removed = []
	
	for coord in mask.coords:
		var list_ob = grid[coord.y][coord.x]
		for ob in list_ob:
			if (ob and ob.layer == layer):
				if ob not in objects_that_must_be_removed:
					objects_that_must_be_removed.append(ob)
	
	for ob in objects_that_must_be_removed:
		ob.disable_mask(mask.coords)

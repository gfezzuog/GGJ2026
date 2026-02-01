extends Level

var grid_2  := []

func _ready() -> void:
	super()
	init_grid_2()
	place_object_2($HBoxContainer/Canvas/Objs/spine_sx)
	place_object_2($HBoxContainer/Canvas/Objs/spine_dx)
	
	var levelInfo: LevelInfo = load("res://Resources/level_resource.tres")
	var level2 = levelInfo.get_level_info(2)
	#print(level1["masks"])
	
	# Crea collisioni degli oggetti nascondibili con maschere
	var objects = level2["objects"]
	for obj in objects:
		var name = obj["name"]
		#var matrix = obj["matrix"]
		var matrix: Array[int] = []
		for elem in obj["matrix"]:
			matrix.append(int(elem))
		
		var node: Obj = get_node("HBoxContainer/Canvas/Objs/" + name)
		print(node)
		print(matrix)
		node.createCollisionShapes(matrix)
	
	# Crea maschera
	%LayersMenu.mask_textures = [[], [], [], [], []]
	
	var masks = level2["masks"]
	for mask in masks:
		var coordinates: Array[Vector2i]
		for coord in mask["coordinates"]:
			coordinates.push_back(Vector2i(int(coord.y), int(coord.x)))
		%LayersMenu.mask_textures[mask["starting-layer"]] = coordinates
		#%LayersMenu.layers_row[1].mask.disabled = true
	%LayersMenu.create_masks()
	%LayersMenu.layers_row[0].disabled = true


func place_object_2(obj) -> bool:
	if ((obj.pos[0] + obj.size[0] > GRID_SIZE) or (obj.pos[1] + obj.size[1] > GRID_SIZE)):
		printerr("stai posizionando un oggetto fuori dalla griglia")
		pass
		
	obj.position = obj.pos * CELL_SIZE
	obj.get_child(0).position = -obj.position
	
	for i in obj.size.x:
		#print("valore di i ", i)
		for j in obj.size.y:
			#print("valore di j ", j)
			grid[obj.pos.x + i][obj.pos.y + j] = obj
	#for i in obj.size.x:
		#for j in obj.size.y:
			#print(grid[obj.pos.x + i][obj.pos.y + j])
	#print(grid)	#print(mask)
	return true


func _applyMask(grid_to_compute, mask: Mask, layer: int):
	var objectsThatMustBeRemoved = []
	for coord in mask.coords:
		
		var ob = grid_to_compute[coord.x][coord.y]
		#print("layer di apply mask")
		#print(layer)
		if (ob and ob.layer == layer):
			if ob not in objectsThatMustBeRemoved:
				objectsThatMustBeRemoved.append(ob)
	
		# qua sotto e' se grid contiene liste
		#var objects = grid[coord.x][coord.y]
		#print(objects)
		#for ob in objects:
			#if (ob.layer == layer):
				#if ob not in objectsThatMustBeRemoved:
					#objectsThatMustBeRemoved.append(ob)
					
	for ob in objectsThatMustBeRemoved:
		ob.applyMask(mask.coords)


func applyMask(mask: Mask, layer: int):
	_applyMask(grid, mask, layer)
	_applyMask(grid_2, mask, layer)


func init_grid_2():
	grid_2.clear()
	for y in GRID_SIZE:
		var row := []
		for x in GRID_SIZE:
			row.append(null)
		grid_2.append(row)
		
func disableMask(mask: Mask, layer: int):
	_disableMask(grid, mask, layer)
	_disableMask(grid_2, mask, layer)
		
func _disableMask(grid_to_process, mask: Mask, layer: int):
	var objectsThatMustBeRemoved = []
	for coord in mask.coords:
		var ob = grid[coord.x][coord.y]
		if (ob and ob.layer == layer):
			if ob not in objectsThatMustBeRemoved:
				objectsThatMustBeRemoved.append(ob)
	for ob in objectsThatMustBeRemoved:
		ob.disableMask(mask.coords)

#func _on_exit_area_body_entered(body: Node2D) -> void:
	#SignalBus.emit_signal("game_over")
	#pass # Replace with function body.

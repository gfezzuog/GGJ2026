extends Level


func _ready() -> void:
	super()
	
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
		node.create_collision_shapes(matrix)
	
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

extends Level


func _ready() -> void:
	super()
	
	print("LayersMenu position: ", %LayersMenu.position)
	
	var levelInfo: LevelInfo = load("res://Resources/level_resource.tres")
	var level1 = levelInfo.get_level_info(0)
	#print(level1["masks"])
	
	# Crea collisioni degli oggetti nascondibili con maschere
	var objects = level1["objects"]
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
	
	var masks = level1["masks"]
	for mask in masks:
		var coordinates: Array[Vector2i]
		for coord in mask["coordinates"]:
			coordinates.push_back(Vector2i(int(coord.y), int(coord.x)))
		%LayersMenu.mask_textures[mask["starting-layer"]] = coordinates
	%LayersMenu.create_masks()
	
	var rows: Array[LayerMenuRow] = %LayersMenu.layers_row
	for row in rows:
		row.rotation_disabled = true
	
	pass # Replace with function body.

func _on_exit_area_body_entered(_body: Node2D) -> void:
	$HBoxContainer/Canvas/Player.game_over()

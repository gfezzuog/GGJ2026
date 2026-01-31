extends Level


func _ready() -> void:
	super()
	
	var levelInfo: LevelInfo = load("res://Resources/level_resource.tres")
	var level1 = levelInfo.get_level_info(1)
	print(level1["masks"])
	
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
		
		
		
	pass # Replace with function body.

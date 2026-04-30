extends Resource
class_name LevelInfo

var level_path: String = "res://resources/data/levels_info.json"
var object_path: String = "res://resources/data/objects_info.json"
var level_data: Dictionary
var obj_data: Dictionary


func _init() -> void:
	_init_levels()
	_init_objects()


func _init_levels():
	var file = FileAccess.open(level_path, FileAccess.READ)
	var data = file.get_as_text()
	
	file.close()
	level_data = JSON.parse_string(data)
	for level in level_data.values():
		var masks = level["masks"]
		for mask in masks:
			var coordinates = mask["coordinates"]
			var new_coordinates: Array[Vector2i]
			for coordinate in coordinates:
				new_coordinates.append(Vector2i(coordinate[0], coordinate[1]))
			mask["coordinates"] = new_coordinates


func _init_objects():
	var file = FileAccess.open(object_path, FileAccess.READ)
	var data = file.get_as_text()
	
	file.close()
	obj_data = JSON.parse_string(data)


func get_level_info(level: int):
	var label = str(level)
	return level_data[label]


func get_object_info(obj_name: String):
	return obj_data[obj_name]


func get_object_active_relative_coordinates(obj_name: String) -> Array[Vector2i]:
	var matrix = obj_data[obj_name]["matrix"]
	var shape = obj_data[obj_name]["shape"]
	
	var coordinates: Array[Vector2i] = []
	for i in shape[1]:
		for j in shape[0]:
			var value = matrix[i*shape[0] + j]
			if value == 1:
				coordinates.append(Vector2i(j, i))
	
	return coordinates

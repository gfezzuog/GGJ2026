extends Resource
class_name LevelInfo

var file_path: String = "res://Resources/levels_info.json"
var file_data: Dictionary

func get_level_info(level):
	var label = str(level)
	return file_data[label]
	
func _init() -> void:
	var data: String
	var json: JSON
	var file = FileAccess.open(file_path, FileAccess.READ)
	print(file)
	data = file.get_as_text()
	file.close()
	json = JSON.new()
	file_data = JSON.parse_string(data)
	for level in file_data.values():
		var masks = level["masks"]
		for mask in masks:
			var coordinates = mask["coordinates"]
			var new_coordinates: Array[Vector2]
			for coordinate in coordinates:
				new_coordinates.append(Vector2i(coordinate[0], coordinate[1]))
			mask["coordinates"] = new_coordinates
		#print(masks)

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

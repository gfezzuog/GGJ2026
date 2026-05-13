class_name TextData extends Resource


class TextBlock:
	var speaker: String
	var text: String
	var id: String
	var auto_progess: bool = true

	func _init(_speaker: String, _text: String, _id: String, _auto_progess: bool = true):
		speaker = _speaker
		text = _text
		id = _id
		auto_progess = _auto_progess


@export var ids: Array[String]
@export var speakers: Array[String]
@export var json_params_path: String
@export var auto_progess: Array[bool]
var texts: Array[TextBlock] = []
var counter: int = 0
var params_dictionary: Dictionary


func init() -> void:
	for i in ids.size():
		
		var speaker: String
		if speakers.size() == 1:
			speaker = speakers[0]
		elif speakers.size() == 0:
			speaker = ""
		elif speakers.size() == ids.size():
			speaker = speakers[i]
		else:
			speaker = speakers[i] if i < speakers.size() else speakers[speakers.size() - 1]
		
		var auto: bool
		if auto_progess.size() == 0:
			auto = true
		elif auto_progess.size() == 1:
			auto = auto_progess[0]
		elif auto_progess.size() < ids.size():
			auto = auto_progess[i] if i < auto_progess.size() else auto_progess[-1]
		else:
			auto = auto_progess[i]
		
		texts.append(TextBlock.new(speaker, ids[i], ids[i], auto))
	
	params_dictionary = _load_json(json_params_path)


func _load_json(json_path: String) -> Variant:
	var file = FileAccess.open(json_path, FileAccess.READ)
	var json_string = file.get_as_text()
	var json = JSON.new()
	var error = json.parse(json_string)
	if error == OK:
		var data_received = json.data
		if typeof(data_received) == TYPE_DICTIONARY:
			return data_received
		else:
			print("Unexpected data")
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
	return null


func get_next_text() -> TextBlock:
	if counter >= texts.size():
		return null
	
	var text_block: TextBlock = texts[counter]
	var speaker = tr(text_block.speaker)
	
	var params = []
	if params_dictionary.has(text_block.id):
		var dict: Dictionary = params_dictionary[text_block.id]
		var lang = TranslationServer.get_locale()
		if dict.has(lang):
			params = dict[lang]
		else:
			params = dict["default"]
	
	var text = tr(text_block.text) % params
	var id = text_block.id
	counter += 1
	return TextBlock.new(speaker, text, id, text_block.auto_progess)


func reset() -> void:
	texts.clear()
	counter = 0

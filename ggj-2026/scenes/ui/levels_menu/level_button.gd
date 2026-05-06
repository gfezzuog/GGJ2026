#@tool
class_name LevelButton extends Control

signal pressed_indx(indx: int)

var level: int

func _ready() -> void:
	$Button.pressed.connect(_on_button_pressed)
	pass

func set_level_index(n: int):
	level = n
	$Control/LevelName.text = "Level " + str(n)
	$Control/LevelNumber.text = str(n)

func _on_button_pressed() -> void:
	print("pressed")
	pressed_indx.emit(level)

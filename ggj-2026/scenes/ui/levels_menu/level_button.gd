@tool
class_name LevelButton extends Control

func set_level_index(n: int):
	$Control/LevelName.text = "Level " + str(n)

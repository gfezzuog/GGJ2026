extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var pippo: LevelInfo = load("res://Resources/level_resource.tres")
	print(pippo.get_level_info(1))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

extends TextureRect

var dimension: Vector2 = Vector2(50, 50)


func _ready() -> void:
	global_position = get_global_mouse_position()
	size = dimension
	$Area2D/CollisionShape2D.shape.size = dimension


func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()

extends TextureRect

var dimension: Vector2 = Vector2(50, 50)
var reference_mask: Mask : set = _set_reference_mask


func _ready() -> void:
	global_position = get_global_mouse_position()
	size = dimension
	$Panel.size = size
	$Area2D/CollisionShape2D.shape.size = dimension


func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()


func _set_reference_mask(new_mask: Mask):
	reference_mask = new_mask
	texture = new_mask.texture

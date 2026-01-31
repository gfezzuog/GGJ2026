extends Area2D

@onready var sprite := get_parent().get_node("Sprite2D")
@onready var mat := sprite.material as ShaderMaterial
@onready var shape : RectangleShape2D = $CollisionShape2D.shape

func _process(_delta):
	if sprite.texture == null:
		return

	var tex_size = sprite.texture.get_size()
	var sprite_rect = Rect2(Vector2.ZERO, tex_size) # rettangolo UV base

	# coordinate locali dello sprite considerando pivot
	var top_left_local = sprite.to_local(global_position - shape.extents)
	var bottom_right_local = sprite.to_local(global_position + shape.extents)

	# conversione in UV 0-1, clamping
	var uv_top_left = Vector2(
		clamp(top_left_local.x / tex_size.x + 0.5, 0.0, 1.0),
		clamp(1.0 - (top_left_local.y / tex_size.y + 0.5), 0.0, 1.0)
	)
	var uv_bottom_right = Vector2(
		clamp(bottom_right_local.x / tex_size.x + 0.5, 0.0, 1.0),
		clamp(1.0 - (bottom_right_local.y / tex_size.y + 0.5), 0.0, 1.0)
	)

	mat.set_shader_parameter("mask_top_left", uv_top_left)
	mat.set_shader_parameter("mask_bottom_right", uv_bottom_right)

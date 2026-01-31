extends Sprite2D

@onready var mat := material as ShaderMaterial
@export var areas: Array[Area2D]
var effect_active := true
const MAX_RECTS := 8

func _process(_delta):

	if Input.is_action_just_pressed("jump"):
		effect_active = !effect_active
	if not effect_active:
		mat.set_shader_parameter("hide", false)
		mat.set_shader_parameter("rect_count", 0)
		return

	var rect_data: Array[Vector4] = []
	
	for area in areas:
		var shape = area.get_node("CollisionShape2D").shape
		if not shape is RectangleShape2D:
			continue
		# Converto la posizione del Marker in UV
		var local = to_local(area.global_position)
		var center_uv = Vector2(
			local.x / texture.get_size().x + 0.5,
			local.y / texture.get_size().y + 0.5
		)

	# Convertiamo la dimensione in UV
		var size_uv = area.get_child(0).shape.size / texture.get_size()
		rect_data.append(Vector4(
			center_uv.x, center_uv.y, size_uv.x, size_uv.y
		))

	# Aggiorniamo lo shader
	mat.set_shader_parameter("rect_count", rect_data.size())
	mat.set_shader_parameter("rects", rect_data)

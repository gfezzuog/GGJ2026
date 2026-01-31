extends Sprite2D

@onready var mat := material as ShaderMaterial
@export var area_path: NodePath
@onready var area := get_node(area_path) as Node2D

var effect_active := true
@export var rect_size := Vector2(50, 50) # grandezza della zona in pixel

func _process(_delta):

	if Input.is_action_just_pressed("jump"):
		if effect_active:
			effect_active = false
		else:
			effect_active = true
			
	if not effect_active:
		mat.set_shader_parameter("hide", false)
		return

	# Converto la posizione del Marker in UV
	#var local = to_local(marker.global_position)
	var local = to_local(area.global_position)
	var uv = Vector2(
		local.x / texture.get_size().x + 0.5,
		local.y / texture.get_size().y + 0.5
	)

	# Convertiamo la dimensione in UV
	var size_uv = area.get_child(0).shape.size / texture.get_size()
	#var size_uv = Vector2(0, 0)

	# Aggiorniamo lo shader
	mat.set_shader_parameter("mask_center_uv", uv)
	mat.set_shader_parameter("mask_size_uv", size_uv)
	mat.set_shader_parameter("hide", true)

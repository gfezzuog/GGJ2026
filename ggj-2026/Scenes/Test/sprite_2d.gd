extends Sprite2D

@export var marker_path: NodePath
@onready var marker := get_node(marker_path) as Node2D
@onready var mat := material as ShaderMaterial

var effect_active = true

func _process(_delta):
	if Input.is_action_just_pressed("jump"):
		if effect_active:
			effect_active = false
		else:
			effect_active = true
	if not effect_active:
		mat.set_shader_parameter("hide", false)
		return
		
	var rect := Rect2(
		global_position - texture.get_size() * 0.5,
		texture.get_size()
	)

	var touching := rect.has_point(marker.global_position)
	mat.set_shader_parameter("hide", touching)

	# opzionale: aggiorna il centro del cerchio al Marker
	var local = to_local(marker.global_position)
	var uv = Vector2(
		local.x / texture.get_size().x + 0.5,
		local.y / texture.get_size().y + 0.5
	)
	mat.set_shader_parameter("mask_center_uv", uv)

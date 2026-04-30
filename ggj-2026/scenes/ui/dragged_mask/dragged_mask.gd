class_name DraggedMask extends Node2D


@export var size := Vector2(160, 160)
@export var mask: Mask = null : set = _set_mask
@export var border_color := Colors.HIGHLIGHT : set = _set_border_color
@export var speed: float = 0.05 : set = _set_speed
var overlapping_containers: Array[MaskContainer] = []
var active_container: MaskContainer = null


func _ready() -> void:
	$PanelContainer/TextureRect.size = size
	$Area2D/CollisionShape2D.shape.size = size
	$PanelContainer/TextureRect.texture = mask.get_texture()
	$DashedBorder.material.set_shader_parameter("color", border_color)
	$DashedBorder.material.set_shader_parameter("speed", speed)
	#$TextureRect.material.set_shader_parameter("color", border_color)
	#$TextureRect.material.set_shader_parameter("speed", speed)


func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()
	update_overlapping()


func _set_mask(new_mask: Mask) -> void:
	mask = new_mask
	if has_node("PanelContainer/TextureRect"):
		$PanelContainer/TextureRect.texture = new_mask.get_texture()


func _set_border_color(new_color: Color) -> void:
	border_color = new_color
	if has_node("PanelContainer/TextureRect"):
		$DashedBorder.material.set_shader_parameter("color", new_color)


func _set_speed(new_speed: float) -> void:
	speed = new_speed
	if has_node("PanelContainer/TextureRect"):
		$DashedBorder.material.set_shader_parameter("speed", new_speed)
 

func update_overlapping() -> void:
	if overlapping_containers.is_empty():
		if active_container:
			active_container.dragged_mask_inside(false)
			active_container = null
		return
	
	var closest = _get_closest_container()
	
	if closest != active_container:
		if active_container:
			active_container.dragged_mask_inside(false)
		active_container = closest
		active_container.dragged_mask_inside(true)


func _get_closest_container():
	var min_dist = INF
	var closest = null

	for ext in overlapping_containers:
		var container_y = ext.global_position.y + (ext.size.y/2)
		var dist = abs(self.global_position.y - container_y)
		if dist < min_dist:
			min_dist = dist
			closest = ext

	return closest

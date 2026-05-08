@tool
class_name MaskContainer extends Control


@export var disabled: bool = false : set = _set_disabled
@export var active: bool = false : set = _set_active
@export var visibility_disabled: bool = false : set = _set_visibility_disabled
@export var rotation_disabled: bool = false : set = _set_rotation_disabled

@export_group("Colors")
@export var color_with_mask := Color("#d3c3b9")
@export var color_no_mask := Colors.BG_SECONDARY
@export var color_disabled := Colors.BG_PRIMARY

@export_group("Border Width")
@export var border_width: float = 5.0
@export var border_width_disabled: float = 3.0

var mask: Mask = null : set = _set_mask
var layer_node: Node = null
var clip_material := ShaderMaterial.new()
var on_mask: bool = false
var dragged_mask_node: DraggedMask = null
@onready var panel: StyleBoxFlat = $MainContainer.get_theme_stylebox("panel")
@onready var inner_panel: StyleBoxFlat = $MainContainer/PanelContainer.get_theme_stylebox("panel")
var timer := Timer.new()


func _ready() -> void:
	var clip_shader: Shader = load("res://resources/shaders/clip_texture_rect.gdshader")
	clip_material.shader = clip_shader
	clip_material.set_shader_parameter("corner_scale", 0.16)
	
	timer.timeout.connect(_on_timer_timeout)
	timer.wait_time = 1.0
	timer.autostart = false
	timer.one_shot = true
	add_child(timer)
	update_status()


func _input(event: InputEvent) -> void:
	if on_mask and event.is_action_pressed("press"):
		#print("sono dentro action_pressed(press) e mask == null")
		$Area2D.monitoring = false
		dragged_mask_node = load("res://scenes/ui/dragged_mask/dragged_mask.tscn").instantiate()
		dragged_mask_node.mask = mask
		add_child(dragged_mask_node)
		$MainContainer/PanelContainer/Mask.modulate.a = 0.5
		$MainContainer/DashedBorder.material.set_shader_parameter("color", Colors.HIGHLIGHT)
		$MainContainer/DashedBorder.material.set_shader_parameter("dash_ratio", 0.8)
	if dragged_mask_node and event.is_action_released("press"):
		$MainContainer/PanelContainer/Mask.modulate.a = 1.0
		$MainContainer/DashedBorder.material.set_shader_parameter("dash_ratio", 1.0)
		$MainContainer/DashedBorder.material.set_shader_parameter("color", Colors.PRIMARY)
		if dragged_mask_node.active_container:
			mask = dragged_mask_node.active_container.mask
			if mask == null:
				print("sono dentro action_released(press) e mask == null")
				$AudioMaskDrop.play()
				active = false
				deactivate()
				$ViewButton.toggle_status = false
			elif !$ViewButton.toggle_status:
				#print("sono dentro action_released(press) e mask != null")
				activate()
			dragged_mask_node.active_container.mask = dragged_mask_node.mask
			dragged_mask_node.active_container.active = true
			if !dragged_mask_node.active_container.get_view_button().toggle_status:
				dragged_mask_node.active_container.activate()
		remove_child(dragged_mask_node)
		dragged_mask_node = null
		$Area2D.monitoring = true


func _set_mask(new_mask: Mask) -> void:
	mask = new_mask
	if mask:
		$MainContainer/PanelContainer/Mask.texture = new_mask.get_texture()
	else:
		$MainContainer/PanelContainer/Mask.texture = null
	
	update_status()


func _set_disabled(new_value: bool) -> void:
	disabled = new_value
	update_status()


func _set_active(new_value: bool) -> void:
	active = new_value
	update_status()


func _set_visibility_disabled(value: bool) -> void:
	visibility_disabled = value
	$ViewButton.disabled = value
	update_status()


func _set_rotation_disabled(value: bool) -> void:
	rotation_disabled = value
	$RotateButton.disabled = value
	update_status()


func update_status() -> void:
	if not is_inside_tree():
		return
	
	if disabled:
		_manage_disabled_status()
	elif active:
		_manage_activated_status()
	else:
		_manage_disactivated_status()


func _manage_disabled_status() -> void:
	$ViewButton.hide()
	$RotateButton.hide()
	$MainContainer/PanelContainer/Mask.hide()
	$Area2D.monitoring = false
	
	for s in ["left", "top", "bottom", "right"]:
		panel.set("border_width_"+s, border_width_disabled)
	panel.set("bg_color", color_disabled)
	
	$MainContainer/DashedBorder.material.set_shader_parameter("dash_ratio", 1.0)
	$MainContainer/DashedBorder.material.set_shader_parameter("color", Colors.PRIMARY)
	
	$Plus.hide()


func _manage_disactivated_status() -> void:
	$ViewButton.show()
	$RotateButton.show()
	$MainContainer/PanelContainer/Mask.hide()
	$Area2D.monitoring = true
	
	$ViewButton.disabled = true
	$RotateButton.disabled = true

	if panel:
		for s in ["left", "top", "bottom", "right"]:
			panel.set("border_width_"+s, border_width)
		panel.set("bg_color", color_no_mask)
	
	$MainContainer/DashedBorder.material.set_shader_parameter("dash_ratio", 0.8)
	$MainContainer/DashedBorder.material.set_shader_parameter("color", Colors.PRIMARY)
	
	$Plus.show()
	
	$MainContainer/PanelContainer/DisabledOverlay.hide()


func _manage_activated_status() -> void:
	$ViewButton.show()
	$RotateButton.show()
	$MainContainer/PanelContainer/Mask.show()
	$Area2D.monitoring = true
	
	if panel:
		for s in ["left", "top", "bottom", "right"]:
			panel.set("border_width_"+s, border_width)
		panel.set("bg_color", color_with_mask)
	
	$ViewButton.disabled = visibility_disabled
	$RotateButton.disabled = rotation_disabled
	if not $ViewButton.toggle_status:
		$MainContainer/PanelContainer/DisabledOverlay.hide()
	else:
		$MainContainer/PanelContainer/DisabledOverlay.show()

	$MainContainer/DashedBorder.material.set_shader_parameter("dash_ratio", 1.0)
	$MainContainer/DashedBorder.material.set_shader_parameter("color", Colors.PRIMARY)
	
	$Plus.hide()


func get_view_button() -> LayerButton:
	return $ViewButton


func get_rotate_button() -> LayerButton:
	return $RotateButton


func activate() -> void:
	if layer_node:
		SignalBus.mask_activated.emit(mask, layer_node.layer_index)


func deactivate() -> void:
	if layer_node:
		SignalBus.mask_disactivated.emit(layer_node.layer_index)


func dragged_mask_inside(value: bool) -> void:
	if value == true:
		$MainContainer/DashedBorder.material.set_shader_parameter("color", Colors.HIGHLIGHT)
	else:
		$MainContainer/DashedBorder.material.set_shader_parameter("color", Colors.PRIMARY)


func reset() -> void:
	disabled = false
	active = false
	mask = null
	visibility_disabled = false
	rotation_disabled = false
	$ViewButton.toggle_status = false


func _on_view_button_pressed(toggle_status: bool) -> void:
	if !toggle_status:
		SignalBus.mask_activated.emit(mask, layer_node.layer_index)
	else:
		SignalBus.mask_disactivated.emit(layer_node.layer_index)
	update_status()


func _on_rotate_button_pressed(_toggle_mode: bool) -> void:
	if mask:
		mask.rotate()
		$MainContainer/PanelContainer/Mask.texture = mask.get_texture()
		if layer_node and !$ViewButton.toggle_status:
			SignalBus.mask_rotated.emit(mask, layer_node.layer_index)


func _on_timer_timeout() -> void:
	SignalBus.show_mask.emit(mask.get_polygons())


func _on_mask_mouse_entered() -> void:
	on_mask = true
	timer.start()


func _on_mask_mouse_exited() -> void:
	on_mask = false
	if timer.is_stopped():
		SignalBus.hide_mask.emit()
	else:
		timer.stop()


func _on_external_area_entered(area: Area2D) -> void:
	var dragged_mask: DraggedMask = area.get_parent()
	dragged_mask.overlapping_containers.append(self)


func _on_external_area_exited(area: Area2D) -> void:
	var dragged_mask: DraggedMask = area.get_parent()
	dragged_mask.overlapping_containers.erase(self)

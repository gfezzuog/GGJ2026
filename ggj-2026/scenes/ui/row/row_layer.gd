@tool
class_name RowLayer extends PanelContainer

@export var layer_texture: Texture = null : set = _set_layer_texture
@export var mask: Mask = null : set = _set_mask_texture
@export var disabled: bool = false : set = _set_disabled
@export var layer_index: int = 1 : set = _set_layer_index
@onready var timer_layer_highligh := Timer.new()


func _ready() -> void:
	$HBoxContainer/MaskContainer.mask = mask
	$HBoxContainer/MaskContainer.disabled = disabled
	%LayerTexture.texture = layer_texture
	%LayerIndex.text = str(layer_index)
	$HBoxContainer/MaskContainer.mask = mask
	$HBoxContainer/MaskContainer.layer_node = self
	$HBoxContainer/Attach.visible = not disabled
	timer_layer_highligh.wait_time = 0.5
	timer_layer_highligh.autostart = false
	timer_layer_highligh.one_shot = true
	timer_layer_highligh.timeout.connect(_on_timer_layer_timeout)
	add_child(timer_layer_highligh)


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		#if mask and mask.texture == null:
		#	mask.texture = mask.generate_texture(mask.coords)
		#if $HBoxContainer/MaskContainer.mask != mask:
		#	$HBoxContainer/MaskContainer.mask = mask
		#$HBoxContainer/MaskContainer.disabled = disabled
		%LayerTexture.texture = layer_texture
		%LayerIndex.text = str(layer_index)


func _set_layer_texture(new_layer_texture: Texture) -> void:
	layer_texture = new_layer_texture
	if has_node("HBoxContainer/TextureContainer/LayerImageContainer/Panel/LayerTexture"):
		%LayerTexture.texture = layer_texture


func _set_mask_texture(new_mask: Mask) -> void:
	mask = new_mask
	if has_node("HBoxContainer/MaskContainer"):
		$HBoxContainer/MaskContainer.mask = new_mask


func set_active(value: bool) -> void:
	if value:
		$HBoxContainer/MaskContainer._activate()
	else:
		$HBoxContainer/MaskContainer._dectivate()


func get_mask_container() -> MaskContainer:
	return $HBoxContainer/MaskContainer


func _set_disabled(value: bool) -> void:
	disabled = value
	if has_node("HBoxContainer/MaskContainer"):
		$HBoxContainer/MaskContainer.disabled = disabled
		$HBoxContainer/Attach.visible = not disabled


func _set_layer_index(new_index: int) -> void:
	layer_index = new_index
	if has_node("HBoxContainer/TextureContainer/LayerIndexContainer/LayerIndex"):
		%LayerIndex.text = str(new_index)


func _on_layer_texture_mouse_entered() -> void:
	timer_layer_highligh.start()


func _on_layer_texture_mouse_exited() -> void:
	if timer_layer_highligh.is_stopped():
		SignalBus.highlight_layer.emit(layer_index, false)
	else:
		timer_layer_highligh.stop()


func _on_timer_layer_timeout() -> void:
	SignalBus.highlight_layer.emit(layer_index, true)

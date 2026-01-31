@tool
class_name LayerMenuRow extends HBoxContainer

@export var layer_number: int = 0 : set = _set_layer_number
var mask_disabled: bool = false : set = _set_disabled


func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		$TextDisplay/LayerNumber.text = "Layer " + str(layer_number)


func _set_layer_number(new_value: int) -> void:
	layer_number = new_value
	$TextDisplay/LayerNumber.text = "Layer " + str(layer_number)


func _set_disabled(new_value: bool) -> void:
	mask_disabled = new_value
	if new_value:
		$MaskDisplay/Disable.hide()
	else:
		$MaskDisplay/Disable.show()


func get_mask() -> Mask:
	return $MaskDisplay/PanelContainer/Mask


func add_mask(new_mask: Mask) -> void:
	if $MaskDisplay.get_child_count() == 0:
		$MaskDisplay.add_child(new_mask)
		$MaskDisplay.size_flags_stretch_ratio = 1.0
		$TextDisplay.size_flags_stretch_ratio = 4.0


func remove_mask():
	if $MaskDisplay.get_child_count():
		mask_disabled = false
		var child = $MaskDisplay.get_child(0)
		$MaskDisplay.remove_child(child)
		$MaskDisplay.size_flags_stretch_ratio = 0.0
		$TextDisplay.size_flags_stretch_ratio = 5.0


func _on_mask_mouse_entered() -> void:
	var style_box: StyleBoxFlat = $MaskDisplay/PanelContainer.get_theme_stylebox("panel")
	style_box.border_width_bottom = 2
	style_box.border_width_left = 2
	style_box.border_width_right = 2
	style_box.border_width_top = 2
	$MaskDisplay/PanelContainer/Mask.hovered = true


func _on_mask_mouse_exited() -> void:
	var style_box: StyleBoxFlat = $MaskDisplay/PanelContainer.get_theme_stylebox("panel")
	style_box.border_width_bottom = 0
	style_box.border_width_left = 0
	style_box.border_width_right = 0
	style_box.border_width_top = 0
	$MaskDisplay/PanelContainer/Mask.hovered = false

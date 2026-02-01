@tool
class_name LayerMenuRow extends PanelContainer

@export var layer_number: int = 0 : set = _set_layer_number
var mask_disabled: bool = false : set = _set_disabled
var mask_entered: bool = false
var mask: Mask
var box_hovered = load("res://Scenes/LayersMenu/LayerMenuRowBoxHovered.tres")
var box_normal = load("res://Scenes/LayersMenu/LayerMenuRowBox.tres")
var in_visibility_icon = false
@onready var visibilityIcon = $LayerMenuRow/TextDisplay/MarginContainer/VisibilityIcon


func _ready() -> void:
	$LayerMenuRow/Area2D/CollisionShape2D.shape.size = size
	$LayerMenuRow/Area2D.position = size / 2
	if mask:
		visibilityIcon.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		$LayerMenuRow/TextDisplay/VBoxContainer/LayerNumber.text = "Layer " + str(layer_number)
		$LayerMenuRow/Area2D/CollisionShape2D.shape.size = size
		$LayerMenuRow/Area2D.position = size / 2


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and in_visibility_icon:
		mask_disabled = not mask_disabled


func _set_layer_number(new_value: int) -> void:
	layer_number = new_value
	$LayerMenuRow/TextDisplay/VBoxContainer/LayerNumber.text = "Layer " + str(layer_number)


func _set_disabled(new_value: bool) -> void:
	mask_disabled = new_value
	if new_value:
		$LayerMenuRow/MaskDisplay/Disable.show()
		visibilityIcon = $LayerMenuRow/TextDisplay/MarginContainer/VisibilityIconDisabled
		$LayerMenuRow/TextDisplay/MarginContainer/VisibilityIcon.hide()
		if mask:
			visibilityIcon.show()
			SignalBus.mask_disabled.emit(mask, mask.layer)
	else:
		$LayerMenuRow/MaskDisplay/Disable.hide()
		visibilityIcon = $LayerMenuRow/TextDisplay/MarginContainer/VisibilityIcon
		$LayerMenuRow/TextDisplay/MarginContainer/VisibilityIconDisabled.hide()
		if mask:
			visibilityIcon.show()
			SignalBus.mask_enabled.emit(mask, mask.layer)


func get_mask() -> Mask:
	return mask


func set_layer_preview(texture: Texture) -> void:
	$LayerMenuRow/LayerDisplay/Texture.texture = texture


func add_mask(new_mask: Mask) -> void:
	if $LayerMenuRow/MaskDisplay/PanelContainer.get_child_count() == 0:
		$LayerMenuRow/MaskDisplay/PanelContainer.add_child(new_mask)
		$LayerMenuRow/MaskDisplay.show()
		$LayerMenuRow/TextDisplay/MarginContainer/VisibilityIcon.show()
		if mask_disabled:
			$LayerMenuRow/TextDisplay/MarginContainer/VisibilityIconDisabled.show()
		#$LayerMenuRow/MaskDisplay.size_flags_stretch_ratio = 1.0
		#$LayerMenuRow/TextDisplay.size_flags_stretch_ratio = 4.0
		mask = new_mask
		mask.layer = self.layer_number
		mask.layer_parent = self
		mask.mouse_entered.connect(_on_mask_mouse_entered)
		mask.mouse_exited.connect(_on_mask_mouse_exited)
		if visibilityIcon:
			visibilityIcon.show()


func remove_mask():
	if $LayerMenuRow/MaskDisplay/PanelContainer.get_child_count():
		#mask_disabled = false
		mask.mouse_entered.disconnect(_on_mask_mouse_entered)
		mask.mouse_exited.disconnect(_on_mask_mouse_exited)
		var child = $LayerMenuRow/MaskDisplay/PanelContainer.get_child(0)
		$LayerMenuRow/MaskDisplay/PanelContainer.remove_child(child)
		$LayerMenuRow/MaskDisplay.hide()
		$LayerMenuRow/TextDisplay/MarginContainer/VisibilityIcon.hide()
		$LayerMenuRow/TextDisplay/MarginContainer/VisibilityIconDisabled.hide()
		#$LayerMenuRow/MaskDisplay.size_flags_stretch_ratio = 0.0
		#$LayerMenuRow/TextDisplay.size_flags_stretch_ratio = 5.0
		mask.layer_parent = null
		mask = null
		if visibilityIcon:
			visibilityIcon.hide()


func _on_mask_mouse_entered() -> void:
	var style_box: StyleBoxFlat = $LayerMenuRow/MaskDisplay/PanelContainer.get_theme_stylebox("panel")
	style_box.border_width_bottom = 8
	style_box.border_width_left = 8
	style_box.border_width_right = 8
	style_box.border_width_top = 8


func _on_mask_mouse_exited() -> void:
	var style_box: StyleBoxFlat = $LayerMenuRow/MaskDisplay/PanelContainer.get_theme_stylebox("panel")
	style_box.border_width_bottom = 0
	style_box.border_width_left = 0
	style_box.border_width_right = 0
	style_box.border_width_top = 0


func _on_resized() -> void:
	$LayerMenuRow/Area2D/CollisionShape2D.shape.size = size
	$LayerMenuRow/Area2D.position = size / 2


## Quando entra un area(una maschera) controlla che non sia la sua maschera, se non lo è sta ricevendo quella mmaschera
## e quindi si connette al suo segnale di fine dragging
func _on_area_2d_area_entered(area: Area2D) -> void:
	var dragged_mask = area.get_parent()
	add_theme_stylebox_override("panel", box_hovered)
	if mask == null or mask != dragged_mask:
		mask_entered = true
		dragged_mask.reference_mask.mask_dragged.connect(_on_mask_dragged)


func _on_area_2d_area_exited(area: Area2D) -> void:
	mask_entered = false
	add_theme_stylebox_override("panel", box_normal)
	var dragged_mask = area.get_parent()
	dragged_mask.reference_mask.mask_dragged.disconnect(_on_mask_dragged)


## Entra qua dentro solo nel caso in cui la maschera fosse dentro l'area quando
## è stata rilasciata
func _on_mask_dragged(value: bool, dragged_mask: Mask):
	if value == false:
		var dragged_mask_old_layer_parent: LayerMenuRow = dragged_mask.layer_parent
		var dragged_old_parent_disabled = dragged_mask_old_layer_parent.mask_disabled
		var old_mask = mask
		
		dragged_mask_old_layer_parent.remove_mask()
		remove_mask()
		if !dragged_mask_old_layer_parent.mask_disabled:
			SignalBus.mask_disabled.emit(dragged_mask, dragged_mask_old_layer_parent.layer_number)
		
		if old_mask:
			dragged_mask_old_layer_parent.add_mask(old_mask)
			if not mask_disabled:
				SignalBus.mask_disabled.emit(old_mask, layer_number)
				dragged_mask_old_layer_parent.mask_disabled = false
				#SignalBus.mask_enabled.emit(old_mask, dragged_mask_old_layer_parent.layer_number)
			#if !dragged_mask_old_layer_parent.mask_disabled:
			#	SignalBus.mask_enabled.emit(old_mask, dragged_mask_old_layer_parent.layer_number)
		
		add_mask(dragged_mask)
		mask_disabled = dragged_old_parent_disabled
		
		#if not mask_disabled:
		#	SignalBus.mask_enabled.emit(dragged_mask, layer_number)


func _on_visibility_icon_mouse_entered() -> void:
	in_visibility_icon = true
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_visibility_icon_mouse_exited() -> void:
	in_visibility_icon = false
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

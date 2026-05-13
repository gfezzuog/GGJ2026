@tool

extends Control

var n_layers: int = 0		# serve per resettare le maschere quando restarti un livello
var empty_visualitazion: bool = false : set = _set_empty_visualitazion
var level_data: LevelData


#region SETTER

func _set_empty_visualitazion(value: bool) -> void:
	empty_visualitazion = value
	if empty_visualitazion:
		$RowLayerContainer/VBoxContainer.hide()
		$PanelContainer/Label.hide()
		$Panel/ButtonsContainer.hide()
		$RowLayerContainer.hide()
		$PanelContainer.hide()
	else:
		$RowLayerContainer/VBoxContainer.show()
		$PanelContainer/Label.show()
		$Panel/ButtonsContainer.show()
		$RowLayerContainer.show()
		$PanelContainer.show()


func _set_n_layers(n: int) -> void:
	for i in range(n):
		$RowLayerContainer/VBoxContainer.get_child(i).show()
		$RowLayerContainer/VBoxContainer.get_child(i).process_mode = Node.PROCESS_MODE_INHERIT
	for i in range(n, 5):
		$RowLayerContainer/VBoxContainer.get_child(i).process_mode = Node.PROCESS_MODE_DISABLED
		$RowLayerContainer/VBoxContainer.get_child(i).hide()
	n_layers = n


func _set_textures(textures: Array[Texture]) -> void:
	var i: int = 0
	
	while i < 5 and i < textures.size():
		var row = $RowLayerContainer/VBoxContainer.get_child(i)
		row.layer_texture = textures[i]
		i += 1


func _set_masks(masks: Array[Mask]) -> void:
	var i: int = 0
	
	while i < 5 and i < masks.size():
		var row = $RowLayerContainer/VBoxContainer.get_child(i)
		row.mask = masks[i]
		if masks[i]:
			row.get_mask_container().active = true
		i += 1


func _set_disability(values: Array[int]) -> void:
	var i: int = 0
	
	while i < 5 and i < values.size():
		var row: RowLayer = $RowLayerContainer/VBoxContainer.get_child(i)
		row.disabled = values[i] & 1 == 1
		
		var mask_container: MaskContainer = row.get_mask_container()
		if values[i] & 2 != 0:
			mask_container.visibility_disabled = true
		if values[i] & 4 != 0:
			mask_container.rotation_disabled = true
		if values[i] & 8 != 0:
			var view_button: LayerButton = mask_container.get_view_button()
			view_button.toggle_status = true
			mask_container.update_status()
		
		i += 1

#endregion


func get_row_layer(indx: int) -> RowLayer:
	return $RowLayerContainer/VBoxContainer.get_child(indx)


#region INIT-RESET 

func reset() -> void:
	for i in range(5):
		var row: RowLayer = get_row_layer(i)
		row.get_mask_container().reset()
		row.disabled = false
		row.mask = null
		row.layer_texture = null
		row.show()
		level_data = null


func init_level() -> void:
	if level_data:
		_set_masks(level_data.masks)
		_set_n_layers(level_data.layers.size())
		_set_disability(level_data.layers)
		_set_textures(level_data.layers_textures)
		trigger_masks()


func reset_level() -> void:
	for i in range(5):
		var row: RowLayer = get_row_layer(i)
		row.get_mask_container().reset()
	for mask: Mask in level_data.masks:
		if mask:
			mask.index = 0
	init_level()

#endregion


func trigger_masks():
	for i in range(0, 5):
		var row: RowLayer = $RowLayerContainer/VBoxContainer.get_child(i)
		var mask_container: MaskContainer = row.get_mask_container()
		if mask_container.disabled and mask_container.mask:
			var view_button: LayerButton = mask_container.get_view_button()
			if !view_button.toggle_status:
				SignalBus.mask_activated.emit(mask_container.mask, i)


#region LATERAL BUTTON

func _restart_level() -> void:
	SignalBus.restart_level.emit()


func _change_level() -> void:
	SignalBus.open_menu_levels.emit()


func _open_settings() -> void:
	SignalBus.open_menu_settings.emit()


func _exit() -> void:
	### TODO: fare che torni al menu principale invece di uscire
	get_tree().quit()

#endregion

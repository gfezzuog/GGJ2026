@tool

extends Control

var n_layers: int = 0		# serve per resettare le maschere quando restarti un livello
var empty_visualitazion: bool = false : set = _set_empty_visualitazion


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


func get_row_layer(indx: int) -> RowLayer:
	return $RowLayerContainer/VBoxContainer.get_child(indx)


func set_n_layers(n: int) -> void:
	for i in range(n):
		$RowLayerContainer/VBoxContainer.get_child(i).show()
	for i in range(n, 5):
		$RowLayerContainer/VBoxContainer.get_child(i).hide()
	n_layers = n


func set_textures(textures: Array[Texture]) -> void:
	var i: int = 0
	
	while i < 5 and i < textures.size():
		var row = $RowLayerContainer/VBoxContainer.get_child(i)
		row.layer_texture = textures[i]
		i += 1


func set_masks(masks: Array[Mask]) -> void:
	var i: int = 0
	
	while i < 5 and i < masks.size():
		var row = $RowLayerContainer/VBoxContainer.get_child(i)
		row.mask = masks[i]
		if masks[i]:
			row.get_mask_container().active = true
		i += 1


func set_disability(values: Array[int]) -> void:
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


func trigger_masks():
	for i in range(0, 5):
		var row: RowLayer = $RowLayerContainer/VBoxContainer.get_child(i)
		var mask_container: MaskContainer = row.get_mask_container()
		if mask_container.disabled and mask_container.mask:
			var view_button: LayerButton = mask_container.get_view_button()
			if !view_button.toggle_status:
				SignalBus.mask_activated.emit(mask_container.mask, i)


func reset() -> void:
	for i in range(5):
		var row: RowLayer = $RowLayerContainer/VBoxContainer.get_child(i)
		row.disabled = false
		row.mask = null
		row.layer_texture = null
		row.get_mask_container().reset()
		row.show()


# Funzioni per i pulsanti laterali
func _restart_level() -> void:
	SignalBus.restart_level.emit()


func _change_level() -> void:
	SignalBus.open_menu_levels.emit()


func _open_settings() -> void:
	SignalBus.open_menu_settings.emit()


func _exit() -> void:
	### TODO: fare che torni al menu principale invece di uscire
	get_tree().quit()

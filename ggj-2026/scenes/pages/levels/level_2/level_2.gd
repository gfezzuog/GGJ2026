extends Level


func _ready():
	super._ready()
	
	$HBoxContainer/Canvas/Objs/spine_sx.disabled = true
	$HBoxContainer/Canvas/Objs/spine_dx.disabled = true


func _on_grid_disabled_update():
	var all_true = true
	
	for j in range(11, 15):
		if disabled_grid_elements[10 * GRID_SIZE + j][1] != 1:
			all_true = false
			break

	$HBoxContainer/Canvas/Objs/spine_dx.disabled = not all_true
	
	all_true = true
	
	for j in range(6, 10):
		if disabled_grid_elements[10 * GRID_SIZE + j][1] != 1:
			all_true = false
			break
	
	$HBoxContainer/Canvas/Objs/spine_sx.disabled = not all_true

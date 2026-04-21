extends Level


func _ready() -> void:
	super()
	
	var rows: Array[LayerMenuRow] = %LayersMenu.layers_row
	for row in rows:
		row.rotation_disabled = true


func _on_exit_area_body_entered(_body: Node2D) -> void:
	SignalBus.game_over.emit()

extends Node2D

var to_update = false
var pressed = false


func _physics_process(delta: float) -> void:
	pass
	#$SensorArea.position = $SensorArea.position + Vector2(0.01*delta, 0)


func _on_button_pressed() -> void:
	if not pressed:
		var polygons: Array[PackedVector2Array] = []
		polygons.append($Polygon2D.polygon)
		$GameObj.apply_difference(polygons)
	else:
		$GameObj.reset()
	pressed = not pressed

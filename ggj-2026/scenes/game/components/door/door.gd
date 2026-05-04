extends GameObj

var enabled: bool = true


'''func polygons_equal(a: PackedVector2Array, b: PackedVector2Array, epsilon := 0.001) -> bool:
	if a.size() != b.size():
		return false

	for i in range(a.size()):
		if a[i].distance_to(b[i]) > epsilon:
			return false

	return true


func _check_disabled() -> bool:
	var originals_polygons = []
	for collision_pol in originals_collision_pol:
		var polygon: PackedVector2Array = collision_pol.polygon if collision_pol is CollisionPolygon2D else _convert_collision_shape(collision_pol)
		originals_polygons.append(polygon)
	
	var current_polygons = []
	for collision_pol in current_collision_pol:
		var polygon: PackedVector2Array = collision_pol.polygon if collision_pol is CollisionPolygon2D else _convert_collision_shape(collision_pol)
		current_polygons.append(polygon)
	
	for original in originals_polygons:
		var found := false
		print("Original: ", original)
		
		for current in current_polygons:
			print("Current: ", current)
			if polygons_equal(original, current):
				found = true
				break
		
		if not found:
			return true

	return false'''


func _apply_disable(value: bool) -> void:
	print("Sta monitorando?: ", not value)
	$StaticBody2D.monitoring = not value


func _on_area_2d_body_entered(_body: Node2D) -> void:
	if (enabled):
		SignalBus.door_reached.emit(position.x, position.y)
		enabled = false

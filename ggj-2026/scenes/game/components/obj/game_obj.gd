class_name GameObj extends Node2D


@export var hide_by_mask: bool = true
@export var hide_by_layer: bool = false
@export var sensor_area: SensorArea = null
@export var offset: Vector2 = Vector2(0, 0)
var originals_collision_pol: Array[Node2D]
var created_collision_pol: Array[Node2D]
var current_collision_pol: Array[Node2D]


func _ready() -> void:
	_populate_collision_array()
	use_parent_material = true
	for child in get_children():
		if child is Sprite2D or child is TextureRect:
			child.use_parent_material = true
	if hide_by_layer and sensor_area:
		sensor_area.covered.connect(_check_and_apply_disable)


func _populate_collision_array():
	if has_node("StaticBody2D"):
		for child in $StaticBody2D.get_children():
			originals_collision_pol.append(child)


func _check_covered_by_mask() -> bool:
	if current_collision_pol.is_empty():
		return true
	return false


func _check_covered_by_layer() -> bool:
	if sensor_area and sensor_area.is_covered:
		return true
	return false


func _apply_disable(value: bool) -> void:
	if value:
		hide()
	else:
		show()


func _check_and_apply_disable() -> void:
	var flag: bool = false
	if hide_by_mask:
		flag = _check_covered_by_mask()
	if hide_by_layer:
		flag = flag or _check_covered_by_layer()
	_apply_disable(flag)


func _convert_rectangle(shape: Shape2D, shape_position: Vector2) -> PackedVector2Array:
	var rect: Rect2 = shape.get_rect()
	return [
		rect.position + shape_position,
		rect.position + Vector2(rect.size.x, 0) + shape_position,
		rect.position + Vector2(rect.size.x, rect.size.y) + shape_position,
		rect.position + Vector2(0, rect.size.y) + shape_position
	]


func _convert_capsule(shape: Shape2D, shape_position: Vector2) -> PackedVector2Array:
	var radius = shape.radius
	var height = shape.height
	
	var half_h = height * 0.5
	
	var points: PackedVector2Array = []
	
	for i in range(3):
		var t = float(i) / 2.0 # 0 → 1
		var angle = lerp(PI, 0.0, t)
		var x = cos(angle) * radius
		var y = sin(angle) * radius - half_h
		points.append(Vector2(x, y) + shape_position)
	
	points.append(Vector2(radius, half_h) + shape_position)
	
	for i in range(3):
		var t = float(i) / 2.0
		var angle = lerp(0.0, PI, t)
		var x = cos(angle) * radius
		var y = sin(angle) * radius + half_h
		points.append(Vector2(x, y) + shape_position)
	
	points.append(Vector2(-radius, -half_h) + shape_position)
	
	return points


## Sono gestiti solo rettangoli e capsule
func _convert_collision_shape(collision_shape: CollisionShape2D) -> PackedVector2Array:
	var shape: Shape2D = collision_shape.shape
	var shape_position: Vector2 = collision_shape.position
	
	if shape is RectangleShape2D:
		return _convert_rectangle(shape, shape_position)
	elif shape is CapsuleShape2D:
		return _convert_capsule(shape, shape_position)
	
	return PackedVector2Array()


func apply_difference(polygons: Array[PackedVector2Array]) -> void:
	var new_polygons: Array[PackedVector2Array]
	for collision_pol in originals_collision_pol:
		collision_pol.disabled = true
		collision_pol.hide()
		var polygon: PackedVector2Array = collision_pol.polygon if collision_pol is CollisionPolygon2D else _convert_collision_shape(collision_pol)
		for i in range(polygon.size()):
			polygon.set(i, polygon[i] + offset)
		new_polygons.append(polygon)
	
	for polygon_b: PackedVector2Array in polygons:
		var n_p: Array[PackedVector2Array]
		for polygon_a in new_polygons:
			var new_pol: Array[PackedVector2Array] = Geometry2D.clip_polygons(polygon_a, polygon_b)
			for n in new_pol:
				n_p.append(n)
		new_polygons = n_p.duplicate()
	
	for poly in new_polygons:
		for i in range(poly.size()):
			poly.set(i, poly[i] - offset)
	
	for p in new_polygons:
		var new_coll_pol = CollisionPolygon2D.new()
		new_coll_pol.polygon = p
		$StaticBody2D.add_child(new_coll_pol)
		created_collision_pol.append(new_coll_pol)
	
	current_collision_pol = created_collision_pol
	_check_and_apply_disable()


func reset():
	for col_pol in created_collision_pol:
		col_pol.queue_free()
	created_collision_pol.clear()
	
	for col_pol in originals_collision_pol:
		col_pol.disabled = false
		col_pol.show()
	
	current_collision_pol = originals_collision_pol
	_check_and_apply_disable()

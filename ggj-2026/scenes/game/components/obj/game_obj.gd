class_name GameObj extends Node2D

signal shape_changed

@export var hide_by_mask: bool = true ## Disabilita l'oggetto se la maschera lo copre
@export var hide_by_layer: SensorArea = null ## Disabilita l'oggetto se è coperto da altri layer
@export var offset: Vector2 = Vector2(0, 0)
var originals_collision_pol: Array[PackedVector2Array]
var current_collision_pol: Array[PackedVector2Array]


func _ready() -> void:
	_populate_collision_array()
	
	use_parent_material = true
	for child in get_children():
		if child is Sprite2D or child is TextureRect:
			child.use_parent_material = true
	
	if hide_by_layer:
		hide_by_layer.to_check = true


func _populate_collision_array():
	if has_node("StaticBody2D"):
		for child in $StaticBody2D.get_children():
			originals_collision_pol.append(child.polygon)
		current_collision_pol = originals_collision_pol.duplicate()


func _check_covered_by_mask() -> bool:
	if current_collision_pol.is_empty():
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
		flag = flag or hide_by_layer.is_covered
	_apply_disable(flag)


func apply_difference(polygons: Array[PackedVector2Array]) -> void:
	var new_polygons: Array[PackedVector2Array]
	for collision_pol in originals_collision_pol:
		var polygon: PackedVector2Array = collision_pol.duplicate()
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
	
	for child in $StaticBody2D.get_children():
		child.queue_free()
	current_collision_pol.clear()
	
	for p in new_polygons:
		var new_coll_pol = CollisionPolygon2D.new()
		new_coll_pol.polygon = p
		$StaticBody2D.add_child(new_coll_pol)
		current_collision_pol.append(p)
	
	shape_changed.emit()
	_check_and_apply_disable()


func reset():
	for child in $StaticBody2D.get_children():
		child.queue_free()
	current_collision_pol.clear()
	
	for p in originals_collision_pol:
		var new_coll_pol = CollisionPolygon2D.new()
		new_coll_pol.polygon = p
		$StaticBody2D.add_child(new_coll_pol)
		current_collision_pol.append(p)
	
	shape_changed.emit()
	_check_and_apply_disable()

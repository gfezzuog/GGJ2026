extends Node2D

var polygons_to_draw: Array[PackedVector2Array] = []
var color: Color = Color(Colors.HIGHLIGHT, 0.5)


func _draw():
	if !polygons_to_draw.is_empty():
		for polygon in polygons_to_draw:
			draw_colored_polygon(polygon, color)


func show_mask(polygons: Array[PackedVector2Array]) -> void:
	for polygon in polygons:
		polygons_to_draw.append(polygon)
	queue_redraw()


func hide_mask() -> void:
	polygons_to_draw.clear()
	queue_redraw()

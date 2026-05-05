extends Node2D

var speed: float = 40
var limit: float = -8
var max_distance: float = 71.0

@onready var polygons: Array[Polygon2D] = [
	$Control/Polygon2D,
	$Control/Polygon2D2,
	$Control/Polygon2D3,
	$Control/Polygon2D4,
	$Control/Polygon2D5
]


func _physics_process(delta: float) -> void:
	for pol in polygons:
		pol.position.y -= (speed*delta)
		if pol.position.y <= limit:
			pol.position.y = limit + max_distance
		var t = inverse_lerp(limit, limit + (max_distance*1.5), pol.position.y)
		pol.modulate.a = 1.0 - t

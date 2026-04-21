class_name SensorArea extends Area2D


signal covered

var is_covered: bool = false
var above_objects = 0


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(_body: Node2D) -> void:
	above_objects += 1
	is_covered = true
	covered.emit()


func _on_body_exited(_body: Node2D) -> void:
	above_objects -= 1
	if above_objects <= 0:
		is_covered = false
		covered.emit()

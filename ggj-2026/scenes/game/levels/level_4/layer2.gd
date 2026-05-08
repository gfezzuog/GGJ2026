extends GameObj

var free_effect_top: bool = false


func _physics_process(delta: float) -> void:
	$SphereEffectBottom.rotation += 1*delta
	if free_effect_top:
		$SphereEffectTop.rotation += 1*delta


func _on_teleport_area_body_entered(_body: Node2D) -> void:
	_body.position = Vector2(940, 692)


func _on_sensor_area_covered(value: bool) -> void:
	if !value:
		free_effect_top = true
		$AnimationPlayer.show()
		$TeleportArea.monitoring = true
	else:
		free_effect_top = false
		$AnimationPlayer.hide()
		$TeleportArea.monitoring = false

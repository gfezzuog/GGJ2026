extends GameObj


func _on_teleport_area_body_entered(_body: Node2D) -> void:
	$AudioTeleport.play()
	_body.position = Vector2(940, 692)


func _on_sensor_area_covered(value: bool) -> void:
	if !value:
		$GlowAnimationTop.play("glow")
		$GPUParticles2D.emitting = true
		$TeleportArea.monitoring = true
	else:
		$GlowAnimationTop.stop()
		$GPUParticles2D.emitting = false
		$TeleportArea.monitoring = false

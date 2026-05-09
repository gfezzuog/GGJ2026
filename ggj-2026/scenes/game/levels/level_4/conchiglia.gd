extends GameObj


@onready var ball = $Ball


func _apply_disable(value: bool) -> void:
	if value:
		$AnimationPlayer.stop()
		$AnimationPlayer.play("RESET")
		if ball:
			ball.show()
			ball.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		$AnimationPlayer.play("default")
		if ball:
			ball.hide()
			ball.process_mode = Node.PROCESS_MODE_DISABLED


func _on_area_2d_body_entered(_body: Node2D) -> void:
	ball = _body


func _on_area_2d_body_exited(_body: Node2D) -> void:
	if _body.process_mode == PROCESS_MODE_INHERIT:
		ball = null

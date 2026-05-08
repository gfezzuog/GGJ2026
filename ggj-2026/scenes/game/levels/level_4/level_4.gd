extends Level


func add_player(_player: Player) -> void:
	_player.scale = Vector2(0.7, 0.7)
	super.add_player(_player)


func _on_game_over() -> void:
	super._on_game_over()
	$SubViewport/Layers/Layer0/Tongue.position.y = 990.0


func _on_area_2d_body_entered(_body: Node2D) -> void:
	_body.queue_free.call_deferred()
	$SubViewport/Layers/Layer3/Smoke.show()
	$SubViewport/Layers/Layer3/Smoke.process_mode = Node.PROCESS_MODE_INHERIT


func _on_check_point_area_1_body_entered(_body: Node2D) -> void:
	checkpoints_counter = 1
	$SubViewport/CheckPointArea1.monitoring = false


func _on_check_point_area_2_body_entered(_body: Node2D) -> void:
	checkpoints_counter = 2
	$SubViewport/CheckPointArea2.monitoring = false


func _on_check_point_area_3_body_entered(_body: Node2D) -> void:
	checkpoints_counter = 3
	$SubViewport/CheckPointArea3.monitoring = false

extends Level


func _on_conchiglia_area_body_entered(body: Node2D) -> void:
	body.deactivate()
	$SubViewport/Layers/Layer0/GameObj/ConchigliaArea.set.call_deferred("monitoring", false)
	$SubViewport/Layers/Layer0/GameObj/Conchiglia.play("Door")
	$SubViewport/Layers/Layer0/GameObj/Conchiglia.animation_finished.connect(_on_animation_finished)
	$SubViewport/Layers/Layer0/GameObj/AudioConchiglia.play()


func _on_animation_finished():
	$SubViewport/Layers/Layer0/GameObj/Door/StaticBody2D.monitoring = true
	$SubViewport/Layers/Layer0/GameObj/Door.show()
	player.activate()

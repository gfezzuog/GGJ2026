class_name DangerousObj extends GameObj


func _ready() -> void:
	super._ready()
	$StaticBody2D.body_entered.connect(_on_body_entered)


func _apply_disable(value: bool) -> void:
	if value:
		hide()
		$StaticBody2D.monitoring = false
		var audio = get_node_or_null("SpatialAudio")
		if (audio):
			audio.set_disabled(true)
	else:
		show()
		$StaticBody2D.monitoring = true
		var audio = get_node_or_null("SpatialAudio")
		if (audio):
			audio.set_disabled(false)


func _on_body_entered(body: Node2D) -> void:
	body.game_over()

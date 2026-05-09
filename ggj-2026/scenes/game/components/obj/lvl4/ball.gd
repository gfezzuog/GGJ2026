extends RigidBody2D


func _on_body_entered(body: Node) -> void:
	if body is Player:
		var dir = (global_position - body.global_position).normalized()
		apply_central_impulse(dir * 500)

class_name DangerousObj extends GameObj


func _ready() -> void:
	super._ready()
	$StaticBody2D.body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	body.game_over()

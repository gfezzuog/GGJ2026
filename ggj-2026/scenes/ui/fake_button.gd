extends Sprite2D

var speed: float = 1.0
var direction: int = -1
var stopped: bool = false


func _process(delta: float) -> void:
	if stopped:
		return
	
	var color = modulate
	color.a += direction * speed * delta
	
	if color.a <= 0.0:
		color.a = 0.0
		direction = 1
	elif color.a >= 1.0:
		color.a = 1.0
		direction = -1
	
	modulate = color


func start() -> void:
	stopped = false


func stop() -> void:
	modulate.a = 1.0
	stopped = true

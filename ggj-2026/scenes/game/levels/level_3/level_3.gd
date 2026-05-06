extends Level


var direction: float = 1.0
var speed: float = 100.0


func _process(delta: float) -> void:
	$SubViewport/Layers/Layer4/GameObj.position.x -= direction * speed * delta 
	if $SubViewport/Layers/Layer4/GameObj.position.x <= -680.0:
		direction = -1.0
	elif $SubViewport/Layers/Layer4/GameObj.position.x >= 1.0:
		direction = 1.0
	

extends GameObj

var velocity = Vector2(0, 100)
var direction = 1.0
var stopped: bool = false
var coming_back: Timer = Timer.new()


func _ready() -> void:
	super._ready()
	coming_back.timeout.connect(_on_coming_back_timeout)
	coming_back.one_shot = true
	coming_back.autostart = false
	coming_back.wait_time = 1.0
	add_child(coming_back)


func _physics_process(delta: float) -> void:
	if stopped:
		return
	if position.y <= 80 and direction == -1.0:
		stopped = true
		coming_back.start()
	elif position.y >= 780.0 and direction == 1.0:
		stopped = true
		coming_back.start()
		
	position.y += (direction*velocity.y*delta)
	offset = position


func _on_coming_back_timeout() -> void:
	direction *= -1.0
	stopped = false 

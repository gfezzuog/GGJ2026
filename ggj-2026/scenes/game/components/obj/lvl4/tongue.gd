extends GameObj

var velocity = Vector2(0, 100)
var direction = 1.0
var player: Player = null
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
	if position.y <= 1 and direction == -1.0:
		stopped = true
		coming_back.start()
	elif position.y >= 990.0 and direction == 1.0:
		stopped = true
		coming_back.start()
		
	position.y += (direction*velocity.y*delta)
	offset = position


func _on_coming_back_timeout() -> void:
	direction *= -1.0
	stopped = false 


func _on_area_2d_body_entered(body_entered: Node2D) -> void:
	if body_entered is Player:
		player = body_entered
	elif player:
		player.crush(velocity, Vector2(0, 72))


func _on_area_2d_body_exited(body_exited: Node2D) -> void:
	if body_exited is Player:
		player = null


func _on_bottom_area_2d_body_entered(_body: Node2D) -> void:
	stopped = true


func _on_bottom_area_2d_body_exited(_body: Node2D) -> void:
	stopped = false

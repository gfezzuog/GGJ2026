extends CharacterBody2D

@export var speed: float = 300.0
@export var jump_force: float = 200.0
@export var gravity: float = 900

func _ready() -> void:
	print(position)
	

func game_over() -> void:
	#print("MORTO COJONS")
	SignalBus.emit_signal("game_over")

func _physics_process(delta: float) -> void:
	
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()

		if collider.collision_layer & (1 << 1):
			game_over()
			pass
			#game_over() #placeholder
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_force
		
	# Get the input direction and handle the movement/deceleration
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide()

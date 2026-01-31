extends CharacterBody2D

@export var speed: float = 300.0
@export var jump_force: float = 250.0
@export var gravity: float = 900
@onready var animation = $AnimatedSprite2D
@onready var walking = false
@onready var jumping = false
@onready var falling = false

func _physics_process(delta: float) -> void:
	# Add the gravity and handle falling state.
	if not is_on_floor():
		velocity.y += gravity * delta
		falling = true
	elif is_on_floor():
		falling = false

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_force
		jumping = true
		
	# Get the input direction and handle the movement/deceleration
	var direction := Input.get_axis("left", "right")
	if direction:
		walking = true
		velocity.x = direction * speed
	else:
		walking = false
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	
	#handle animations and states
	if jumping:
		animation.play("jump")
	elif falling:
		animation.play("fall")
		if direction > 0:
			animation.flip_h = false
		else:
			animation.flip_h = true
	elif walking and direction > 0 and not jumping:
		animation.flip_h = false
		animation.play("walk")
	elif walking and direction < 0 and not jumping:
		animation.flip_h = true
		animation.play("walk")
	else:
		animation.play("idle")

func _on_animated_sprite_2d_animation_finished() -> void:
	if jumping:
		jumping = false # Replace with function body.

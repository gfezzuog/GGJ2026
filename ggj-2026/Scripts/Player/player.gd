extends CharacterBody2D

@export var speed: float = 300.0
@export var jump_force: float = 250.0
@export var gravity: float = 900

@onready var animation = $AnimatedSprite2D
@onready var walkAudio = $WalkAudio
@onready var actionAudio = $ActionAudio
@onready var landAudio = $LandAudio

@export var w_audio : AudioStream
@export var j_audio : AudioStream
@export var f_audio : AudioStream

var was_on_floor := false
var prev_velocity_y := 0.0
func _ready() -> void:
	print(position)
	

func game_over() -> void:
	#print("MORTO COJONS")
	SignalBus.emit_signal("game_over")

func _physics_process(delta: float) -> void:
	# SALVO LA VELOCITÀ PRIMA DEL MOVIMENTO
	prev_velocity_y = velocity.y

	# GRAVITÀ
	
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

	# JUMP (ONE SHOT GARANTITO)
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_force
		actionAudio.stop()
		actionAudio.stream = j_audio
		actionAudio.play()

	# MOVIMENTO ORIZZONTALE
	var direction := Input.get_axis("left", "right")
	if direction != 0:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide()

	# ANIMAZIONI
	if not is_on_floor():
		if velocity.y < 0:
			animation.play("jump")
		else:
			animation.play("fall")
	elif direction != 0:
		animation.play("walk")
	else:
		animation.play("idle")

	if direction < 0:
		animation.flip_h = true
	elif direction > 0:
		animation.flip_h = false

	# AUDIO WALK
	if direction != 0 and is_on_floor():
		if not walkAudio.playing:
			walkAudio.stream = w_audio
			walkAudio.play()
	else:
		walkAudio.stop()

	# AUDIO LANDING — SOLO TRANSIZIONE REALE
	var on_floor_now := is_on_floor()
	if on_floor_now and not was_on_floor and prev_velocity_y > 0:
		landAudio.stream = f_audio
		landAudio.play()

	was_on_floor = on_floor_now

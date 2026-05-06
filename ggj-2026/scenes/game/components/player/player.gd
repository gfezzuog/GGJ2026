class_name Player extends CharacterBody2D

@export var speed: float = 300.0
@export var jump_force: float = 250.0
@export var gravity: float = 900

@onready var animation = $Mask/AnimatedSprite2D
@onready var walkAudio = $WalkAudio
@onready var actionAudio = $ActionAudio
@onready var landAudio = $LandAudio

@export var w_audio : AudioStream
@export var j_audio : AudioStream
@export var f_audio : AudioStream

var was_on_floor := false
var prev_velocity_y := 0.0

# diventa not active quando apri il popup
var active = true

# diventa true quando arrivi a una porta
var animating_toward_door = false
var animating_toward_door_initial_x = 0
var animating_toward_door_goal_x = 0
var animating_toward_door_pos_holder = 0
var player_width = 0.0 # settato in ready


func _ready() -> void:
	# attiva/disattiva player col popup
	SignalBus.open_popup_ok.connect(deactivate)
	SignalBus.open_popup_yes_no.connect(deactivate)
	SignalBus.close_popup.connect(activate)
	
	player_width = $Mask.texture.get_width()


func _do_game_over() -> void:
	SignalBus.game_over.emit()


func game_over():
	call_deferred("_do_game_over")


func activate():
	#print("sto attivando il player")
	active = true
	set_collision_layer_value(2, true)


# quando il player e' disattivato gli leviamo il collision layer cosi' non puo' collidere con una porta
# (altrimenti succederebbe passando da un livello all'altro se il player e' in alcune posizioni)
func deactivate():
	#print("sto disattivando il player")
	active = false
	set_collision_layer_value(2, false)


func _physics_process(delta: float) -> void:
	
	'''
	if (!active):
		return
	'''
	
	# ANIMAZIONE QUANDO ARRIVI A UNA PORTA
	if (animating_toward_door):
		
		var dir = sign(animating_toward_door_goal_x - animating_toward_door_initial_x)
		
		# ANIMAZIONE FINITA
		if ( (dir >= 0 && position.x + animating_toward_door_pos_holder >= animating_toward_door_goal_x) ||
			 (dir < 0 && position.x + animating_toward_door_pos_holder <= animating_toward_door_goal_x)):
			
			# resetta posizioni maschera e sprite
			$Mask.position.x = 0
			animation.position.x = 0
			
			animating_toward_door = false
			
			# manda segnale che l'animazione e' finita
			#SignalBus.call_deferred("emit_signal", "door_reached_animation_ended")
			SignalBus.door_reached_animation_ended.emit()
		else:
			# calcola a che percentuale dell'animazione sei arrivato
			#var perc = position.x / abs(animating_toward_door_goal_x - animating_toward_door_initial_x)
			
			var vel = speed * 0.01 * dir
			
			# se non ti sei ancora spostato di meta' larghezza, muovi la maschera (insieme alla sprite figlia)
			if (abs(animating_toward_door_pos_holder) < player_width / 2.5):
				$Mask.position.x += vel
			# altrimenti muovi solo la sprite
			else:
				animation.position.x += vel
			
			animating_toward_door_pos_holder += vel
			
			# Gestisci movimento del player
			velocity.x = 0
			if (velocity.y < 0):
				velocity.y = 0	# comincia a farlo cadere subito se stava saltando
			if not is_on_floor():
				velocity.y += gravity * delta
			move_and_slide()
			animation.play("walk")
			
			return
			
	
	# SALVO LA VELOCITÀ PRIMA DEL MOVIMENTO
	prev_velocity_y = velocity.y
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# JUMP (ONE SHOT GARANTITO)
	
	if Input.is_action_just_pressed("jump") and is_on_floor() and active:
		velocity.y = -jump_force
		actionAudio.stop()
		actionAudio.stream = j_audio
		actionAudio.play()

	# MOVIMENTO ORIZZONTALE
	var direction: float = Input.get_axis("left", "right") if active else 0.0
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


func animate_toward_door(door_x):
	animating_toward_door_initial_x = position.x
	# se la porta e' a destra
	if (door_x >= position.x):
		animating_toward_door_goal_x = door_x + player_width * 0.5
	# se la porta e' a sinistra
	else:
		animating_toward_door_goal_x = door_x - player_width * 0.5
		
	animating_toward_door_pos_holder = 0
	animating_toward_door = true
	
	
func animate_death():
	$AnimationPlayer.play("death")

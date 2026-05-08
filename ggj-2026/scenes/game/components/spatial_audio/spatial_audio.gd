extends Node2D

@export var audio : AudioStream

@onready var audio_player = $AudioStreamPlayer

var disabled = false		# questo viene settato dagli oggetti padre, non qui

var audio_max = 0.0
var audio_min = -20.0

var min_distance = 20.0 	# da questa dist in poi (a diminuire) si sente al massimo
var max_distance = 0.1 		# viene settata quando il player entra nell'area

# il player viene preso quando entra nell'area e viene salvato per tracciare la distanza
var player: Node2D = null

func _ready() -> void:
	audio_player.stream = audio
	
	$Area2D.body_entered.connect(_on_area_2d_body_entered)
	$Area2D.body_exited.connect(_on_area_2d_body_exited)
	
	
func _process(delta: float) -> void:
	if (!disabled && player != null):
		var dist = global_position.distance_to(player.global_position)
		# proporzione:
		# dist : (max_dist - min_dist) = audio : (audio_min - audio_max)
		# quindi:
		if (dist <= min_distance):
			audio_player.volume_db = audio_max
		else:
			audio_player.volume_db = dist / (max_distance - min_distance) * (audio_min - audio_max)
		
		
func set_disabled(dis: bool):
	disabled = dis
	if (disabled):
		audio_player.stop()
	else:
		if (player):
			audio_player.play()

# comincia a tracciare il player e a riprodurre l'audio
func _on_area_2d_body_entered(body: Node2D) -> void:
	#print("player e' entrato nell'area")
	player = body
	max_distance = global_position.distance_to(player.global_position)
	audio_player.play()
	

# smetti di tracciare il player e stoppa audio
func _on_area_2d_body_exited(body: Node2D) -> void:
	#print("player e' uscito")
	player = null
	audio_player.stop()

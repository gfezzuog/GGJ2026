class_name door_obj extends Obj


func _ready() -> void:
	print("eccoci 2")
	#SignalBus.connect("door_reached", _on_player_collision)

var enabled = true


func _on_player_collision():
	print("eccoci3")
	if (enabled):
		print("eccoci4")
		SignalBus.emit_signal("doorReached")
		print("Area raggiunta!")
		enabled = false

func createCollisionShapes(collisionsInfo: Array[int]) -> void:
	# i itera sulle righe, j itera sulle colonne
	for i in range(0, size[1]):		# righe (3)
		for j in range(0, size[0]):		# colonne (8)
			# se in posizione (i,j) c'e' un "1" crea la shape. visto che non e' una
			# matrice ma un array, corrisponde alla posizione  i*size[1]+j
			if (collisionsInfo[i*size[0]+j] == 1):
				# Crea area
				var body:= StaticBody2D.new()
				body.position.y += SQUARE_SIZE/2.0 + i*SQUARE_SIZE
				body.position.x += SQUARE_SIZE/2.0 + j*SQUARE_SIZE

				# Crea collision shape
				var collisionShape = CollisionShape2D.new()
				collisionShape.shape = RectangleShape2D.new()
				collisionShape.shape.size = Vector2(SQUARE_SIZE, SQUARE_SIZE)
				body.add_child(collisionShape)
				
				
				body.set_collision_layer_value(4, true)
				body.set_collision_mask_value(4, true)
				
				add_child(body)
				collision_shapes.append(collisionShape)
				
			# altrimenti appendi null
			else:
				collision_shapes.append(null)

func enableCollision(x, y):

	var xLocal = x - pos[0]  # 6 -> colonna
	var yLocal = y - pos[1]  # 1 -> riga

	# se le coordinate cadono dentro l'oggetto
	if (xLocal >= 0 and xLocal < size[0] and yLocal >= 0 and yLocal < size[1]):		# CORRETTO
		#print("sono dentro l'oggetto")
		
		# se in quelle coordinate c'e' una collision shape
		#print("collision shapes:", collision_shapes)
		var collisionShape: CollisionShape2D = collision_shapes[yLocal*size[0] + xLocal] # deve fare 14

		if (collisionShape != null):
			#print("la collision esiste")
			collisionShape.disabled = false
			enabled = true
			
func disableCollision(x, y):
	#print(self)
	#print("coordinate: " + str(x) + " " + str(y))
	#print("pos 0: ", pos[0])
	#print("pos 1: ", pos[1])

	var xLocal = x - pos[0]  # -> colonna
	var yLocal = y - pos[1]  # -> riga

	# se le coordinate cadono dentro l'oggetto
	if (xLocal >= 0 and xLocal < size[0] and yLocal >= 0 and yLocal < size[1]):		# CORRETTO
		#print("sono dentro l'oggetto")
		
		# se in quelle coordinate c'e' una collision shape
		#print("collision shapes:", collision_shapes)
		var collisionShape: CollisionShape2D = collision_shapes[yLocal*size[0] + xLocal] # deve fare 14
		#print(collision_shapes)
		#print(xLocal*size[0] + yLocal)
		if (collisionShape != null):
			#print("la collision esiste")
			# passo la collision shape allo shader
			collision_shapes_for_shader.append(collisionShape)
			
			#print("disabilito collisione")
			collisionShape.disabled = true
			enabled=false

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("eccoci3")
	if (enabled):
		print("eccoci4")
		SignalBus.emit_signal("doorReached")
		print("Area raggiunta!")
		enabled = false

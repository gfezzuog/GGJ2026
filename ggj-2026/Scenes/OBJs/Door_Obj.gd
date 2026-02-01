#@tool
class_name Door_Obj extends Obj


func _ready() -> void:
	SignalBus.connect("doorDisabled", _on_disabled)
	pass
# Funzione che prende in input una matrice tipo [ [1, 0], [1, 1] ]
# e crea una collision shape per ogni "1", organizzate come indica la matrice.
# Poi salva le collision shape in un'altra matrice, mettendo "null" dove
# c'erano degli "0"
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
				
				body.set_collision_layer_value(3, true)
				body.set_collision_mask_value(3, true)
				body.set_collision_mask_value(3, true)
				
				add_child(body)
				collisionShapes.append(collisionShape)
				
			# altrimenti appendi null
			else:
				collisionShapes.append(null)
	
	#applyMask( [Vector2i(7,14), Vector2i(8,14), Vector2i(9,14), Vector2i(10,14), Vector2i(11,14),
	#			Vector2i(7,15), Vector2i(8,15), Vector2i(9,15), Vector2i(10,15), Vector2i(11,15), Vector2i(12,15)] )

var Disabled = false

func _on_disabled():
	Disabled = !Disabled

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not Disabled:
		SignalBus.emit_signal("doorReached")
		print("Area raggiunta!")

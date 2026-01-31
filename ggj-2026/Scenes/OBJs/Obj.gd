#@tool
class_name Obj extends Node2D



@export var size := Vector2i(1, 1)

# coordinate
@export var pos := Vector2i(0, 0)

# in che layer e' posizionato
@export var layer: int = 0

@export var collisionInfo: Array[int]



# Array per shader
var collisionShapesForShader: Array[CollisionShape2D] = []

# Matrice contenente gli static body 2D che genero dentro _ready
var collisionShapes: Array[CollisionShape2D] = []

#var areasCreated = false
const SQUARE_SIZE = 46


#func _ready() -> void:
#	createCollisionShapes(collisionInfo)
#	applyMask( [Vector2i(4,16), Vector2i(4,17)] )

# Funzione che prende in input una matrice tipo [ [1, 0], [1, 1] ]
# e crea una collision shape per ogni "1", organizzate come indica la matrice.
# Poi salva le collision shape in un'altra matrice, mettendo "null" dove
# c'erano degli "0"
func createCollisionShapes(collisionsInfo: Array[int]) -> void:
	# i itera sulle righe, j itera sulle colonne
	for i in range(0, size[0]):
		for j in range(0, size[1]):
			# se in posizione (i,j) c'e' un "1" crea la shape. visto che non e' una
			# matrice ma un array, corrisponde alla posizione  i*size[1]+j
			if (collisionsInfo[j*size[0]+i] == 1):
				# Crea area
				var body:= StaticBody2D.new()
				body.position.y += SQUARE_SIZE/2.0 + j*SQUARE_SIZE
				body.position.x += SQUARE_SIZE/2.0 + i*SQUARE_SIZE

				# Crea collision shape
				var collisionShape = CollisionShape2D.new()
				collisionShape.shape = RectangleShape2D.new()
				collisionShape.shape.size = Vector2(SQUARE_SIZE, SQUARE_SIZE)
				body.add_child(collisionShape)
				
				body.set_collision_layer_value(1, true)
				body.set_collision_mask_value(1, true)
				
				add_child(body)
				collisionShapes.append(collisionShape)
				
			# altrimenti appendi null
			else:
				collisionShapes.append(null)
	
	
# Funzione che riceve tutte le coordinate di una maschera, le passa allo shader,
# e una per una le usa per disabilitare le collisioni
func applyMask(maskCoords: Array[Vector2i]):
	# Disabilita collisioni
	for coord in maskCoords:
		print(coord)
		disableCollision(coord.x, coord.y)
	
	# questo e' da passare allo shader
	var rect_data: Array[Vector4] = []
	
	for collisionShape in collisionShapesForShader:
		var local = to_local(collisionShape.global_position)
		var center_uv = Vector2(
			local.x / $Sprite2D.texture.get_size().x,
			local.y / $Sprite2D.texture.get_size().y
		)

		# Convertiamo la dimensione in UV
		var size_uv = collisionShape.shape.size / $Sprite2D.texture.get_size()
		rect_data.append(Vector4(
			center_uv.x, center_uv.y, size_uv.x, size_uv.y
		))
		
	# Aggiorniamo lo shader
	$Sprite2D.material.set_shader_parameter("rect_count", rect_data.size())
	$Sprite2D.material.set_shader_parameter("rects", rect_data)
	
# Funzione a cui passi delle coordinate globali (su 21 quadretti) di quali collisioni
# disabilitare. Le coordinate vengono convertite in locali usando come riferimento la posizione
# dell'oggetto. Poi, se le coordinate ottenute "cadono" dentro l'oggetto, vengono disattivate
# le relative collisioni
func disableCollision(x, y):
	var xLocal = x - pos[0]
	var yLocal = y - pos[1]

	# se le coordinate cadono dentro l'oggetto
	if (xLocal < size[0] and yLocal < size[1]):
		print("sono dentro l'oggetto")
		
		# se in quelle coordinate c'e' una collision shape
		var collisionShape: CollisionShape2D = collisionShapes[yLocal*size[1] + xLocal]
		#print(collisionShapes)
		#print(xLocal*size[0] + yLocal)
		if (collisionShape != null):
			print("la collision esiste")
			# passo la collision shape allo shader
			collisionShapesForShader.append(collisionShape)
			
			
			
			#print("disabilito collisione")
			collisionShape.disabled = true
		

			

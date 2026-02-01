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


func _ready() -> void:
#	createCollisionShapes(collisionInfo)
	#applyMask( [Vector2i(14,11)] )
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
				
				body.set_collision_layer_value(1, true)
				body.set_collision_mask_value(1, true)
				
				add_child(body)
				collisionShapes.append(collisionShape)
				
			# altrimenti appendi null
			else:
				collisionShapes.append(null)
	
	#applyMask( [Vector2i(7,14), Vector2i(8,14), Vector2i(9,14), Vector2i(10,14), Vector2i(11,14),
	#			Vector2i(7,15), Vector2i(8,15), Vector2i(9,15), Vector2i(10,15), Vector2i(11,15), Vector2i(12,15)] )

	
# Funzione che riceve tutte le coordinate di una maschera, le passa allo shader,
# e una per una le usa per disabilitare le collisioni
func applyMask(maskCoords: Array[Vector2i]):
	# Disabilita collisioni
	for coord in maskCoords:
		#print(coord)
		disableCollision(coord.x, coord.y)
	
	# questo e' da passare allo shader
	var rect_data: Array[Vector4] = []
	
	print("collision shape size: ", collisionShapesForShader.size())
	for collisionShape in collisionShapesForShader:
		var local = to_local(collisionShape.global_position)
		local = collisionShape.global_position - SignalBus.offset
		
		#tentativo anna
		#local = position
		#var center_uv = Vector2(
			#local.x / $Sprite2D.texture.get_size().x,
			#local.y / $Sprite2D.texture.get_size().y
		#)
		
		#var center_uv = Vector2(
			#local.x + 0.5*SQUARE_SIZE,
			#local.y + 0.5*SQUARE_SIZE
		#)

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
	print("aggiorniamo lo shader")
	print(rect_data)
	if ($Sprite2D.material):
		$Sprite2D.material.set_shader_parameter("rect_count", rect_data.size())
		$Sprite2D.material.set_shader_parameter("rects", rect_data)
		
# Funzione a cui passi delle coordinate globali (su 21 quadretti) di quali collisioni
# disabilitare. Le coordinate vengono convertite in locali usando come riferimento la posizione
# dell'oggetto. Poi, se le coordinate ottenute "cadono" dentro l'oggetto, vengono disattivate
# le relative collisioni
func disableCollision(x, y):
	print(self)
	print("coordinate: " + str(x) + " " + str(y))
	print("pos 0: ", pos[0])
	print("pos 1: ", pos[1])
	#14,11
	# pos di spine e' 8,10
	var xLocal = x - pos[0]  # 6 -> colonna
	var yLocal = y - pos[1]  # 1 -> riga

	# se le coordinate cadono dentro l'oggetto
	if (xLocal >= 0 and xLocal < size[0] and yLocal >= 0 and yLocal < size[1]):		# CORRETTO
		#print("sono dentro l'oggetto")
		
		# se in quelle coordinate c'e' una collision shape
		#print("collision shapes:", collisionShapes)
		var collisionShape: CollisionShape2D = collisionShapes[yLocal*size[0] + xLocal] # deve fare 14
		#print(collisionShapes)
		#print(xLocal*size[0] + yLocal)
		if (collisionShape != null):
			print("la collision esiste")
			# passo la collision shape allo shader
			collisionShapesForShader.append(collisionShape)
			
			#print("disabilito collisione")
			collisionShape.disabled = true
		

func disableMask(maskCoords: Array[Vector2i]):
	# Abilita collisioni
	for coord in maskCoords:
		#print(coord)
		enableCollision(coord.x, coord.y)
	
	collisionShapesForShader = []
	
	# questo e' da passare allo shader
	var rect_data: Array[Vector4] = []

	# Aggiorniamo lo shader
	print("aggiorniamo lo shader")
	print(rect_data)
	if ($Sprite2D.material):
		$Sprite2D.material.set_shader_parameter("rect_count", rect_data.size())
		$Sprite2D.material.set_shader_parameter("rects", rect_data)

func enableCollision(x, y):

	var xLocal = x - pos[0]  # 6 -> colonna
	var yLocal = y - pos[1]  # 1 -> riga

	# se le coordinate cadono dentro l'oggetto
	if (xLocal >= 0 and xLocal < size[0] and yLocal >= 0 and yLocal < size[1]):		# CORRETTO
		#print("sono dentro l'oggetto")
		
		# se in quelle coordinate c'e' una collision shape
		#print("collision shapes:", collisionShapes)
		var collisionShape: CollisionShape2D = collisionShapes[yLocal*size[0] + xLocal] # deve fare 14

		if (collisionShape != null):
			print("la collision esiste")
			collisionShape.disabled = false

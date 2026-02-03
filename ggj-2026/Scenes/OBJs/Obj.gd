#@tool
class_name Obj extends Node2D


@export var size := Vector2i(1, 1)
@export var pos := Vector2i(0, 0) ## coordinate
@export var layer: int = 0 ## in che layer e' posizionato
@export var collision_info: Array[int]

## Array per shader
var collision_shapes_for_shader: Array[CollisionShape2D] = []

## Matrice contenente gli static body 2D che genero dentro _ready
var collision_shapes: Array[CollisionShape2D] = []

## Array contenente tutte le coorinate che sono state disattivate
var disabled_coords: Array[Vector2i] = []

const SQUARE_SIZE = 46


## Funzione che prende in input una matrice tipo [ [1, 0], [1, 1] ]
## e crea una collision shape per ogni "1", organizzate come indica la matrice.
## Poi salva le collision shape in un'altra matrice, mettendo "null" dove
## c'erano degli "0"
func create_collision_shapes(collisions_info: Array[int]) -> void:
	# i itera sulle righe, j itera sulle colonne
	for i in range(0, size[1]):		# righe (3)
		for j in range(0, size[0]):		# colonne (8)
			# se in posizione (i,j) c'e' un "1" crea la shape. visto che non e' una
			# matrice ma un array, corrisponde alla posizione  i*size[1]+j
			if (collisions_info[i*size[0]+j] == 1):
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
				collision_shapes.append(collisionShape)
				
			# altrimenti appendi null
			else:
				collision_shapes.append(null)


## Funzione che riceve tutte le coordinate di una maschera, le passa allo shader,
## e una per una le usa per disabilitare le collisioni
func apply_mask(mask_coords: Array[Vector2i]):
	# Disabilita collisioni
	for coord in mask_coords:
		disable_collision(coord.x, coord.y)
	
	# Questo e' da passare allo shader
	var rect_data: Array[Vector4] = []
	
	for collision_shape in collision_shapes_for_shader:
		var local = to_local(collision_shape.global_position)
		local = collision_shape.global_position - SignalBus.offset
		
		var center_uv = Vector2(
			local.x / $Sprite2D.texture.get_size().x,
			local.y / $Sprite2D.texture.get_size().y
		)

		# Convertiamo la dimensione in UV
		var size_uv = collision_shape.shape.size / $Sprite2D.texture.get_size()
		rect_data.append(Vector4(
			center_uv.x, center_uv.y, size_uv.x, size_uv.y
		))
		
	# Aggiorniamo lo shader
	if ($Sprite2D.material):
		$Sprite2D.material.set_shader_parameter("rect_count", rect_data.size())
		$Sprite2D.material.set_shader_parameter("rects", rect_data)


func disable_mask(mask_coords: Array[Vector2i]):
	# Abilita collisioni
	for coord in mask_coords:
		enable_collision(coord.x, coord.y)
	
	collision_shapes_for_shader = []
	
	# questo e' da passare allo shader
	var rect_data: Array[Vector4] = []

	# Aggiorniamo lo shader
	if ($Sprite2D.material):
		$Sprite2D.material.set_shader_parameter("rect_count", rect_data.size())
		$Sprite2D.material.set_shader_parameter("rects", rect_data)


## Funzione a cui passi delle coordinate globali (su 21 quadretti) di quali collisioni
## disabilitare. Le coordinate vengono convertite in locali usando come riferimento la posizione
## dell'oggetto. Poi, se le coordinate ottenute "cadono" dentro l'oggetto, vengono disattivate
## le relative collisioni
func disable_collision(x, y):
	var xLocal = x - pos[0]  # -> colonna
	var yLocal = y - pos[1]  # -> riga

	# se le coordinate cadono dentro l'oggetto
	if (xLocal >= 0 and xLocal < size[0] and yLocal >= 0 and yLocal < size[1]):		# CORRETTO		
		# se in quelle coordinate c'e' una collision shape
		var collision_shape: CollisionShape2D = collision_shapes[yLocal*size[0] + xLocal] # deve fare 14
		if (collision_shape != null):
			# passo la collision shape allo shader
			collision_shapes_for_shader.append(collision_shape)
			collision_shape.disabled = true
			
			# Le coordinate vengono registrare come disabilitate
			disabled_coords.append(Vector2i(xLocal, yLocal))


## WARNING: Poichè c'è un erase, non usare questa funzione iterando disabled_coords!
func enable_collision(x, y):
	var xLocal = x - pos[0]
	var yLocal = y - pos[1]
	
	# se le coordinate cadono dentro l'oggetto
	if (xLocal >= 0 and xLocal < size[0] and yLocal >= 0 and yLocal < size[1]):		# CORRETTO
		# se in quelle coordinate c'e' una collision shape
		var collisionShape: CollisionShape2D = collision_shapes[yLocal*size[0] + xLocal] # deve fare 14
		
		if (collisionShape != null):
			collisionShape.disabled = false
			
			# Le coordinate non sono più registrare come disabilitate
			disabled_coords.erase(Vector2i(xLocal, yLocal))

class_name Obj extends Node2D

@export var id: String
@export var size := Vector2i(1, 1) ## x: colonne, y: righe;
@export var collision_pos := Vector2i(0, 0) ## Coordinate delle collision rispetto alla texture. x: colonne, y: righe
@export var pos := Vector2i(0, 0) ## Coordinate della texture rispetto al nodo che la contiene (Game). x: colonne, y: righee
@export var layer: int = 0 ## In che layer e' posizionato l'oggetto

## Matrice contenente gli static body 2D che genero dentro _ready
var collision_shapes: Array[CollisionShape2D] = []

## Array contenente tutte le coorinate che sono state disattivate [1 disattivate, 0 attive]. Serve allo shader
var disabled_coords: Array[int] = []

var texture_dimension := Vector2(966,966)
var disabled: bool = false : set = _set_disabled

const SQUARE_SIZE = 46
const SQUARE_NUMBER = 22


func _ready() -> void:
	
	for r in size.y:
		for c in size.x:
			collision_shapes.append(null)
			disabled_coords.append(0)
	
	var file_info: LevelInfo = load("res://resources/data/data_loader.tres")
	var active_rel_coordinates: Array[Vector2i] = file_info.get_object_active_relative_coordinates(id)
	
	## Crea collisioni degli oggetti nascondibili con maschere
	_create_collision_shapes(active_rel_coordinates)
	
	var first_child = get_child(0)
	if first_child is Sprite2D:
		texture_dimension = first_child.texture.get_size()
	elif first_child is AnimatedSprite2D:
		texture_dimension = first_child.sprite_frames.get_frame_texture(first_child.animation, 0).get_size()
	
	if $Sprite2D.material.get_shader_parameter("voronoi_id_texture") == null:
		var varanoi_texture = _create_texture_mask_map(int(texture_dimension.x), int(texture_dimension.y), active_rel_coordinates)
		$Sprite2D.material.set_shader_parameter("voronoi_id_texture", varanoi_texture)
		ResourceSaver.save(varanoi_texture, "res://resources/voronoi_textures/"+id+".tres")


func _set_disabled(new_value: bool) -> void:
	if new_value == disabled:
		return
	
	disabled = new_value
	if disabled:
		hide()
	else:
		show()
	for shape in collision_shapes:
		shape.disabled = disabled


## Funzione che prende in input una matrice tipo [ [1, 0], [1, 1] ]
## e crea una collision shape per ogni "1", organizzate come indica la matrice.
## Poi salva le collision shape in un'altra matrice, mettendo "null" dove
## c'erano degli "0"
func _create_collision_shapes(coordinates: Array[Vector2i]) -> void:
	for coord in coordinates:
		# Crea area
		var body:= StaticBody2D.new()
		body.position.x += SQUARE_SIZE/2.0 + (coord.x + collision_pos.x)*SQUARE_SIZE
		body.position.y += SQUARE_SIZE/2.0 + (coord.y + collision_pos.y)*SQUARE_SIZE

		# Crea collision shape
		var collisionShape = CollisionShape2D.new()
		collisionShape.shape = RectangleShape2D.new()
		collisionShape.shape.size = Vector2(SQUARE_SIZE, SQUARE_SIZE)
		body.add_child(collisionShape)
		
		body.set_collision_layer_value(1, true)
		body.set_collision_mask_value(2, true)
		
		add_child(body)
		collision_shapes[(coord.y * size.x) + coord.x] = collisionShape


func _create_texture_mask_map(width: int, height: int, rel_coords: Array[Vector2i]) -> Texture:
	var img := Image.create(width, height, false, Image.FORMAT_RF)
	
	var offset: Vector2 = collision_pos * SQUARE_SIZE
	for y in height:
		for x in width:
			var uv := Vector2(x / float(width), y / float(height))

			var min_d := INF
			var best: Vector2i

			for coord in rel_coords:
				var local_position: Vector2 = (Vector2(coord) + (Vector2.ONE * 0.5)) * SQUARE_SIZE
				var point: Vector2 = (local_position + offset)/ texture_dimension
				var d := uv.distance_to(point)
				if d < min_d:
					min_d = d
					best = coord
			
			var color_id = best.y * size.x + best.x
			img.set_pixel(x, y, Color(float(color_id), 0, 0))
	
	return ImageTexture.create_from_image(img)


func _create_texture_voronoi_debug(
	width: int,
	height: int,
	points: Array[Vector2]
) -> Texture:
	var img := Image.create(width, height, false, Image.FORMAT_RF)

	for y in range(height):
		for x in range(width):
			var uv := Vector2(
				(x + 0.5) / float(width),
				(y + 0.5) / float(height)
			)

			var min_d := INF
			var best := 0

			for i in range(points.size()):
				var d := uv.distance_to(points[i])
				if d < min_d:
					min_d = d
					best = i

			# Scriviamo l'ID ESATTO come float
			img.set_pixel(x, y, Color(float(best), 0, 0))

	return ImageTexture.create_from_image(img)


func get_local_coord(abs_coord: Vector2i) -> Vector2i:
	return abs_coord - pos - collision_pos


## Funzione che riceve tutte le coordinate di una maschera, le passa allo shader,
## e una per una le usa per disabilitare le collisioni
func apply_mask(mask_coords: Array[Vector2i]):
	# Disabilita collisioni
	for coord in mask_coords:
		disable_collision(coord.x, coord.y, true)
		if (coord.x - pos.x >= collision_pos.x) and (coord.x - pos.x < collision_pos.x + size.x):
			if (coord.y - pos.y >= collision_pos.y) and (coord.y - pos.y < collision_pos.y + size.y):
				var local_coord: Vector2i = get_local_coord(coord)
				disabled_coords[local_coord.y * size.x + local_coord.x] = 1
	
	# Aggiorniamo lo shader
	if ($Sprite2D.material):
		$Sprite2D.material.set_shader_parameter("active_mask", disabled_coords)


func disable_mask(mask_coords: Array[Vector2i]):
	## Abilita collisioni
	for coord in mask_coords:
		disable_collision(coord.x, coord.y, false)
		if (coord.x - pos.x >= collision_pos.x) and (coord.x - pos.x < collision_pos.x + size.x):
			if (coord.y - pos.y >= collision_pos.y) and (coord.y - pos.y < collision_pos.y + size.y):
				disabled_coords[(coord.y - pos.y - collision_pos.y) * size.x + (coord.x - pos.x - collision_pos.x)] = 0
	
	if ($Sprite2D.material):
		$Sprite2D.material.set_shader_parameter("active_mask", disabled_coords)


## Funzione a cui passi delle coordinate globali (su 21 quadretti) di quali collisioni
## disabilitare. Le coordinate vengono convertite in locali usando come riferimento la posizione
## dell'oggetto. Poi, se le coordinate ottenute "cadono" dentro l'oggetto, vengono disattivate/abilitate
## le relative collisioni.
## value == true per disabilitare le collisione; value == true per attivarle
func disable_collision(x: int, y: int, value: bool):
	var x_local = x - collision_pos.x
	var y_local = y - collision_pos.y

	# se le coordinate cadono dentro l'oggetto
	if (x_local >= 0 and x_local < size[0] and y_local >= 0 and y_local < size[1]):
		# se in quelle coordinate c'e' una collision shape
		var collision_shape: CollisionShape2D = collision_shapes[y_local*size.x + x_local]
		if (collision_shape != null):
			collision_shape.disabled = value

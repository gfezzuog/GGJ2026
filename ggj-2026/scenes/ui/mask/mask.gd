@tool
class_name Mask extends Resource

const MASK_SIZE = 164.0
const GAME_SIZE = 1066.0

@export var polygons: Array[PackedVector2Array] = []
var textures: Array[Texture] = [] ## Contiene la texture originale, e quelle ruotate
var polygons_transformed: Array = [] ## Contiene i poligoni originali, e quelli ruotati
var index: int = 0


func init() -> void:
	var texture = generate_texture(polygons)
	textures.append(texture)
	polygons_transformed.append(polygons)
	
	var new_coords: Array[PackedVector2Array] = polygons
	for i in 3:
		var res = _rotate_ninenty_antiorario(new_coords)
		new_coords = res[0]
		polygons_transformed.append(new_coords)
		
		textures.append(res[1])


func get_texture() -> Texture:
	if textures == []:
		init()
	return textures[index]


func get_polygons() -> Array[PackedVector2Array]:
	if polygons_transformed.is_empty():
		init()
	return polygons_transformed[index]


## Funzione che presa la lista di coordinate dei quadrati neri genera una texture
func generate_texture(input_polygons: Array[PackedVector2Array]) -> ImageTexture:
	var image = Image.create(int(MASK_SIZE), int(MASK_SIZE), false, Image.FORMAT_RGBA8)
	image.fill(Color("ffffffff"))

	var scale_f = MASK_SIZE / GAME_SIZE

	for polygon in input_polygons:
		# Scala vertici
		var points: PackedVector2Array = []
		for p in polygon:
			points.append(Vector2(p.x * scale_f, p.y * scale_f))

		# Triangola
		var indices = Geometry2D.triangulate_polygon(points)

		# Disegna triangoli
		for i in range(0, indices.size(), 3):
			var a = points[indices[i]]
			var b = points[indices[i + 1]]
			var c = points[indices[i + 2]]

			_fill_triangle(image, a, b, c, Color("3b3d44"))

	return ImageTexture.create_from_image(image)


func _fill_triangle(image: Image, a: Vector2, b: Vector2, c: Vector2, color: Color):
	var min_x = int(floor(min(a.x, b.x, c.x)))
	var max_x = int(ceil(max(a.x, b.x, c.x)))
	var min_y = int(floor(min(a.y, b.y, c.y)))
	var max_y = int(ceil(max(a.y, b.y, c.y)))

	for x in range(min_x, max_x):
		for y in range(min_y, max_y):
			var p = Vector2(x, y)
			if _point_in_triangle(p, a, b, c):
				image.set_pixel(x, y, color)


func _point_in_triangle(p, a, b, c):
	var area = abs((b - a).cross(c - a))
	var area1 = abs((a - p).cross(b - p))
	var area2 = abs((b - p).cross(c - p))
	var area3 = abs((c - p).cross(a - p))

	return abs(area - (area1 + area2 + area3)) < 0.5


func _rotate_ninenty_antiorario(polygons_to_r: Array[PackedVector2Array]) -> Array:
	var new_polygons: Array[PackedVector2Array] = []
	for polygon in polygons_to_r:
		var new_polygon: PackedVector2Array
		for p in polygon:
			var new_value = Vector2(p.y - (GAME_SIZE/2.0), p.x - (GAME_SIZE/2.0))
			new_value.x = -new_value.x
			new_value += Vector2(GAME_SIZE/2.0, GAME_SIZE/2.0)
			new_polygon.push_back(new_value)
		new_polygons.append(new_polygon)
	
	var new_tetxure: Texture = generate_texture(new_polygons)
	
	return [new_polygons, new_tetxure]


func rotate() -> void:
	index = (index + 1) % 4

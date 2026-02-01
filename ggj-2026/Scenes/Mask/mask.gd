class_name  Mask extends TextureRect

signal mask_dragged(value: bool, mask: Mask)

const SQUARE_SIZE = 46
const CANVAS_SIZE = 966
const CANVAS_SQUARES_PER_SIDE = 21

@export var coords: Array[Vector2i] = []
@export var coord_position: Vector2i = Vector2i(0, 0)
@export var layer: int = 0
var layer_parent: LayerMenuRow = null
var dragged: bool = false
var hovered: bool = false
var activated: bool = false


func _ready() -> void:
	pass
	 # Genera texture e assegnala
	#texture = generate_texture([Vector2i(0,0), Vector2i(4,8), Vector2i(4,9)])


func _process(_delta: float) -> void:
	if hovered and Input.is_action_just_pressed("click") and not dragged:
		dragged = true
		Cursor.change_in_dragged()
		mask_dragged.emit(true, self)
	if Input.is_action_just_released("click") and dragged:
		dragged = false
		Cursor.change_in_arrow()
		mask_dragged.emit(false, self)


## Ritorna le coordinate rispetto alla griglia del livello che la maschera copre
func get_mask_coords() -> Array[Vector2i]:
	return coords


# Funzione che presa la lista di coordinate dei quadrati neri genera una texture
func generate_texture(mask: Array[Vector2i]) -> ImageTexture:
	# Crea immagine vuota
	var image = Image.create(CANVAS_SIZE, CANVAS_SIZE, false, Image.FORMAT_RGBA8)
	image.fill(Color.WHITE)
	# Aggiungi rettangoli
	for i in range(0, mask.size()):
		rectangle(image, mask[i][0]*SQUARE_SIZE, mask[i][1]*SQUARE_SIZE, SQUARE_SIZE, SQUARE_SIZE, Color.BLACK)
	# Crea texture a partire dall'immagine
	var new_texture = ImageTexture.create_from_image(image)
	return new_texture


# Funzione che disegna un rettangolo
func rectangle(image_screen:Image, pos_x:int, pos_y:int, width:int, height:int, color:Color) -> void: 
	for i in range(pos_x, pos_x + width): 
		for j in range(pos_y, pos_y + height):             
			image_screen.set_pixel(i,j,color) 


func rotate_ninenty_orario():
	var new_coords: Array[Vector2i] = []
	for coord in coords:
		var new_value = Vector2i(coord.y - 10, coord.x - 10)
		new_value.y = -new_value.y
		new_value += Vector2i(10, 10)
		new_coords.push_back(new_value)
	coords = new_coords
	var new_tetxure: Texture = generate_texture(coords)
	texture = new_tetxure


func rotate_ninenty_antiorario():
	var new_coords: Array[Vector2i] = []
	for coord in coords:
		var new_value = Vector2i(coord.y - 10, coord.x - 10)
		new_value.x = -new_value.x
		new_value += Vector2i(10, 10)
		new_coords.push_back(new_value)
	coords = new_coords
	var new_tetxure: Texture = generate_texture(coords)
	texture = new_tetxure


func _on_mouse_entered() -> void:
	hovered = true


func _on_mouse_exited() -> void:
	hovered = false

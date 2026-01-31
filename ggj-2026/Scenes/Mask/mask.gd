class_name  Mask extends TextureRect

signal mask_dragged(value: bool, mask: Mask)

const SQUARE_SIZE = 46
const CANVAS_SIZE = 966
const CANVAS_SQUARES_PER_SIDE = 21

## Gli array dentro la shape rappresentano le righe, i valori dentro gli array sono gli indici ddelle 
## colonne in cui è attiva la mashera. Esempio di maschera(* dove c'è la maschera, 0 dove non c'è):
## [0 * *]
## [0 0 0]
## [0 * 0]
## La shape è quindi [[1,2], [], [1]]
@export var shape: Array[Array] = []
@export var coord_position: Vector2i = Vector2i(0, 0)
@export var layer: int = 0
var layer_parent: LayerMenuRow = null
var dragged: bool = false
var hovered: bool = false
var activated: bool = false


func _ready() -> void:
	 # Genera texture e assegnala
	texture = generate_texture([Vector2i(0,0), Vector2i(4,8), Vector2i(4,9)])

func _process(_delta: float) -> void:
	if hovered and Input.is_action_just_pressed("click") and not dragged:
		print("[MASK]: Inviamo")
		dragged = true
		mask_dragged.emit(true, self)
	if Input.is_action_just_released("click") and dragged:
		dragged = false
		mask_dragged.emit(false, self)


## Ritorna le coordinate rispetto alla griglia del livello che la maschera copre
func get_mask_coords() -> Array[Vector2i]:
	var coords: Array[Vector2i] = []
	
	for row in range(shape.size()):
		for column in shape[row]:
			coords.push_back(Vector2i(coord_position.x + row, coord_position.y + column))
	
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
	var texture = ImageTexture.create_from_image(image)
	return texture

# Funzione che disegna un rettangolo
func rectangle(image_screen:Image, pos_x:int, pos_y:int, width:int, height:int, color:Color) -> void: 
	for i in range(pos_x, pos_x + width): 
		for j in range(pos_y, pos_y + height):             
			image_screen.set_pixel(i,j,color) 


func _on_mouse_entered() -> void:
	hovered = true


func _on_mouse_exited() -> void:
	hovered = false

class_name  Mask extends TextureRect

signal mask_dragged(value: bool, mask: Mask)

## Gli array dentro la shape rappresentano le righe, i valori dentro gli array sono gli indici ddelle 
## colonne in cui è attiva la mashera. Esempio di maschera(* dove c'è la maschera, 0 dove non c'è):
## [0 * *]
## [0 0 0]
## [0 * 0]
## La shape è quindi [[1,2], [], [1]]
@export var shape: Array[Array] = []
@export var coord_position: Vector2i = Vector2i(0, 0)
@export var layer: int = 0
var dragged: bool = false
var hovered: bool = false
var activated: bool = false


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

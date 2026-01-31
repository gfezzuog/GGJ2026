class_name  Mask extends TextureRect

signal mask_dragged(value: bool, mask: Mask)


@export var coords: Array[Vector2i] = []
@export var layer: int = 0
var layer_parent: LayerMenuRow = null
var dragged: bool = false
var hovered: bool = false
var activated: bool = false


func _process(_delta: float) -> void:
	if hovered and Input.is_action_just_pressed("click") and not dragged:
		dragged = true
		mask_dragged.emit(true, self)
	if Input.is_action_just_released("click") and dragged:
		dragged = false
		mask_dragged.emit(false, self)


## Ritorna le coordinate rispetto alla griglia del livello che la maschera copre
func get_mask_coords() -> Array[Vector2i]:
	return coords


func _on_mouse_entered() -> void:
	hovered = true


func _on_mouse_exited() -> void:
	hovered = false

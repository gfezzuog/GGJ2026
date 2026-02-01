
extends VBoxContainer

@export var number_layer = 3
@export var dragged_dimension := Vector2(60, 60)
var mask_textures: Array
@onready var layers_row: Array[LayerMenuRow] = [
	$LayerMenuRow,
	$LayerMenuRow2,
	$LayerMenuRow3,
	$LayerMenuRow4,
	$LayerMenuRow5,
]
@export var layers_preview: Array[Texture] = []


func _ready() -> void:
	for i in range(number_layer):
		#var packed_scene: PackedScene = load("res://Scenes/LayersMenu/LayerMenuRow.tscn")
		#var row = packed_scene.instantiate()
		var row = get_child(i)
		row.layer_number = i
		if layers_preview.size() > i:
			row.set_layer_preview(layers_preview[i])
		#add_child(row)
	for j in range(5 - number_layer):
		var row = get_child(j + number_layer)
		row.layer_number = j + number_layer
		row.disable()


func create_masks():
	for i in range(mask_textures.size()):
		var coordinates: Array = mask_textures[i]
		if coordinates != []:
			var packed_mask: PackedScene = load("res://Scenes/Mask/Mask.tscn")
			var new_mask: Mask = packed_mask.instantiate()
			var texture = new_mask.generate_texture(coordinates)
			new_mask.texture = texture
			new_mask.coords = coordinates
			var row = get_child(i)
			row.add_mask(new_mask)
			row.mask_disabled = true
			new_mask.mask_dragged.connect(_on_mask_dragged)


func _on_mask_dragged(value: bool, mask: Mask):
	if value == true:
		var packed_dragged_mask: PackedScene = load("res://Scenes/LayersMenu/DraggedMask.tscn")
		var dragged_mask = packed_dragged_mask.instantiate()
		dragged_mask.dimension = dragged_dimension
		dragged_mask.reference_mask = mask
		$Node.add_child(dragged_mask)
	else:
		var child = $Node.get_child(0)
		$Node.remove_child(child)
	

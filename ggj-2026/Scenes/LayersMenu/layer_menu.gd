
extends VBoxContainer

@export var number_layer = 3
@export var dragged_dimension := Vector2(80, 80)
@export var mask_textures: Array[Texture] = []
var layers_row: Array[LayerMenuRow] = []


func _ready() -> void:
	for i in range(number_layer):
		var packed_scene: PackedScene = load("res://Scenes/LayersMenu/LayerMenuRow.tscn")
		var row = packed_scene.instantiate()
		row.layer_number = get_child_count()
		if i < mask_textures.size():
			var texture = mask_textures[layers_row.size() - 1]
			var packed_mask: PackedScene = load("res://Scenes/Mask/Mask.tscn")
			var new_mask: Mask = packed_mask.instantiate()
			new_mask.texture = texture
			new_mask.mask_dragged.connect(_on_mask_dragged)
			row.add_mask(new_mask)
		add_child(row)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		if number_layer >= 0 and layers_row.size() != number_layer:
			var difference: int = number_layer - layers_row.size()
			if difference > 0:
				for i in range(difference + 1):
					var packed_scene: PackedScene = load("res://Scenes/LayersMenu/LayerMenuRow.tscn")
					var row: LayerMenuRow = packed_scene.instantiate()
					layers_row.push_back(row)
					row.layer_number = layers_row.size() - 1
					if mask_textures.size() >= layers_row.size():
						var texture = mask_textures[layers_row.size() - 1]
						var packed_mask: PackedScene = load("res://Scenes/Mask/Mask.tscn")
						var new_mask: Mask = packed_mask.instantiate()
						new_mask.texture = texture
						row.add_mask(new_mask)
					add_child(row)
			else:
				for i in range(-difference):
					var child = layers_row.pop_back()
					if child is LayerMenuRow:
						remove_child(child)


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
	

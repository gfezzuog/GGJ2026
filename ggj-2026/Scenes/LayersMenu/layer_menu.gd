@tool
extends VBoxContainer

@export var number_layer = 3
@export var dragged_dimension := Vector2(80, 80)


func _ready() -> void:
	for i in range(number_layer):
		var packed_scene: PackedScene = load("res://Scenes/LayersMenu/LayerMenuRow.tscn")
		var row = packed_scene.instantiate()
		row.layer_number = get_child_count()
		add_child(row)
	for child in get_children():
		if child is LayerMenuRow:
			var mask: Mask = child.get_mask()
			mask.mask_dragged.connect(_on_mask_dragged)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		if get_child_count() != number_layer:
			var difference: int = number_layer - get_child_count() + 1
			if difference > 0:
				for i in range(difference + 1):
					var packed_scene: PackedScene = load("res://Scenes/LayersMenu/LayerMenuRow.tscn")
					var row = packed_scene.instantiate()
					row.layer_number = get_child_count()
					add_child(row)
			else:
				for i in range(-difference):
					var child = get_child(-1)
					remove_child(child)


func _on_mask_dragged(value: bool, mask: Mask):
	if value == true:
		var packed_dragged_mask: PackedScene = load("res://Scenes/LayersMenu/DraggedMask.tscn")
		var dragged_mask = packed_dragged_mask.instantiate()
		dragged_mask.dimension = dragged_dimension
		dragged_mask.texture = mask.texture
		$Node.add_child(dragged_mask)
	else:
		var child = $Node.get_child(0)
		$Node.remove_child(child)
	

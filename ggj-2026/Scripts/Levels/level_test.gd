@tool
extends Node2D



const GRID_SIZE := 21
const CELL_SIZE := 46
const SCREEN_SIZE := 966  # opzionale, solo per controllo


var grid := []

func _ready():
	init_grid()
	for child in $Objs.get_children():
		place_object(child)

func init_grid():
	grid.clear()
	for y in GRID_SIZE:
		var row := []
		for x in GRID_SIZE:
			row.append(null)
		grid.append(row)

func place_object(obj) -> bool:

	obj.position = obj.pos * GRID_SIZE
	return true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		for child in $Objs.get_children():
			child.position = child.pos * GRID_SIZE

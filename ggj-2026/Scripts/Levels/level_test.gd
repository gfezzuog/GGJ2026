@tool
extends Node2D



const GRID_SIZE := 21
const CELL_SIZE := 46
const SCREEN_SIZE := 966  # opzionale, solo per controllo

var mask := []
var grid := []

func _ready():
	init_grid()
	for child in $Objs.get_children():
		place_object(child)
	#mask = $Mask.get_mask_coords()
	#change_mask()

#func change_mask():
	#for child in $Objs.get_children():
		#print(mask)
		#for i in range(mask.size()) :
			#print(mask[i])
			#if (mask[i] == child.pos):
				#print("la Maskera ha trovato un oggetto\n")
	
	

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

@tool
class_name Level extends Control

const GRID_SIZE := 21
const CELL_SIZE := 46
const SCREEN_SIZE := 966  # opzionale, solo per controllo

var grid := []

func _ready():
	init_grid()
	var mask : Array[Vector2i] = $Mask.get_mask_coords()
	change_mask(mask)
	for child in $Objs.get_children():
		place_object(child)


func change_mask(mask):
	#for child in $Objs.get_children():
	print(grid)	#print(mask)
	for i in range(mask.size()) :
		print(mask[i])
		print("PEFFORZA", grid[mask[i].x][mask[i].y])
		#for j in range(grid.size()) :
			#if (mask[i] == grid[j]) :
				#print("hai trovato l'oggetto negraccio")
	#

func init_grid():
	grid.clear()
	for y in GRID_SIZE:
		var row := []
		for x in GRID_SIZE:
			row.append(null)
		grid.append(row)


func place_object(obj) -> bool:

	obj.position = obj.pos * GRID_SIZE
	for i in obj.size.x:
		print("valore di i ", i)
		for j in obj.size.y:
			print("valore di j ", j)
			grid[obj.pos.x + i][obj.pos.y + j] = obj
	for i in obj.size.x:
		for j in obj.size.y:#grid.insert(obj.pos.x, obj.size.x)
			print(grid[obj.pos.x + i][obj.pos.y + j])
	print(grid)	#print(mask)
	return true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		for child in $Objs.get_children():
			child.position = child.pos * GRID_SIZE

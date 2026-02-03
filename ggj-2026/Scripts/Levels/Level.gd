#@tool
class_name Level extends Control

const GRID_SIZE := 21
const CELL_SIZE := 46
const SCREEN_SIZE := 966  # opzionale, solo per controllo

var grid := []

func _ready():
	init_grid()
	#var mask : Array[Vector2i] = $Mask.get_mask_coords()
	#change_mask(mask)
	for child in $HBoxContainer/Canvas/Objs.get_children():
		place_object(child)
	
	# collega segnale su maschera abilitata
	SignalBus.connect("mask_enabled", apply_mask)
	SignalBus.connect("mask_disabled", disable_mask)


func change_mask(mask):
	#for child in $Objs.get_children():
	#print(grid)	#print(mask)
	for i in range(mask.size()) :
		#print(mask[i])
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
			row.append([])
		grid.append(row)


func place_object(obj) -> bool:
	if ((obj.pos[0] + obj.size[0] > GRID_SIZE) or (obj.pos[1] + obj.size[1] > GRID_SIZE)):
		printerr("stai posizionando un oggetto fuori dalla griglia")
		pass
		
	obj.position = obj.pos * CELL_SIZE
	obj.get_child(0).position = -obj.position
	
	for i in obj.size.x:
		#print("valore di i ", i)
		for j in obj.size.y:
			#print("valore di j ", j)
			grid[obj.pos.x + i][obj.pos.y + j].append(obj)
	#for i in obj.size.x:
		#for j in obj.size.y:
			#print(grid[obj.pos.x + i][obj.pos.y + j])
	#print(grid)	#print(mask)
	return true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta: float) -> void:
	#if Engine.is_editor_hint():
		#for child in $Objs.get_children():
			#child.position = child.pos * GRID_SIZE

# Level si connette al segnale mask_enabled che ci passa la maschera, e il layer su cui e' attiva
func apply_mask(mask: Mask, layer: int):
	var objectsThatMustBeRemoved = []
	for coord in mask.coords:
		
		var list_ob = grid[coord.x][coord.y]
		#print("layer di apply mask")
		#print(layer)
		for ob in list_ob:
			if (ob and ob.layer == layer):
				if ob not in objectsThatMustBeRemoved:
					objectsThatMustBeRemoved.append(ob)
	
		# qua sotto e' se grid contiene liste
		#var objects = grid[coord.x][coord.y]
		#print(objects)
		#for ob in objects:
			#if (ob.layer == layer):
				#if ob not in objectsThatMustBeRemoved:
					#objectsThatMustBeRemoved.append(ob)
					
	for ob in objectsThatMustBeRemoved:
		ob.apply_mask(mask.coords)


func disable_mask(mask: Mask, layer: int):
	var objectsThatMustBeRemoved = []
	for coord in mask.coords:
		var list_ob = grid[coord.x][coord.y]
		for ob in list_ob:
			if (ob and ob.layer == layer):
				if ob not in objectsThatMustBeRemoved:
					objectsThatMustBeRemoved.append(ob)
	for ob in objectsThatMustBeRemoved:
		ob.disable_mask(mask.coords)

@tool
extends Node2D

@export var cell_size: int = 64
@export var grid_width: int = 1024
@export var grid_height: int = 1024
@export var color: Color = Color(1, 1, 1, 0.2)
@export var highlight_color: Color = Color(1, 0, 0, 0.3)

var hovered_cell: Vector2i = Vector2i(-1, -1)

func _process(_delta):
	if Engine.is_editor_hint():
		update_hover()
		queue_redraw()

func update_hover():
	var mouse_pos = get_local_mouse_position()

	var x = int(mouse_pos.x / cell_size)
	var y = int(mouse_pos.y / cell_size)

	# Controllo limiti
	if mouse_pos.x < 0 or mouse_pos.y < 0 or mouse_pos.x > grid_width or mouse_pos.y > grid_height:
		hovered_cell = Vector2i(-1, -1)
	else:
		hovered_cell = Vector2i(x, y)

func _draw():
	# Disegna griglia
	for x in range(0, grid_width + 1, cell_size):
		draw_line(Vector2(x, 0), Vector2(x, grid_height), color)

	for y in range(0, grid_height + 1, cell_size):
		draw_line(Vector2(0, y), Vector2(grid_width, y), color)

	# Evidenzia cella hover
	if hovered_cell.x >= 0:
		var pos = Vector2(hovered_cell) * cell_size
		draw_rect(Rect2(pos, Vector2(cell_size, cell_size)), highlight_color)

		# (opzionale) stampa indice
		$Label.text = "Indice: " + str(hovered_cell)
		$Label2.text = "Indice: " + str(hovered_cell)
		$Label3.text = "Indice: " + str(hovered_cell)

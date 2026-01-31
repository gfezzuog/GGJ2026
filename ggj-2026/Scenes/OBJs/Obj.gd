#@tool
class_name Obj extends Node2D



@export var size := Vector2(1, 1)

# coordinate
@export var pos := Vector2(0, 0)

# in che layer e' posizionato
@export var layer: int = 0


# Funzione che prende in input una matrice tipo [ [1, 0], [1, 1] ]
# e crea una collision shape per ogni "1", organizzate come indica la matrice.
# Poi salva le collision shape in un'altra matrice, mettendo "null" dove
# c'erano degli "0"

# Matrice contenente le aree 2D che genero dentro _ready
#var areas: Array[Array] = [[]]

#var areasCreated = false
const SQUARE_SIZE = 46
#func _(delta: float) -> void:
	#if (!areasCreated):
		#print("creating area")
		#areasCreated = true
		#if Engine.is_editor_hint:
			## crea collision shapes
			#for i in range(0, size[0]):
				##areas.append(Array())
				#for j in range(0, size[1]):
					## Crea area
					#var area = Area2D.new()
					#add_child(area)
					##areas[i].append(area)
					## offset
					#area.position.x += SQUARE_SIZE/2.0 + i*SQUARE_SIZE
					#area.position.y += SQUARE_SIZE/2.0 + j*SQUARE_SIZE
#
					## Crea collision shape
					#var collisionShape = CollisionShape2D.new()
					#collisionShape.shape = RectangleShape2D.new()
					#collisionShape.shape.size = Vector2(SQUARE_SIZE, SQUARE_SIZE)
	
			

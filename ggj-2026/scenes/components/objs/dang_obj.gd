class_name Dang_Obj extends Obj


## Funzione che prende in input una matrice tipo [ [1, 0], [1, 1] ]
## e crea una area2D per ogni "1", organizzate come indica la matrice.
## Poi salva le collision shape in un'altra matrice, mettendo "null" dove
## c'erano degli "0"
func _create_collision_shapes(coordinates: Array[Vector2i]) -> void:
	for coord in coordinates:
		# Crea area
		var area := Area2D.new()
		area.position.x += SQUARE_SIZE/2.0 + (coord.x + collision_pos.x)*SQUARE_SIZE
		area.position.y += SQUARE_SIZE/2.0 + (coord.y + collision_pos.y)*SQUARE_SIZE

		# Crea area2D
		var collisionShape = CollisionShape2D.new()
		collisionShape.shape = RectangleShape2D.new()
		collisionShape.shape.size = Vector2(SQUARE_SIZE, SQUARE_SIZE)
		area.add_child(collisionShape)
		
		area.set_collision_layer_value(1, true)
		area.set_collision_mask_value(2, true)
		
		area.body_entered.connect(_on_body_entered)
		
		add_child(area)
		collision_shapes[(coord.y * size.x) + coord.x] = collisionShape


func _on_body_entered(body: Node2D):
	if body is Player:
		body.game_over()

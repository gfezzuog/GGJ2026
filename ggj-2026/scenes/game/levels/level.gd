class_name Level extends SubViewportContainer


@export var mask_highlight_color := Color(Colors.HIGHLIGHT, 0.5)
@export var layer_id: int = 0
@export var player_starting_position: Vector2
@export var checkpoints: Array[Vector2] = []
var mask_to_draw: PackedVector2Array = []
var player: Player
var checkpoints_counter: int = 0


func _ready() -> void:
	# Crea death zone sotto la canvas
	var death_area := Area2D.new()
	var collision_shape := CollisionShape2D.new()
	collision_shape.shape = RectangleShape2D.new()
	collision_shape.shape.size = Vector2(2800, 200)
	death_area.monitorable = false
	death_area.collision_mask = 2
	death_area.add_child(collision_shape)
	death_area.body_entered.connect(_on_death_area_body_entered)
	death_area.position = Vector2(400, 1180)
	$SubViewport.add_child(death_area)
	
	# Crea pareti laterali
	var wall_left_area := StaticBody2D.new()
	var wall_left_collision_shape := CollisionShape2D.new()
	wall_left_collision_shape.shape = RectangleShape2D.new()
	wall_left_collision_shape.shape.size = Vector2(200, 1100)
	wall_left_area.collision_layer = 1
	wall_left_area.add_child(wall_left_collision_shape)
	wall_left_area.position = Vector2(-100, 550)
	$SubViewport/Layers.add_child(wall_left_area)
	var wall_right_area := StaticBody2D.new()
	var wall_right_collision_shape := CollisionShape2D.new()
	wall_right_collision_shape.shape = RectangleShape2D.new()
	wall_right_collision_shape.shape.size = Vector2(200, 1100)
	wall_right_area.collision_layer = 1
	wall_right_area.add_child(wall_right_collision_shape)
	wall_right_area.position = Vector2(1170, 550)
	$SubViewport/Layers.add_child(wall_right_area)


func init() -> void:
	# Connette con i segnali
	SignalBus.mask_activated.connect(_on_mask_enabled)
	SignalBus.mask_disactivated.connect(_on_mask_disabled)
	SignalBus.mask_rotated.connect(_on_mask_rotated)
	SignalBus.show_mask.connect(show_mask)
	SignalBus.hide_mask.connect(hide_mask)
	SignalBus.highlight_layer.connect(highlight_layer)
	SignalBus.game_over.connect(_on_game_over)


func reset():
	SignalBus.mask_activated.disconnect(_on_mask_enabled)
	SignalBus.mask_disactivated.disconnect(_on_mask_disabled)
	SignalBus.mask_rotated.disconnect(_on_mask_rotated)
	SignalBus.show_mask.disconnect(show_mask)
	SignalBus.hide_mask.disconnect(hide_mask)
	SignalBus.highlight_layer.disconnect(highlight_layer)
	SignalBus.game_over.disconnect(_on_game_over)


func add_player(_player: Player) -> void:
	player = _player
	player.position = player_starting_position
	$SubViewport.add_child(player)


func put_player_in_starting_position() -> void:
	if (player):
		player.position = player_starting_position


func remove_player() -> void:
	$SubViewport.remove_child(player)


func show_mask(polygons: Array[PackedVector2Array]) -> void:
	$MaskShower.show_mask(polygons)


func hide_mask() -> void:
	$MaskShower.hide_mask()


func apply_mask(layer: int, mask: Mask) -> void:
	var mask_pol: Array[PackedVector2Array] = mask.get_polygons()
	var layer_node = $SubViewport/Layers.get_child(layer)
	
	for obj: GameObj in layer_node.get_children():
		obj.apply_difference(mask_pol)
	
	layer_node.material.set_shader_parameter("mask_texture", mask.get_texture())


func reset_mask(layer: int) -> void:
	var layer_node = $SubViewport/Layers.get_child(layer)
	
	#for obj: GameObj in layer_node.get_children():
	var children = layer_node.find_children("*", "GameObj", false)
	#print(children)
	for obj in children:
		obj.reset()
	
	layer_node.material.set_shader_parameter("mask_texture", null)


func highlight_layer(layer: int, value: bool) -> void:
	var layer_node = $SubViewport/Layers.get_child(layer)
	if value == false:
		var tween = create_tween()
		tween.tween_method(
			func(v): layer_node.material.set_shader_parameter("highlight_enabled", v),
			1.0, 0.0, 0.3
		)
	else:
		var tween = create_tween()
		tween.tween_method(
			func(v): layer_node.material.set_shader_parameter("highlight_enabled", v),
			0.0, 1.0, 0.3
		)


func change_child_material(node_path: String, new_material: Material) -> void:
	var child: CanvasItem = get_node(node_path)
	child.use_parent_material = false
	child.material = new_material


func reset_child_material(node_path: String) -> void:
	var child: CanvasItem = get_node(node_path)
	child.use_parent_material = true
	child.material = null


func _on_mask_enabled(mask: Mask, layer: int) -> void:
	reset_mask(layer)
	apply_mask(layer, mask)


func _on_mask_disabled(layer: int) -> void:
	reset_mask(layer)


func _on_mask_rotated(mask: Mask, layer: int) -> void:
	reset_mask(layer)
	apply_mask(layer, mask)


func _on_death_area_body_entered(body: Node2D) -> void:
	body.game_over()


func _on_game_over() -> void:
	if checkpoints.size() and checkpoints_counter:
		player.position = checkpoints[checkpoints_counter - 1]
	else:
		player.position = player_starting_position
	player.animate_death()

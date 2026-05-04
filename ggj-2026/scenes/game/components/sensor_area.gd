class_name SensorArea extends Area2D

@export var node_to_disable: GameObj
var is_covered: bool = false
var to_check: bool = false
var counter: int = 0


func _ready() -> void:
	if node_to_disable:
		node_to_disable.shape_changed.connect(_on_shape_changed)


func _physics_process(_delta: float) -> void:
	if to_check:
		var value = is_covered_now()
		if not is_covered and value:
			is_covered = true
			node_to_disable._apply_disable(true)
		elif is_covered and not value:
			is_covered = false
			node_to_disable._check_and_apply_disable()
		counter += 1
		if counter >= 4:
			to_check = false


func is_covered_now() -> bool:
	var space_state = get_world_2d().direct_space_state
	
	var query = PhysicsShapeQueryParameters2D.new()
	query.shape = $CollisionShape2D.shape
	query.transform = $CollisionShape2D.global_transform
	query.collision_mask = collision_mask
	query.collide_with_bodies = true

	return space_state.intersect_shape(query).size() > 0


func _on_shape_changed() -> void:
	to_check = true
	counter = 0

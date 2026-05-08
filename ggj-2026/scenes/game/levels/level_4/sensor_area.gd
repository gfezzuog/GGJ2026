extends SensorArea

signal covered(value: bool)


func _physics_process(_delta: float) -> void:
	if to_check:
		var value = is_covered_now()
		if not is_covered and value:
			is_covered = true
			covered.emit(is_covered)
		elif is_covered and not value:
			is_covered = false
			covered.emit(is_covered)
		counter += 1
		if counter >= 4:
			to_check = false

extends Control

var inside: bool = false


func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func _on_mouse_entered() -> void:
	print("INSIDE: ", name)
	inside = true
	Cursor.change_in_hand()


func _on_mouse_exited() -> void:
	print("FUORI: ", name)
	inside = false
	Cursor.change_in_arrow()

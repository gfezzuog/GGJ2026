extends Node

var arrow = load("res://Assets/Cursor/Arrow piccolo.png")
var hand = load("res://Assets/Cursor/Hand piccolo.png")
var close_hand = load("res://Assets/Cursor/Hand_Drag piccolo_Resized.png")


func change_in_arrow():
	Input.set_custom_mouse_cursor(arrow)


func change_in_hand():
	Input.set_custom_mouse_cursor(hand)


func change_in_dragged():
	Input.set_custom_mouse_cursor(close_hand)

extends Node

var arrow = load("res://assets/placeholder/cursor/arrow_piccolo.png")
var hand = load("res://assets/placeholder/cursor/hand_piccolo.png")
var close_hand = load("res://assets/placeholder/cursor/hand_drag_piccolo_resized.png")


func change_in_arrow():
	Input.set_custom_mouse_cursor(arrow)


func change_in_hand():
	Input.set_custom_mouse_cursor(hand)


func change_in_dragged():
	Input.set_custom_mouse_cursor(close_hand)

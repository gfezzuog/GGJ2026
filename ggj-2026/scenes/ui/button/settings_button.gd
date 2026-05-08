@tool
class_name SettingButtons extends Control

signal pressed

@export var title: String = "Test"
@export var description: String = "Testo di prova"
@export var texture: Texture = null : set = _set_texture
@export var offset_y: int = 0
#@export var margin: Array[int] = [8, 8, 8, 0] ## Left, Top, Right, Bottom
var margin: Array[int] = [8, 8, 8, 0]
var hover_color: Color = Color("#3d3b44")
var pressed_color: Color = Color("#2e2c33")
var shadow_size: int = 4
var border_size: int = 2
@onready var panel: StyleBoxFlat = $Button.get_theme_stylebox("panel")
var inside: bool = false


func _ready() -> void:
	$Node2D/PanelContainer/VBoxContainer/Title.text = "[b]" + title + "[/b]"
	$Node2D/PanelContainer/VBoxContainer/Description.text = description
	$Button/TextureRect.texture = texture
	$Node2D.position.y += offset_y
	panel.content_margin_left = margin[0]
	panel.content_margin_top = margin[1]
	panel.content_margin_right = margin[2]
	panel.content_margin_bottom = margin[3]
	


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and inside:
		$AudioClick.play()
		panel.bg_color = pressed_color
	elif event.is_action_released("click") and inside:
		panel.bg_color = hover_color
		pressed.emit()


func _set_texture(new_texture: Texture) -> void:
	texture = new_texture
	if has_node("$Button/TextureRect"):
		$Button/TextureRect.texture = texture


func _on_mouse_entered() -> void:
	inside = true
	panel.bg_color.a = 1.0
	panel.shadow_size = shadow_size
	panel.set_border_width_all(border_size)
	$Node2D/PanelContainer.show()


func _on_mouse_exited() -> void:
	inside = false
	panel.bg_color.a = 0.0
	panel.shadow_size = 0
	panel.set_border_width_all(0)
	$Node2D/PanelContainer.hide()
	panel.bg_color = hover_color

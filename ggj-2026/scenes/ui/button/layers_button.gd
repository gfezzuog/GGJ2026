@tool
class_name LayerButton extends PanelContainer

signal pressed(value: bool)

@export var texture: Texture = null
@export var toggle_mode: bool = false : set = _set_toggle_mode
@export var texture_toggled: Texture = null
@export var disabled: bool = false : set = _set_disabled

@export var texture_color := Color("#10232a")
@export var texture_disabled_color := Color("#5f5e64")

@export_group("Colors")
@export var color := Color("#19a7e3")
@export var color_highlight := Color("#67c9fd")
@export var color_disabled := Color("a79e9cff")
@export var outer_color := Color("d3c3b9")

@export_group("Margin")
@export var content_margin: Dictionary = {"left": 0, "top": 0, "right": 0, "bottom": 0} : set = _set_content_margin

@onready var outer_panel: StyleBoxFlat = get_theme_stylebox("panel")
@onready var inner_panel: StyleBoxFlat = $PanelContainer.get_theme_stylebox("panel")

var inside: bool = false
var toggle_status: bool = false : set = _set_toggle_status

var state_normal = {
	outer_panel = {
		"content_margin" = {left = 0, top = 5, right = 5, bottom = 5},
		"border_width" = {left = 0, top = 3, right = 3, bottom = 3},
	},
	inner_panel = {
		"content_margin" = {left = 9, top = 12, right = 11, bottom = 12}
	}
}

var state_pressed = {
	outer_panel = {
		"content_margin" = {left = 0, top = 4, right = 4, bottom = 4},
		"border_width" = {left = 0, top = 2, right = 2, bottom = 2},
	},
	inner_panel = {
		"content_margin" = {left = 9, top = 13, right = 12, bottom = 13}
	}
}


func _ready() -> void:
	$PanelContainer/TextureRect.texture = texture
	_set_property(inner_panel, "content_margin", state_normal["inner_panel"])
	_update_status()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and inside:
		$AudioClick.play()
		_pressed()
		_apply_state(state_pressed)
	elif event.is_action_released("click") and inside:
		_apply_state(state_normal)


func _validate_property(property: Dictionary):
	if property.name == "texture_toggled" and not toggle_mode:
		property.usage = PROPERTY_USAGE_NO_EDITOR
	if property.name == "texture_disabled_toggled" and not toggle_mode:
		property.usage = PROPERTY_USAGE_NO_EDITOR


func _set_toggle_mode(value: bool) -> void:
	toggle_mode = value
	notify_property_list_changed()


func _set_disabled(value: bool) -> void:
	disabled = value
	_update_status()


func _update_status():
	if not is_inside_tree():
		return
	
	if toggle_mode and toggle_status:
		$PanelContainer/TextureRect.texture = texture_toggled
	else:
		$PanelContainer/TextureRect.texture = texture
	
	if disabled:
		inside = false
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		inner_panel.bg_color = color_disabled
		outer_panel.bg_color = color_disabled
		$PanelContainer/TextureRect.self_modulate = texture_disabled_color
	else:
		mouse_filter = Control.MOUSE_FILTER_STOP
		inner_panel.bg_color = color
		outer_panel.bg_color = outer_color
		$PanelContainer/TextureRect.self_modulate = texture_color


func _set_content_margin(new_value: Dictionary) -> void:
	content_margin = new_value
	
	state_normal.inner_panel.content_margin = new_value
	state_pressed.inner_panel.content_margin.left = new_value.left
	state_pressed.inner_panel.content_margin.top = new_value.top + 1
	state_pressed.inner_panel.content_margin.right = new_value.right + 1
	state_pressed.inner_panel.content_margin.bottom = new_value.bottom + 1


func _set_property(panel: StyleBoxFlat, property: String, state):
	for s in ["left", "top", "right", "bottom"]:
		panel.set(property + "_" + s, state[property][s])


func _set_toggle_status(value: bool) -> void:
	toggle_status = value
	_update_status()


func _pressed() -> void:
	if toggle_mode:
		toggle_status = !toggle_status
	pressed.emit(toggle_status)


func _apply_state(state):
	_set_property(outer_panel, "content_margin", state["outer_panel"])
	_set_property(outer_panel, "border_width", state["outer_panel"])
	_set_property(inner_panel, "content_margin", state["inner_panel"])


func _on_mouse_entered() -> void:
	inside = true
	inner_panel.bg_color = color_highlight


func _on_mouse_exited() -> void:
	inside = false
	inner_panel.bg_color = color

extends Node


# Quando il player tocca una porta
@warning_ignore("unused_signal")
signal doorReached

# Quando il player muore
@warning_ignore("unused_signal")
signal game_over

@warning_ignore("unused_signal")
signal door_reached

@warning_ignore("unused_signal")
signal mask_disabled(mask, layer)

@warning_ignore("unused_signal")
signal mask_enabled(mask, layer)

# Popup
@warning_ignore("unused_signal")
signal open_popup_ok(text)

@warning_ignore("unused_signal")
signal open_popup_yes_no(text)

@warning_ignore("unused_signal")
signal popup_pressed_yes()

@warning_ignore("unused_signal")
signal popup_pressed_no()

@warning_ignore("unused_signal")
signal close_popup()

var offset = Vector2(171, 92.0)

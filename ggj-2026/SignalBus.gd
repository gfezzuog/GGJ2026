extends Node


# Quando il player tocca una porta
signal doorReached

# Quando il player muore
signal game_over

signal mask_disabled(mask, layer)
signal mask_enabled(mask, layer)

# Popup
signal open_popup(text)
signal close_popup()

var offset = Vector2(171, 92.0)

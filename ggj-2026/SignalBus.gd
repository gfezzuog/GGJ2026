extends Node


# Quando il player tocca una porta
signal doorReached

# Quando il player muore
signal game_over
# TODO

signal mask_disabled(mask, layer)
signal mask_enabled(mask, layer)

signal doorDisabled

var offset = Vector2(171, 92.0)

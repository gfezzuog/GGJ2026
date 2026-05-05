extends Node



# SEGNALI CONTROLLO DEL GIOCO

@warning_ignore("unused_signal")
signal game_over

@warning_ignore("unused_signal")
signal door_reached(door_x: float, door_y: float)

@warning_ignore("unused_signal")
signal door_reached_animation_ended()

@warning_ignore("unused_signal")
signal resume_game()			# segnale mandato alla chiusura di un menu

@warning_ignore("unused_signal")
signal open_menu_levels()

@warning_ignore("unused_signal")
signal open_menu_settings()

@warning_ignore("unused_signal")
signal restart_level()

@warning_ignore("unused_signal")
signal go_to_level(indx: int)


# SEGNALI MASCHERE

@warning_ignore("unused_signal")
signal mask_disabled(mask, layer)

@warning_ignore("unused_signal")
signal mask_enabled(mask, layer)

@warning_ignore("unused_signal")
signal mask_activated(mask: Mask, layer: int)

@warning_ignore("unused_signal")
signal mask_disactivated(layer: int)

@warning_ignore("unused_signal")
signal mask_rotated(mask: Mask, layer: int)

@warning_ignore("unused_signal")
signal show_mask(coords: Array[PackedVector2Array])

@warning_ignore("unused_signal")
signal hide_mask()

@warning_ignore("unused_signal")
signal highlight_layer(layer: int, value: bool)


#region DIALOG
@warning_ignore("unused_signal")
signal start_line(id: String)

@warning_ignore("unused_signal")
signal end_line(id: String)

@warning_ignore("unused_signal")
signal dialog_finished()

@warning_ignore("unused_signal")
signal dialog_closed(id: String)

#endregion

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

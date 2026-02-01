extends Node2D

# Da disattivare se la porta è in un livello ed e' coperta da una maschera
var enabled = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if (enabled):
		SignalBus.emit_signal("doorReached")
		print("Area raggiunta!")
		enabled = false

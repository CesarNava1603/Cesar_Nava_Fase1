extends Node2D

@onready var planetas := $Planetas.get_children()

func _on_timer_timeout():
	for planeta in planetas:
		planeta.angulo += 0.05

extends Area2D

# Tipo de poder
enum PowerType { SHIELD, PUSH, SPEED }
@export var power_type : PowerType


func _ready():
	area_entered.connect(_on_area_entered)

func _on_area_entered(area):
	if area.is_in_group("player"):
		area.apply_powerup(power_type)
		queue_free()

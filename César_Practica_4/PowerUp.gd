extends Area2D

# Tipo de poder
enum PowerType { SHIELD, PUSH, SPEED }
@export var power_type : PowerType


func _ready():
	add_to_group("powerups")
	area_entered.connect(_on_area_entered)
	print($CollectParticles)


func _on_area_entered(area):
	if area.is_in_group("player"):
		area.apply_powerup(power_type)
		$PowerUpSound.play()
		$CollectParticles.restart()
		$CollectParticles.emitting = true
		await get_tree().create_timer(0.4).timeout
		queue_free()

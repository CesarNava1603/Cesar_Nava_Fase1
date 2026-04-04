extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#func on_hit_npc():
#	global_position = Vector3.ZERO
#	get_tree().current_scene.show_message()

#func show_message():
#	$CanvasLayer/Label.text = "¡Golpeaste un NPC!"
#	$CanvasLayer/Label.visible = true

#	await get_tree().create_timer(2.0).timeout

#	$CanvasLayer/Label.visible = false

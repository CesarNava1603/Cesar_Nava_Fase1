extends Camera3D

@export var target: Node3D
@export var offset := Vector3(0, 8, 10)
@export var follow_speed := 5.0

func _process(delta):
	if target == null:
		return
	
	var desired_position = target.global_position + offset
	
	global_position = global_position.lerp(desired_position, follow_speed * delta)
	
	look_at(target.global_position, Vector3.UP)

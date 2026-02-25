extends RigidBody2D
var base_speed_modifier = 1.8
var base_speed = 0.0
var speed_modifier = 1.8
var push_force := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	$AnimatedSprite2D.animation = mob_types.pick_random()
	$AnimatedSprite2D.play()
	add_to_group("mobs")
	base_speed = linear_velocity.length()
	base_speed_modifier = speed_modifier

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta):
	if linear_velocity.length() > 0:
		var direction = linear_velocity.normalized()
		linear_velocity = direction * base_speed * speed_modifier + push_force

		if linear_velocity.x < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false

	push_force = push_force.move_toward(Vector2.ZERO, 1500 * delta)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

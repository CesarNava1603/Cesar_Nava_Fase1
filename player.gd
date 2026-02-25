extends Area2D
signal hit
@export var base_speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var shield_active = false
var speed_active = false
var current_speed = 0
var speed_bonus = 150
var push_force := Vector2.ZERO
const ProjectileScene = preload("res://Projectile.tscn")
var health := 3
signal health_changed(current_health)
var can_shoot = true
# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("player")
	screen_size = get_viewport_rect().size
	current_speed = base_speed
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * current_speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		# See the note below about the following boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x > 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
	if Input.is_action_just_pressed("shoot") and can_shoot:
		shoot()
		can_shoot = false
		$ShootCooldown.start()

func _on_ShootCooldown_timeout():
	can_shoot = true

func shoot():
	var projectile = ProjectileScene.instantiate()
	projectile.set_player(self)
	projectile.position = global_position
	get_parent().add_child(projectile)
	var mouse_pos = get_global_mouse_position()
	projectile.direction = (mouse_pos - global_position).normalized()
	get_parent().add_child(projectile)
	$ShootSound.play()
	$AnimatedSprite2D.play("shoot")

func _on_body_entered(_body):
	if not _body.is_in_group("mobs"):
		return
	if shield_active:
		shield_active = false
		modulate = Color(1, 1, 1)
		return
	health -= 1
	$DamageSound.play()
	$DamageParticles.restart()
	$DamageParticles.emitting = true
	health_changed.emit(health)
	if health <= 0:
		hit.emit()
		hide()
		$CollisionShape2D.set_deferred("disabled", true)
	 # Player disappears after being hit.

func start(pos):
	position = pos
	show()
	health = 3
	$CollisionShape2D.disabled = false
func apply_powerup(power_type):
	match power_type:
		0:
			shield_active = true
			modulate = Color(0.5, 0.8, 1.2)
		1:
			push_enemies()
		2:
			speed_active = true
			current_speed = base_speed + speed_bonus
			slow_enemies()
			$SpeedTimer.start(6)

func _on_speed_timer_timeout():
	speed_active = false
	current_speed = base_speed
	
	for mob in get_tree().get_nodes_in_group("mobs"):
		mob.speed_modifier = 1.0

func push_enemies():
	for mob in get_tree().get_nodes_in_group("mobs"):
		var direction = (mob.global_position - global_position).normalized()
		mob.push_force += direction * 2000

func slow_enemies():
	for mob in get_tree().get_nodes_in_group("mobs"):
		mob.speed_modifier = mob.base_speed_modifier * 0.6

func _on_AnimatedSprite2D_animation_finished():
	if $AnimatedSprite2D.animation == "shoot":
		$AnimatedSprite2D.play("walk")

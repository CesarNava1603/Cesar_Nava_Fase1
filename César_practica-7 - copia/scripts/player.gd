extends CharacterBody3D
@onready var model = $Chull  # cambia "Modelo" por el nombre real
@export var move_distance := 2.0   # tamaño de cada casilla
@export var move_speed := 6.0      # velocidad del "salto"
@export var spawn_point: Node3D
var target_position : Vector3
var is_moving := false
@onready var area = $Area3D
func _ready():
	target_position = global_position

func _process(delta):
	if is_moving:
		return
	if Input.is_action_just_pressed("move_forward"):
		move(Vector3.FORWARD)
	elif Input.is_action_just_pressed("move_back"):
		move(Vector3.BACK)
	elif Input.is_action_just_pressed("move_left"):
		move(Vector3.LEFT)
	elif Input.is_action_just_pressed("move_right"):
		move(Vector3.RIGHT)

func move(direction: Vector3):
	var new_pos = global_position + direction * move_distance
	if new_pos.x < -10 or new_pos.x > 10:
		return
	if new_pos.z < -25 or new_pos.z > 25:
		return
	target_position = new_pos
	is_moving = true
	rotate_model(direction)

func rotate_model(direction: Vector3):
	if direction == Vector3.ZERO:
		return
	
	var angle = atan2(direction.x, direction.z)
	
	# Ajuste del modelo (MUY IMPORTANTE)
	model.rotation.y = angle + deg_to_rad(270)

func _physics_process(delta):
	if is_moving:
		global_position = global_position.move_toward(
			target_position,
			move_speed * delta
		)
		# Cuando llega
		if global_position.distance_to(target_position) < 0.05:
			global_position = target_position
			is_moving = false
	check_npc_collision()

func check_npc_collision():
	var bodies = area.get_overlapping_bodies()
	
	for body in bodies:
		if body.is_in_group("npc"):
			on_hit_npc()
			break
			
func on_hit_npc():
	print("Golpeaste un NPC")
	global_position = Vector3.ZERO
	is_moving = false
	global_position = spawn_point.global_position


func _on_area_3d_body_entered(body):
	if body.is_in_group("npc"):
		on_hit_npc()

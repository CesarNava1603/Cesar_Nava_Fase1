extends CharacterBody3D
@onready var model = $Model_A
@export var move_distance := 10.0
@export var speed := 3.0
@export var move_direction := 1  # 1 o -1
var point_a : Vector3
var point_b : Vector3
var target : Vector3
@onready var model_a = $Model_A
@onready var model_b = $Model_B

func _ready():
	point_a = global_position
	point_b = point_a + Vector3(move_distance, 0, 0)

	randomize()
	if randi() % 2 == 0:
		model = model_a
		model_a.visible = true
		model_b.visible = false
	else:
		model = model_b
		model_a.visible = false
		model_b.visible = true

	update_rotation()
	target = point_b

func update_rotation():
	var base_angle
	
	if move_direction > 0:
		base_angle = deg_to_rad(90)
	else:
		base_angle = deg_to_rad(-90)
	
	# 👇 offsets individuales
	model_a.rotation.y = base_angle + deg_to_rad(0)  # ajusta este
	model_b.rotation.y = base_angle + deg_to_rad(90)   # ajusta este

func _physics_process(delta):
	velocity = Vector3(move_direction * speed, 0, 0)
	move_and_slide()
	# Si sale del mapa → eliminar
	if abs(global_position.x) > 20:
		queue_free()

	if global_position.distance_to(target) < 0.2:
		if target == point_a:
			target = point_b
		else:
			target = point_a

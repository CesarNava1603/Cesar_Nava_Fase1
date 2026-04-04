extends Node3D
@export var player: Node3D
@export var npc_scene: PackedScene
@export var spawn_interval := 2.0
@export var spawn_z := 0.0
@export var direction := -1  # izquierda o derecha
@export var lanes := [-6.0, -4.0, -2.0, 0.0, 2.0, 4.0, 6.0]
@export var spawn_range_x := 15.0

func _ready():
	spawn_loop()

func spawn_loop():
	while true:
		spawn_npc()
		await get_tree().create_timer(spawn_interval).timeout

func spawn_npc():
	if npc_scene == null or player == null:
		push_error("Falta npc_scene o player")
		return
	var npc = npc_scene.instantiate()
	var base_z = player.global_position.z
	var lane_z = base_z + lanes.pick_random()
	var spawn_side = randi() % 2
	var x
	if spawn_side == 0:
		x = -spawn_range_x
		npc.move_direction = 1
	else:
		x = spawn_range_x
		npc.move_direction = -1
	npc.global_position = Vector3(x, 3.0, lane_z)
	get_parent().add_child(npc)

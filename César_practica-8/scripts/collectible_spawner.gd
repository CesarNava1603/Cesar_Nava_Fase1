extends Node3D
var current_collectibles := 0
@export var collectible_scene: PackedScene
@export var spawn_area_size := Vector3(20, 0, 40)
@export var spawn_height := 1.0
@export var spawn_count := 5
@export var max_collectibles := 20
func _ready():
	randomize()
	spawn_collectibles()
	spawn_loop()

func spawn_loop():
	while true:
		await get_tree().create_timer(2.0).timeout
		if get_tree().get_nodes_in_group("collectible").size() >= max_collectibles:
			continue  # 👈 NO detener el loop
		spawn_one()
		
func spawn_collectibles():
	for i in range(spawn_count):
		spawn_one()

func spawn_one():
	if current_collectibles >= max_collectibles:
		return
	
	var collectible = collectible_scene.instantiate()
	
	current_collectibles += 1
	
	collectible.tree_exited.connect(_on_collectible_removed)
	
	var random_x = randf_range(-spawn_area_size.x, spawn_area_size.x)
	var random_z = randf_range(-spawn_area_size.z, spawn_area_size.z)
	var pos = Vector3(random_x, spawn_height, random_z)
	collectible.global_position = pos
	
	add_child(collectible)
func _on_collectible_removed():
	current_collectibles -= 1

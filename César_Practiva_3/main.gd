extends Node

@export var mob_scene: PackedScene
var score

const PowerUpShield = preload("res://PowerUpShield.tscn")
const PowerUpPush = preload("res://PowerUpPush.tscn")
const PowerUpSpeed = preload("res://PowerUpSpeed.tscn")

var powerup_scenes = [PowerUpShield, PowerUpPush, PowerUpSpeed]

const PowerUpScene = preload("res://PowerUp.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("powerups", "queue_free")
	$Music.play()

func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()

	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	mob.position = mob_spawn_location.position

	var direction = mob_spawn_location.rotation + PI / 2
	direction += randf_range(-PI / 4, PI / 4)

	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	add_child(mob)


func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()


func _on_powerup_timer_timeout():
	var scene = powerup_scenes[randi() % powerup_scenes.size()]
	var powerup = scene.instantiate()
	
	var screen_size = get_viewport().get_visible_rect().size
	powerup.position = Vector2(
		randf_range(0, screen_size.x),
		randf_range(0, screen_size.y)
	)

	powerup.collected.connect(_on_powerup_collected)
	add_child(powerup)
func _on_powerup_collected(power_type):
	$Player.apply_power(power_type)
func _on_power_up_timer_timeout():
	var scene = powerup_scenes.pick_random()
	var powerup = scene.instantiate()

	var screen_size = get_viewport().get_visible_rect().size
	powerup.position = Vector2(
		randf_range(0, screen_size.x),
		randf_range(0, screen_size.y)
	)

	add_child(powerup)

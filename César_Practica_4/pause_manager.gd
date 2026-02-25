extends Node

@onready var pause_ui = get_node("../PauseUI")

func _ready():
	pause_ui.visible = false

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

func toggle_pause():
	get_tree().paused = !get_tree().paused
	pause_ui.visible = get_tree().paused

func _on_resume_button_pressed():
	get_tree().paused = false
	pause_ui.visible = false

func _on_restart_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

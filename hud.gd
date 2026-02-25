extends CanvasLayer
@onready var game_over_ui = $GameOverUI
# Notifies `Main` node that the button has been pressed
signal start_game
var score = 0
@onready var hearts = [
	$HeartsContainer/Heart1,
	$HeartsContainer/Heart2,
	$HeartsContainer/Heart3
]

@export var heart_full : Texture2D
@export var heart_empty : Texture2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_over_ui.visible = false
	$StartMenu.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show_game_over(score):
	game_over_ui.visible = true
	var score_label = $GameOverUI/Panel/VBoxContainer/ScoreLabel
	score_label.text = "Score: " + str(score)
	get_tree().paused = true
	# Wait until the MessageTimer has counted down.


func update_score(score):
	$ScoreLabel.text = str(score)

func _on_start_button_pressed():
	$StartMenu.hide()
	start_game.emit()
	

func _on_message_timer_timeout():
	$Message.hide()

func _on_restart_button_pressed():
	get_tree().paused = false
	game_over_ui.visible = false
	start_game.emit()

func update_health(current_health):
	for i in range(hearts.size()):
		if i < current_health:
			hearts[i].texture = heart_full
		else:
			hearts[i].texture = heart_empty

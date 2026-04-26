extends Label

var highscore := 0

func _ready():
	GameManager.score_changed.connect(update_all)
	APIManager.advice_changed.connect(update_all)
	
	highscore = Database.get_highscore()
	update_all()

func update_all():
	# Actualizar highscore en runtime
	if GameManager.score > highscore:
		highscore = GameManager.score
	
	text = "Puntos: " + str(GameManager.score) + \
	"\nHighscore: " + str(highscore) + \
	"\nTip: " + APIManager.advice_text

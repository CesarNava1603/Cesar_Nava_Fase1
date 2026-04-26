extends Area3D

func _on_body_entered(body):
	if body.is_in_group("player"):
		GameManager.add_score()
		Database.save_if_highscore(GameManager.score)
		APIManager.get_advice()
		queue_free()

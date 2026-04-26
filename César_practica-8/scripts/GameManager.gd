extends Node

var score := 0

signal score_changed

func add_score():
	score += 1
	score_changed.emit()

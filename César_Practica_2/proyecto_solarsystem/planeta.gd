extends Node2D

@export var radio := 160.0
@export var velocidad := 1.0

var angulo := 0.0

func _process(delta):
	angulo += velocidad * delta
	position = Vector2(
		cos(angulo),
		sin(angulo)
	) * radio

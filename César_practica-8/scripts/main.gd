extends Node

var http: HTTPRequest
var speed_multiplier := 1.0
var advice_text := ""

signal advice_changed 

func _ready():
	http = HTTPRequest.new()
	add_child(http)
	
	http.request_completed.connect(_on_request_completed)
	get_advice()

func get_advice():
	var url = "https://api.adviceslip.com/advice"
	http.request(url)

func _on_request_completed(result, response_code, headers, body):
	var text = body.get_string_from_utf8()
	var json = JSON.parse_string(text)
	var advice = json["slip"]["advice"]

	advice_text = advice
	advice_changed.emit()  # 
	if advice.length() % 2 == 0:
		speed_multiplier = 2.0
	else:
		speed_multiplier = 0.7

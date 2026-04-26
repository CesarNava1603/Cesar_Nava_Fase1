extends Node

var db

func _ready():
	db = SQLite.new()
	db.path = "user://game_data.db"
	db.open_db()
	
	create_table()

func create_table():
	var query = """
	CREATE TABLE IF NOT EXISTS highscores (
		id INTEGER PRIMARY KEY,
		player_name TEXT,
		max_score INTEGER,
		date TEXT
	);
	"""
	
	db.query(query)

func save_score(score):
	var query = """
	INSERT INTO highscores (player_name, max_score, date)
	VALUES (?, ?, datetime('now'));
	"""
	
	db.query_with_bindings(query, ["Jugador", score])

func get_highscore():
	var success = db.query("SELECT MAX(max_score) as max FROM highscores")
	if success:
		var result = db.query_result
		if result.size() > 0:
			return result[0]["max"]
	return 0

func save_if_highscore(score):
	var high = get_highscore()
	if score > high:
		save_score(score)
	
	return 0

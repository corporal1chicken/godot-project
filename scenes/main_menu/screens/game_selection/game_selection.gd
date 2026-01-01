extends Control

@export_category("Game Selection")
## Available games. Clicking a button will check in this dictionary
@export var avaliable_games: Array[String]

var selected_game: String = ""

func _ready() -> void:
	for child in $games.get_children():
		child.pressed.connect(_on_game_pressed.bind(child.name))

func _on_game_pressed(game_name: String):
	selected_game = game_name
	$confirm.text = "continue with " + selected_game
	
	if selected_game != "":
		$confirm.disabled = false

extends Control

@export var difficulty_config: Dictionary = {
	"easy" = {},
	"medium" = {},
	"hard" = {}
}

@export var gamemode_config: Dictionary = {
	"first_to" = {
		"name" = "first_to",
		"total_rounds" = "inf",
		"max_score" = 3
	},
	"best_of" = {
		"name" = "best_of",
		"total_rounds" = 5
	},
	"survival" = {
		"name" = "survival",
		"total_rounds" = "inf"
	},
	"endless" = {
		"name" = "endless",
		"total_rounds" = "inf"
	},
	"comeback" = {
		"name" = "comeback",
		"total_rounds" = 8,
		"max_score" = 7,
		"starting_points" = 3
	},
	"no_repeat" = {
		"name" = "no_repeat",
		"total_rounds" = "inf"
	},
}

var chosen_difficulty: String = "easy"
var chosen_gamemode: String = "endless"

func _ready() -> void:
	for child in $difficulties.get_children():
		child.pressed.connect(_on_option_pressed.bind(["difficulty", child.name]))
		
	for child in $gamemodes.get_children():
		child.pressed.connect(_on_option_pressed.bind(["gamemode", child.name]))

func _on_option_pressed(args: Array):
	match args[0]:
		"gamemode":
			chosen_gamemode = args[1]
		"difficulty":
			chosen_difficulty = args[1]
			
	$start.text = "start " + chosen_gamemode.replace("_", " ") + " (" + chosen_difficulty + ")"

func get_selected_options() -> Dictionary:
	return {
		difficulty = difficulty_config[chosen_difficulty], 
		gamemode = gamemode_config[chosen_gamemode]
	}

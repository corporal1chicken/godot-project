extends Control

@export var difficulty_config: Dictionary = {
	"easy" = {},
	"medium" = {},
	"hard" = {}
}

@export var gamemode_conifg: Dictionary = {
	"first_to" = {},
	"best_of" = {},
	"survival" = {},
	"endless" = {}
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
		gamemode = gamemode_conifg[chosen_gamemode]
	}

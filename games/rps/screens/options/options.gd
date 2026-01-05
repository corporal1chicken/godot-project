extends Control

@export var difficulty_config: Dictionary = {
	"easy" = {
		"rules" = "Rules:\n- 12s timer",
		"timer_length" = 12
	},
	"medium" = {
		"rules" = "Rules:\n- 8s timer",
		"timer_length" = 8
	},
	"hard" = {
		"rules" = "Rules:\n- 4s timer",
		"timer_length" = 4
	}
}

@export var gamemode_config: Dictionary = {
	"first_to" = {
		"name" = "first_to",
		"rules" = "Rules:\n- Infinite Rounds\n- Game ends when soeone reaches 3 points",
		"total_rounds" = "inf",
		"max_score" = 3
	},
	"best_of" = {
		"name" = "best_of",
		"rules" = "Rules:\n- Total of 5 Rounds",
		"total_rounds" = 5
	},
	"survival" = {
		"name" = "survival",
		"rules" = "Rules:\n- Game ends when you lose your streak",
		"total_rounds" = "inf"
	},
	"endless" = {
		"name" = "endless",
		"rules" = "Rules:\n- There are mone",
		"total_rounds" = "inf"
	},
	"comeback" = {
		"name" = "comeback",
		"rules" = "Rules:\n- Total is 7 Rounds\n- AI starts on 3 points\n- Game ends when someone reaches 7 points",
		"total_rounds" = 8,
		"max_score" = 7,
		"starting_points" = 3
	},
	"no_repeat" = {
		"name" = "no_repeat",
		"rules" = "Rules:\n- Infinite Rounds\n- Game ends when you play the same move twice in a row",
		"total_rounds" = "inf"
	},
}

var chosen_difficulty: String = "easy"
var chosen_gamemode: String = "endless"

func _ready() -> void:
	for key in gamemode_config.keys():
		var button = _create_button(
			key,
			gamemode_config[key].rules,
			$gamemodes
		)
		
		button.pressed.connect(_on_option_pressed.bind(["gamemode", button.name]))
		
	for key in difficulty_config.keys():
		var button = _create_button(
			key,
			difficulty_config[key].rules,
			$difficulties
		)
		
		button.pressed.connect(_on_option_pressed.bind(["difficulty", button.name]))


func _create_button(text: String, tooltip: String, parent) -> Button:
	var clone: Button = $gamemodes/template.duplicate()
	clone.visible = true
	
	clone.text = text
	clone.tooltip_text = tooltip
	clone.name = text
	
	parent.add_child(clone)
	return clone
	
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

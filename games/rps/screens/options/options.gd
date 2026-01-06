extends Control

@export var difficulty_config: Dictionary = {
	"easy" = {
		"key" = "easy",
		"text" = "Easy",
		"rules" = "Rules:\n- 12s timer",
		"timer_length" = 12
	},
	"medium" = {
		"key" = "medium",
		"text" = "Medium",
		"rules" = "Rules:\n- 8s timer",
		"timer_length" = 8
	},
	"hard" = {
		"key" = "hard",
		"text" = "Hard",
		"rules" = "Rules:\n- 4s timer",
		"timer_length" = 4
	}
}

@export var gamemode_config: Dictionary = {
	"first_to" = {
		"key" = "first_to",
		"text" = "First To 3",
		"rules" = "Rules:\n- Infinite Rounds\n- Game ends when soeone reaches 3 points",
		"total_rounds" = "inf",
		"max_score" = 3
	},
	"best_of" = {
		"key" = "best_of",
		"text" = "Best of 5",
		"rules" = "Rules:\n- Total of 5 Rounds",
		"total_rounds" = 5
	},
	"survival" = {
		"key" = "survival",
		"text" = "Survival",
		"rules" = "Rules:\n- Double points\n- Game ends when you lose your streak",
		"total_rounds" = "inf",
		"points_on_win" = 2
	},
	"endless" = {
		"key" = "endless",
		"text" = "Endless",
		"rules" = "Rules:\n- There are mone",
		"total_rounds" = "inf"
	},
	"comeback" = {
		"key" = "comeback",
		"text" = "Comeback",
		"rules" = "Rules:\n- Total is 7 Rounds\n- AI starts on 3 points\n- Game ends when someone reaches 7 points",
		"total_rounds" = 8,
		"max_score" = 7,
		"starting_points" = 3
	},
	"no_repeat" = {
		"key" = "no_repeat",
		"text" = "No Repeat",
		"rules" = "Rules:\n- Infinite Rounds\n- Game ends when you play the same move twice in a row",
		"total_rounds" = "inf"
	},
}

@export var modifier_config: Dictionary = {
	"lock_input" = {
		"key" = "lock_input",
		"text" = "Lock Input",
		"rules" = "Once you pick your move, there's no switching!"
	},
	"double_points" = {
		"key" = "double_points",
		"text" = "Double Points",
		"rules" = "+2 for every win"
	},
	"on_edge" = {
		"key" = "on_edge",
		"text" = "On Edge",
		"rules" = "Every draw yields a 50% chance to lose 1 point"
	}
}

var chosen_difficulty: String = "easy"
var chosen_gamemode: String = "endless"
var chosen_modifier: String = ""

func _ready() -> void:
	for key in gamemode_config.keys():
		var button = _create_button(
			gamemode_config[key].key,
			gamemode_config[key].rules,
			gamemode_config[key].text,
			$gamemodes
		)
		
		button.pressed.connect(_on_option_pressed.bind(["gamemode", button.name]))
		
	for key in difficulty_config.keys():
		var button = _create_button(
			difficulty_config[key].key,
			difficulty_config[key].rules,
			difficulty_config[key].text,
			$difficulties
		)
		
		button.pressed.connect(_on_option_pressed.bind(["difficulty", button.name]))
	
	for key in modifier_config.keys():
		var button = _create_button(
			modifier_config[key].key,
			modifier_config[key].rules,
			modifier_config[key].text,
			$modifiers
		)
		
		button.pressed.connect(_on_option_pressed.bind(["modifier", button.name]))


func _create_button(key: String, tooltip: String, text: String, parent) -> Button:
	var clone: Button = $gamemodes/template.duplicate()
	clone.visible = true
	
	clone.text = text
	clone.tooltip_text = tooltip
	clone.name = key
	
	parent.add_child(clone)
	return clone
	
func _on_option_pressed(args: Array):
	match args[0]:
		"gamemode":
			chosen_gamemode = args[1]
		"difficulty":
			chosen_difficulty = args[1]
		"modifier":
			chosen_modifier = args[1]
			
	$start.text = "Start " + gamemode_config.get(chosen_gamemode).text + " (" + difficulty_config.get(chosen_difficulty).text + ")"

func get_selected_options() -> Dictionary:
	return {
		difficulty = difficulty_config[chosen_difficulty], 
		gamemode = gamemode_config[chosen_gamemode],
		modifier = modifier_config[chosen_modifier] if chosen_modifier != "" else null
	}

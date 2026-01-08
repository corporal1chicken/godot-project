extends Control

@export var difficulty_config: Dictionary = {
	"easy" = {
		"key" = "easy",
		"text" = "Easy",
		"description" = "Rules:\n- 12s timer",
		"timer_length" = 12
	},
	"medium" = {
		"key" = "medium",
		"text" = "Normal",
		"description" = "Rules:\n- 8s timer",
		"timer_length" = 8
	},
	"hard" = {
		"key" = "hard",
		"text" = "Hard",
		"description" = "Rules:\n- 4s timer",
		"timer_length" = 4
	}
}

@export var gamemode_config: Dictionary = {
	"first_to" = {
		"key" = "first_to",
		"text" = "First To 3",
		"description" = "Rules:\n- Infinite Rounds\n- Game ends when soeone reaches 3 points",
		"max_rounds" = -1,
		"max_score" = 3
	},
	"best_of" = {
		"key" = "best_of",
		"text" = "Best of 5",
		"description" = "Rules:\n- Total of 5 Rounds",
		"max_rounds" = 5
	},
	"survival" = {
		"key" = "survival",
		"text" = "Survival",
		"description" = "Rules:\n- Double points\n- Game ends when you lose your streak",
		"max_rounds" = -1,
		"points_on_win" = 2
	},
	"endless" = {
		"key" = "endless",
		"text" = "Endless",
		"description" = "Rules:\n- There are none",
		"max_rounds" = -1
	},
	"comeback" = {
		"key" = "comeback",
		"text" = "Comeback",
		"description" = "Rules:\n- Total is 7 Rounds\n- AI starts on 3 points\n- Game ends when someone reaches 7 points",
		"max_rounds" = 8,
		"max_score" = 7,
		"computer_score" = 3
	},
	"no_repeat" = {
		"key" = "no_repeat",
		"text" = "No Repeat",
		"description" = "Rules:\n- Infinite Rounds\n- Game ends when you play the same move twice in a row",
		"max_rounds" = -1
	},
}

@export var modifier_config: Dictionary = {
	"lock_input" = {
		"key" = "lock_input",
		"text" = "Lock Input",
		"description" = "Once you pick your move, there's no switching!"
	},
	"double_points" = {
		"key" = "double_points",
		"text" = "Double Points",
		"description" = "+2 for every win."
	},
	"on_edge" = {
		"key" = "on_edge",
		"text" = "On Edge",
		"description" = "Every draw yields a 50% chance to lose 1 point."
	},
	"false_sense" = {
		"key" = "false_sense",
		"text" = "Safety Net",
		"description" = "Your first loss doesn't count!"
	},
	"less_time" = {
		"key" = "less_time",
		"text" = "Shrinking Timer",
		"description" = "The timer starts at 5s and decreases by -0.2s every round, down to 1s!"
	},
	"fair_game" = {
		"key" = "fair_game",
		"text" = "Fair Game",
		"description" = "AI will get 1 point every 3 rounds"
	}
}

@onready var button_template: Button = $button_template

var chosen_difficulty: String = "easy"
var chosen_gamemode: String = "endless"
var chosen_modifier: String = ""

func _ready() -> void:
	for key in gamemode_config.keys():
		var button = _create_button(
			gamemode_config[key].key,
			gamemode_config[key].description,
			gamemode_config[key].text,
			$gamemodes
		)
		
		button.pressed.connect(_on_option_pressed.bind(["gamemode", button.name]))
		
	for key in difficulty_config.keys():
		var button = _create_button(
			difficulty_config[key].key,
			difficulty_config[key].description,
			difficulty_config[key].text,
			$difficulties
		)
		
		button.pressed.connect(_on_option_pressed.bind(["difficulty", button.name]))
	
	for key in modifier_config.keys():
		var button = _create_button(
			modifier_config[key].key,
			modifier_config[key].description,
			modifier_config[key].text,
			$modifiers
		)
		
		button.pressed.connect(_on_option_pressed.bind(["modifier", button.name]))


func _create_button(key: String, tooltip: String, text: String, parent) -> Button:
	var clone: Button = button_template.duplicate()
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

func _on_no_modifier_pressed():
	chosen_modifier = ""
	
func _on_random_modifier_pressed():
	chosen_modifier = modifier_config.keys().pick_random()

func get_selected_options() -> Dictionary:
	return {
		difficulty = difficulty_config[chosen_difficulty], 
		gamemode = gamemode_config[chosen_gamemode],
		modifier = modifier_config[chosen_modifier] if chosen_modifier != "" else null
	}

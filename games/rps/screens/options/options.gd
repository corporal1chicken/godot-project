extends Control

@export var difficulty_info: Dictionary = {
	"easy" = {
		timer_length = 8.0,
	},
	"medium" = {
		timer_length = 5.0,
	},
	"hard" = {
		timer_length = 3.0
	}
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

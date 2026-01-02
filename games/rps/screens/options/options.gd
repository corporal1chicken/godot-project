extends Control

#Could likely do one function with match, both loop through children and
#call the same function to avoid repeat code

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
		child.pressed.connect(_on_difficulty_pressed.bind(child.name))
		
	for child in $gamemodes.get_children():
		child.pressed.connect(_on_gamemode_pressed.bind(child.name))
		
func _on_difficulty_pressed(difficulty: String):
	chosen_difficulty = difficulty
	$start.text = "start " + chosen_gamemode.replace("_", " ") + " (" + chosen_difficulty + ")"

func _on_gamemode_pressed(gamemode: String):
	chosen_gamemode = gamemode
	$start.text = "start " + chosen_gamemode.replace("_", " ") + " (" + chosen_difficulty + ")"

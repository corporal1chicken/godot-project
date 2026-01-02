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

var chosen_difficulty: Dictionary = difficulty_info.get("easy")

func _ready() -> void:
	for child in $difficulties.get_children():
		child.pressed.connect(_on_difficulty_pressed.bind(child.name))
		
func _on_difficulty_pressed(difficulty: String):
	chosen_difficulty = difficulty_info.get(difficulty)
	$start.text = "start game (" + difficulty + " mode)"

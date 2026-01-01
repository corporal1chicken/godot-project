extends Control

var current_difficulty: String = "easy"

func _ready() -> void:
	for child in $difficulties.get_children():
		child.pressed.connect(_on_difficulty_pressed.bind(child.name))
		
func _on_difficulty_pressed(difficulty: String):
	current_difficulty = difficulty
	$start.text = "start game (" + current_difficulty + " mode)"

func _on_start_pressed():
	print("starting")
	pass

extends Control

@onready var options: Control = $options
@onready var main: Control = $main

func _on_start_pressed():
	options.visible = false
	main.visible = true
	
	main.start_game(options.difficulty_info.get(options.chosen_difficulty), options.chosen_gamemode)

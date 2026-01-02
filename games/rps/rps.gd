extends Control

@onready var options: Control = $options
@onready var main: Control = $main

func _on_start_pressed():
	options.visible = false
	main.visible = true
	
	main.start_round(options.chosen_difficulty)

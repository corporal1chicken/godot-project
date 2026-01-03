extends Control

@onready var options: Control = $options
@onready var main: Control = $main

func _ready() -> void:
	Signals.change_sub_screen.connect(_change_sub_screen)

func _on_start_pressed():
	options.visible = false
	main.visible = true
	
	main.begin_game(options.difficulty_info.get(options.chosen_difficulty), options.chosen_gamemode)

func _change_sub_screen(old_screen: String, new_screen: String):
	var old_child: Control = get_node(old_screen)
	var new_child: Control = get_node(new_screen)
	
	old_child.visible = false
	new_child.visible = true

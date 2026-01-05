extends Control

@export var ui_controller: Control

@onready var options: Control = $options
@onready var main: Control = $main

func _ready() -> void:
	Signals.change_sub_screen.connect(_change_sub_screen)

func _on_start_pressed():
	options.visible = false
	main.visible = true
	
	var result = options.get_selected_options()
	
	main.start_game(result.gamemode, result.difficulty)

func _change_sub_screen(old_screen: String, new_screen: String):
	if ui_controller.current_screen != self.name: return
	
	var old_child: Control = get_node(old_screen)
	var new_child: Control = get_node(new_screen)
	
	old_child.visible = false
	new_child.visible = true

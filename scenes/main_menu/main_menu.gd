extends Control

@export var ui_controller: Control

@onready var game_selection: Control = $game_selection

var current_sub_screen: String = "play_screen"

func _ready() -> void:
	Signals.change_sub_screen.connect(_change_sub_screen)

func _on_play_pressed():
	_change_sub_screen("play_screen", "selection")

func _change_sub_screen(old_screen: String, new_screen: String):
	if ui_controller.current_screen != self.name: return
	
	var old_child: Control = get_node(old_screen)
	var new_child: Control = get_node(new_screen)
	
	old_child.visible = false
	new_child.visible = true
	current_sub_screen = new_screen

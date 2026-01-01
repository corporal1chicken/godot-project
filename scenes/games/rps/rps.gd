extends Control

@onready var difficulty_menu: BoxContainer = $CanvasLayer/difficulty/menu

var chosen_difficulty = "easy"

func _ready() -> void:
	for child in difficulty_menu.get_children():
		child.pressed.connect(_on_difficulty_option_pressed.bind(child))
	
	pass

func change_visibility(change: bool):
	for child in get_children():
		
		child.visible = change
		
		pass
		
	pass

func _on_difficulty_pressed():
	difficulty_menu.visible = not difficulty_menu.visible
	
	pass
	
func _on_difficulty_option_pressed(button: Button):
	chosen_difficulty = button.name
	$CanvasLayer/difficulty.text = "chosen: " + chosen_difficulty
	
	pass
